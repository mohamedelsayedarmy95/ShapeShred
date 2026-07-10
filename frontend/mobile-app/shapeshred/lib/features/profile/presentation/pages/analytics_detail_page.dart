import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/services/advanced_analytics_service.dart';
import 'dart:math' as math;
import 'package:shapeshred/features/training/data/workout_history_repository.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/core/error/failures.dart';

class AnalyticsDetailPage extends StatefulWidget {
  const AnalyticsDetailPage({super.key});

  @override
  State<AnalyticsDetailPage> createState() => _AnalyticsDetailPageState();
}

class _AnalyticsDetailPageState extends State<AnalyticsDetailPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _trendAnalysis;
  Map<String, dynamic>? _prediction;
  List<Map<String, dynamic>>? _recommendations;
  Map<String, dynamic>? _recoveryStatus;
  List<Map<String, dynamic>> _workoutHistory = [];
  late final WorkoutHistoryRepository _workoutRepository;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    _userId = user.uid;
    _workoutRepository = FirebaseWorkoutHistoryRepository(
      firestore: FirebaseFirestore.instance,
      userId: user.uid,
    );

    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Get real workout data from repository
      final workoutSnapshot = await _workoutRepository.getWorkoutHistory().first;
      _workoutHistory = workoutSnapshot;

      // Analyze performance trends
      _trendAnalysis =
          await AdvancedAnalyticsService.analyzePerformanceTrends(_workoutHistory);

      // Predict next workout
      _prediction =
          await AdvancedAnalyticsService.predictNextWorkout(_workoutHistory);

      // Get user preferences for recommendations
      final String primaryGoal = await PreferencesService.getUserGoal() ?? 'build_muscle';
      final String fitnessLevel = await PreferencesService.getFitnessLevel() ?? 'intermediate';

      // Generate recommendations
      _recommendations = await AdvancedAnalyticsService.generateRecommendations(
        _workoutHistory,
        primaryGoal,
        fitnessLevel,
      );

      // Assess recovery status (using last 3 workouts)
      final List<Map<String, dynamic>> recentWorkouts =
          _workoutHistory.take(3).toList();
      _recoveryStatus = await AdvancedAnalyticsService.assessRecoveryStatus(
          recentWorkouts);
    } catch (e) {
      // In a real app, show error message
      debugPrint('Error loading analytics: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTextColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Analytics Detail',
          style: AppTypography.headlineSmall.copyWith(
            color: AppTextColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.screenPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrendCard(),
                  SizedBox(height: AppSpacing.space24.h),
                  _buildPredictionCard(),
                  SizedBox(height: AppSpacing.space24.h),
                  _buildRecommendationsCard(),
                  SizedBox(height: AppSpacing.space24.h),
                  _buildRecoveryCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trend',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          _buildTrendContent(),
        ],
      ),
    );
  }

  Widget _buildTrendContent() {
    if (_trendAnalysis == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final String trend = _trendAnalysis!['trend'] as String? ?? 'unknown';
    final double volumeChange = (_trendAnalysis!['volumeChange'] as num?)?.toDouble() ?? 0.0;
    final double intensityChange =
        (_trendAnalysis!['intensityChange'] as num?)?.toDouble() ?? 0.0;
    final bool isPlateau = _trendAnalysis!['isPlateau'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trend description
        Text(
          _getTrendDescription(trend),
          style: AppTypography.bodyLarge.copyWith(
            color: _getTrendColor(trend),
          ),
        ),
        SizedBox(height: AppSpacing.space12.h),
        // Simple line chart for volume trend
        SizedBox(
          height: 120.h,
          child: VolumeTrendChart(
            workoutHistory: _workoutHistory,
          ),
        ),
        SizedBox(height: AppSpacing.space12.h),
        // Metrics
        Wrap(
          spacing: AppSpacing.space16.w,
          runSpacing: AppSpacing.space8.h,
          children: [
            _buildMetricCard('Volume Change', '${volumeChange.toStringAsFixed(2)}'),
            _buildMetricCard(
                'Intensity Change', '${(intensityChange * 100).toStringAsFixed(1)}%'),
            _buildMetricCard('Plateau Detected', isPlateau ? 'Yes' : 'No'),
          ],
        ),
      ],
    );
  }

  String _getTrendDescription(String trend) {
    switch (trend) {
      case 'strong_improvement':
        return 'Strong improvement in both volume and intensity!';
      case 'moderate_improvement':
        return 'Good progress! Consider increasing intensity for continued gains.';
      case 'maintenance':
        return 'Maintaining fitness level. Try varying your routine for growth.';
      case 'potential_overtraining':
        return 'Volume decreasing significantly. Consider rest or reduced intensity.';
      case 'plateau_detected':
        return 'You\'ve hit a plateau! Try varying volume and intensity.';
      case 'needs_attention':
        return 'Performance may be plateauing. Try changing your routine.';
      default:
        return 'Insufficient data to determine trend.';
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'strong_improvement':
      case 'moderate_improvement':
        return AppColors.success;
      case 'plateau_detected':
      case 'needs_attention':
        return AppColors.warning;
      case 'potential_overtraining':
        return AppColors.error;
      default:
        return AppTextColors.secondary;
    }
  }

  Widget _buildMetricCard(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTextColors.primary,
          ),
        ),
        SizedBox(height: AppSpacing.space4.h),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppTextColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Workout Prediction',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          _prediction == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested Volume: ${_prediction!['suggestedVolume'] ?? 'N/A'}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppTextColors.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8.h),
                    Text(
                      'Suggested Intensity (RPE): ${(_prediction!['suggestedIntensity'] as num?)?.toStringAsFixed(1) ?? 'N/A'}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppTextColors.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8.h),
                    Text(
                      'Confidence: ${(_prediction!['confidence'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTextColors.secondary,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          _recommendations == null || _recommendations!.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recommendations!.length,
                  itemBuilder: (context, index) {
                    final rec = _recommendations![index];
                    return _RecommendationItem(
                      icon: rec['icon'] as IconData? ?? Icons.tips_and_updates,
                      title: rec['title'] as String? ?? 'Recommendation',
                      description: rec['description'] as String? ?? '',
                      priority: rec['priority'] as String? ?? 'medium',
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildRecoveryCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.cardPadding.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recovery Status',
            style: AppTypography.titleMedium.copyWith(
              color: AppTextColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.space16.h),
          _recoveryStatus == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Level: ${_recoveryStatus!['riskLevel'] ?? 'unknown'}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: _getRiskColor(_recoveryStatus!['riskLevel']),
                      ),
                    ),
                    SizedBox(height: AppSpacing.space12.h),
                    Text(
                      'Recommendations:',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTextColors.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8.h),
                    ...(_recoveryStatus!['recommendations'] as List<dynamic>?)
                            ?.map((rec) => Padding(
                                  padding:
                                      EdgeInsets.only(bottom: AppSpacing.space4.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: AppColors.success,
                                      ),
                                      SizedBox(width: AppSpacing.space8.w),
                                      Expanded(
                                        child: Text(
                                          rec.toString(),
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppTextColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )) ??
                        [],
                  ],
                ),
        ],
      ),
    );
  }

  Color _getRiskColor(dynamic riskLevel) {
    switch (riskLevel) {
      case 'high':
        return AppColors.error;
      case 'moderate':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppTextColors.secondary;
    }
  }
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String priority;

  const _RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final Color priorityColor = {
      'high': AppColors.error,
      'medium': AppColors.warning,
      'low': AppColors.info,
    }[priority] ?? AppTextColors.secondary;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: priorityColor),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTextColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple line chart widget for volume trend
class VolumeTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> workoutHistory;

  const VolumeTrendChart({
    super.key,
    required this.workoutHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (workoutHistory.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Calculate volume for each workout
    final List<double> volumes = workoutHistory.map((workout) {
      double volume = 0.0;
      for (final exercise in (workout['exercises'] as List? ?? const [])) {
        final double weight = (exercise['weight'] as num?)?.toDouble() ?? 0.0;
        final double reps = (exercise['reps'] as num?)?.toDouble() ?? 0.0;
        final double sets = (exercise['set'] as num?)?.toDouble() ?? 0.0;
        volume += weight * reps * sets;
      }
      return volume;
    }).toList();

    return CustomPaint(
      size: Size.fromHeight(100.h),
      painter: _VolumeChartPainter(volumes),
    );
  }
}

class _VolumeChartPainter extends CustomPainter {
  final List<double> values;
  final Paint _linePaint = Paint()
    ..color = AppColors.primary
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  final Paint _pointPaint = Paint()
    ..color = AppColors.primary
    ..style = PaintingStyle.fill;
  final Paint _gridPaint = Paint()
    ..color = AppColors.outline.withValues(alpha: 0.2)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  _VolumeChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final double width = size.width;
    final double height = size.height;
    final double padding = 20.0; // Space for labels
    final double chartWidth = width - 2 * padding;
    final double chartHeight = height - 2 * padding;

    // Find min and max values for scaling
    double minVal = values.reduce(math.min);
    double maxVal = values.reduce(math.max);
    if (maxVal == minVal) {
      maxVal = minVal + 1; // Avoid division by zero
    }

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final double y = padding + (chartHeight * (1 - i / 4));
      canvas.drawLine(
        Offset(padding, y),
        Offset(width - padding, y),
        _gridPaint,
      );
    }

    // Draw vertical grid lines (for each point)
    for (int i = 0; i < values.length; i++) {
      final double x = padding + (chartWidth * i / (values.length - 1));
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, height - padding),
        _gridPaint,
      );
    }

    // Draw the line chart
    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final double x =
          padding + (chartWidth * i / (values.length - 1));
      final double normalized =
          (values[i] - minVal) / (maxVal - minVal);
      final double y = padding + (chartHeight * (1 - normalized));
      points.add(Offset(x, y));
    }

    // Draw lines between points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], _linePaint);
    }

    // Draw points
    for (final Offset point in points) {
      canvas.drawCircle(point, 3.0, _pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}