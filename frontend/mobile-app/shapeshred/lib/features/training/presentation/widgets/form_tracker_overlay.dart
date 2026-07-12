import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:shapeshred/training/domain/services/form_analysis_engine.dart';
import 'package:shapeshred/training/domain/services/ai_coach_service.dart';

/// Widget that overlays a skeleton on the camera preview using ML Kit pose detection.
class FormTrackerOverlay extends StatefulWidget {
  const FormTrackerOverlay({super.key});

  @override
  State<FormTrackerOverlay> createState() => _FormTrackerOverlayState();
}

class _FormTrackerOverlayState extends State<FormTrackerOverlay> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  PoseDetector? _poseDetector;
  Timer? _frameTimer;
  Timer? _analysisTimer;
  Timer? _cueDisplayTimer;
  CameraImage? _latestCameraImage;
  bool _isProcessing = false;
  List<Offset> _keypoints = List.filled(17, Offset.zero);
  int _imageWidth = 0;
  int _imageHeight = 0;
  final FormAnalysisEngine _formAnalysisEngine = FormAnalysisEngine();
  final AiCoachService _aiCoachService = AiCoachService();
  String? _lastFeedback;
  String? _aiCoachingCue;
  bool _isFetchingAI = false;
  bool _showCue = false;

  @override
  void initState() {
    super.initState();
    // Initialize camera and pose detector (fire-and-forget, errors handled in method)
    _initializeCameraAndDetector();
    // Process frames every 100ms for smooth visualization
    _frameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) => _processFrameIfAvailable());
    // Analyze form every 2 seconds to avoid overloading
    _analysisTimer = Timer.periodic(const Duration(seconds: 2), (_) => _analyzeFormIfReady());
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _analysisTimer?.cancel();
    _cueDisplayTimer?.cancel();
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  Future<void> _initializeCameraAndDetector() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      _cameraController!.startImageStream((image) {
        _latestCameraImage = image;
      });

      // Initialize the pose detector
      _poseDetector = PoseDetector(options: PoseDetectorOptions());
    } catch (e) {
      debugPrint('Failed to initialize camera or pose detector: $e');
    }
  }

  void _processFrameIfAvailable() {
    if (_isProcessing || !_isCameraInitialized || _latestCameraImage == null) return;
    _isProcessing = true;
    final image = _latestCameraImage!;
    _latestCameraImage = null;

    final inputImage = InputImage.fromBytes(
      bytes: Uint8List.fromList(image.planes.map((plane) => plane.bytes).expand((bytes) => bytes).toList()),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg, // TODO: handle device orientation properly
        format: InputImageFormat.yuv420,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    _imageWidth = image.width;
    _imageHeight = image.height;

    _poseDetector?.processImage(inputImage).then((poses) {
      if (poses.isNotEmpty) {
        final pose = poses.first;
        _updateKeypointsFromPose(pose, image.width, image.height);
      }
    }).catchError((Object error) {
      debugPrint('Pose detection error: $error');
    }).whenComplete(() {
      _isProcessing = false;
    });
  }

  void _analyzeFormIfReady() {
    if (!_isCameraInitialized || _isProcessing) return;

    // Only analyze if we have valid keypoints
    final bool hasValidKeypoints = _keypoints.any((point) => point != Offset.zero);
    if (!hasValidKeypoints) return;

    final String? flaw = _formAnalysisEngine.analyzeSquat(_keypoints);
    if (flaw != null && flaw != _lastFeedback) {
      setState(() {
        _lastFeedback = flaw;
      });

      // Generate and get coaching cue from AI service
      final String prompt = _formAnalysisEngine.generateCoachPrompt('squat', flaw);
      debugPrint('COACH PROMPT: $prompt');

      // Only fetch AI cue if not already fetching
      if (!_isFetchingAI) {
        _fetchAICoachingCue(prompt);
      }
    } else if (flaw == null && _lastFeedback != null) {
      // Clear feedback when form is good
      setState(() {
        _lastFeedback = null;
        _aiCoachingCue = null;
      });
      debugPrint('COACH FEEDBACK: Form looks good!');
    }
  }

  void _updateKeypointsFromPose(Pose pose, int imageWidth, int imageHeight) {
    final List<PoseLandmark> landmarks = pose.landmarks.values.toList();
    final List<Offset> points = [];
    for (int i = 0; i < 17; i++) {
      if (i < landmarks.length) {
        final landmark = landmarks[i];
        final double x = landmark.x * imageWidth;
        final double y = landmark.y * imageHeight;
        points.add(Offset(x, y));
      } else {
        // Fallback to zero if landmark missing (shouldn't happen with MoveNet)
        points.add(Offset.zero);
      }
    }
    setState(() {
      _keypoints = points;
    });
  }

  void _fetchAICoachingCue(String prompt) async {
    setState(() {
      _isFetchingAI = true;
    });

    final cue = await _aiCoachService.getCoachingCue(prompt);
    if (!mounted) return;

    setState(() {
      _aiCoachingCue = cue;
      _isFetchingAI = false;
      if (cue != null) {
        _showCue = true;
        // Hide cue after 4 seconds
        _cueDisplayTimer?.cancel();
        _cueDisplayTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _showCue = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;
        return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(_cameraController!),
            CustomPaint(
              size: size,
              painter: _FormTrackerPainter(
                keypoints: _keypoints,
                imageSize: Size(_imageWidth.toDouble(), _imageHeight.toDouble()),
              ),
            ),
            // AI Coaching Cue Display
            if (_aiCoachingCue != null && _showCue)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _aiCoachingCue!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Custom painter that draws the skeleton (points and connections) on a canvas.
class _FormTrackerPainter extends CustomPainter {
  final List<Offset> keypoints;
  final Size imageSize;

  const _FormTrackerPainter({required this.keypoints, required this.imageSize});

  // Define connections for MoveNet (17 keypoints)
  static const List<List<int>> _connections = [
    [0, 1], [0, 2], [1, 3], [2, 4], // face
    [5, 6], [5, 7], [7, 9], [6, 8], [8, 10], // arms
    [5, 11], [6, 12], // shoulders to hips
    [11, 12], [11, 13], [13, 15], [12, 14], [14, 16] // legs
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (keypoints.length != 17) return;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    // Scale points to widget size
    final scaledPoints = keypoints
        .map((p) => Offset(p.dx * scaleX, p.dy * scaleY))
        .toList();

    // Paint for lines (bones) - White-Hero palette: deep charcoal
    final linePaint = Paint()
      ..color = const Color(0xFF1A1A1A).withValues(alpha: 0.8) // deep charcoal
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint for joints (dots) - White-Hero palette: primary color (white)
    final dotPaint = Paint()
      ..color = const Color(0xFFFFFFFF) // white
      ..style = PaintingStyle.fill;

    // Draw connections
    for (final connection in _connections) {
      final start = scaledPoints[connection[0]];
      final end = scaledPoints[connection[1]];
      canvas.drawLine(start, end, linePaint);
    }

    // Draw keypoints (only if within bounds)
    for (final point in scaledPoints) {
      if (point.dx >= 0 && point.dy >= 0 && point.dx <= size.width && point.dy <= size.height) {
        canvas.drawCircle(point, 4.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FormTrackerPainter oldDelegate) {
    return !listEquals(keypoints, oldDelegate.keypoints);
  }

  bool listEquals(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}