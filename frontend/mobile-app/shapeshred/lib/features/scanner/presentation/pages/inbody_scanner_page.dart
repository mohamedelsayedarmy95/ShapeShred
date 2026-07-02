import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/constants/app_colors.dart';
import 'package:shapeshred/core/services/ocr_service.dart';
import 'package:shapeshred/features/scanner/domain/entities/inbody_data_entity.dart';

class InBodyScannerPage extends StatefulWidget {
  const InBodyScannerPage({super.key});

  @override
  State<InBodyScannerPage> createState() => _InBodyScannerPageState();
}

class _InBodyScannerPageState extends State<InBodyScannerPage> {
  final OCRService _ocrService = OCRService();
  bool _isLoading = false;
  String _extractedText = '';
  InBodyData? _parsedData;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Scan InBody Report',
            style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Take a photo of your InBody report',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black),
            ),
            SizedBox(height: 8.h),
            Text(
              'The app will automatically extract your body composition data.',
              style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _scanFromCamera,
                    icon: const Icon(Icons.camera_alt, color: AppColors.white),
                    label: Text('Camera', style: TextStyle(fontSize: 14.sp)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _scanFromGallery,
                    icon:
                        const Icon(Icons.photo_library, color: AppColors.black),
                    label: Text('Gallery',
                        style:
                            TextStyle(fontSize: 14.sp, color: AppColors.black)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      side: const BorderSide(color: AppColors.grey200),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_isLoading)
              const Center(
                  child: CircularProgressIndicator(color: AppColors.black)),
            if (_extractedText.isNotEmpty && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Extracted Text:',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Text(
                          _extractedText,
                          style: TextStyle(
                              fontSize: 14.sp, color: AppColors.black),
                        ),
                      ),
                      if (_parsedData != null) ...[
                        SizedBox(height: 16.h),
                        _buildResultCard(),
                      ],
                    ],
                  ),
                ),
              ),
            if (_parsedData != null && !_isLoading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveToFirestore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                  ),
                  child: Text('Save Report',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanFromCamera() async {
    final image = await _ocrService.pickImageFromCamera();
    if (image == null) return;
    await _processImage(image);
  }

  Future<void> _scanFromGallery() async {
    final image = await _ocrService.pickImageFromGallery();
    if (image == null) return;
    await _processImage(image);
  }

  Future<void> _processImage(File image) async {
    setState(() {
      _isLoading = true;
      _extractedText = '';
      _parsedData = null;
    });
    try {
      final text = await _ocrService.extractTextFromImage(image);
      setState(() => _extractedText = text);
      _parseData(text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _parseData(String text) {
    // Simple parsing logic – improve with regex matching based on actual InBody report format
    final weight = _extractNumber(text, r'Weight\s*[:.]?\s*([\d.]+)');
    final bodyFat = _extractNumber(text, r'Body Fat\s*[:.]?\s*([\d.]+)');
    final muscleMass =
        _extractNumber(text, r'Skeletal Muscle\s*[:.]?\s*([\d.]+)');
    final bmi = _extractNumber(text, r'BMI\s*[:.]?\s*([\d.]+)');

    if (weight != null && bodyFat != null) {
      setState(() {
        _parsedData = InBodyData(
          weight: weight,
          bodyFat: bodyFat,
          muscleMass: muscleMass ?? 0,
          bmi: bmi ?? 0,
          visceralFat:
              _extractNumber(text, r'Visceral Fat\s*[:.]?\s*([\d.]+)') ?? 0,
          boneMass: _extractNumber(text, r'Bone Mass\s*[:.]?\s*([\d.]+)') ?? 0,
          protein: _extractNumber(text, r'Protein\s*[:.]?\s*([\d.]+)') ?? 0,
          mineral: _extractNumber(text, r'Mineral\s*[:.]?\s*([\d.]+)') ?? 0,
          totalBodyWater:
              _extractNumber(text, r'Total Body Water\s*[:.]?\s*([\d.]+)') ?? 0,
          measuredAt: DateTime.now(),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not parse data. Please try a clearer photo.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  double? _extractNumber(String text, String pattern) {
    final regExp = RegExp(pattern, caseSensitive: false);
    final match = regExp.firstMatch(text);
    if (match != null && match.groupCount >= 1) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  Widget _buildResultCard() {
    final data = _parsedData!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Composition',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black),
          ),
          SizedBox(height: 12.h),
          _buildStatRow('Weight', '${data.weight.toStringAsFixed(1)} kg'),
          _buildStatRow('Body Fat', '${data.bodyFat.toStringAsFixed(1)} %'),
          _buildStatRow(
              'Muscle Mass', '${data.muscleMass.toStringAsFixed(1)} kg'),
          _buildStatRow('BMI', data.bmi.toStringAsFixed(1)),
          _buildStatRow('Visceral Fat', data.visceralFat.toStringAsFixed(1)),
          _buildStatRow('Bone Mass', '${data.boneMass.toStringAsFixed(1)} kg'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.grey600)),
          Text(value,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black)),
        ],
      ),
    );
  }

  Future<void> _saveToFirestore() async {
    if (_parsedData == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please login first'), backgroundColor: Colors.red),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('inbody_reports')
          .add(_parsedData!.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ Report saved successfully!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
