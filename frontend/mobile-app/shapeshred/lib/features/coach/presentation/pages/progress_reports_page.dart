import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shapeshred/core/constants/app_colors.dart';
import 'package:shapeshred/features/coach/domain/entities/report_entity.dart';

class ProgressReportsPage extends StatefulWidget {
  const ProgressReportsPage({super.key});

  @override
  State<ProgressReportsPage> createState() => _ProgressReportsPageState();
}

class _ProgressReportsPageState extends State<ProgressReportsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Center(child: Text('Please login'));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Progress Reports',
            style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection('reports')
            .where('userId', isEqualTo: currentUser.uid)
            .orderBy('date', descending: true)
            .limit(10)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.black));
          }

          final reports = snapshot.data!.docs.map((doc) {
            return ProgressReport.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 80.sp, color: AppColors.grey300),
                  SizedBox(height: 16.h),
                  Text(
                    'No reports available',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildReportCard(report);
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(ProgressReport report) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(report.date),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black),
              ),
              Text(
                '${report.workoutsCompleted} workouts',
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey600),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Weight', '${report.weight.toStringAsFixed(1)} kg'),
              _buildStat('Body Fat', '${report.bodyFat.toStringAsFixed(1)}%'),
              _buildStat(
                  'Muscle', '${report.muscleMass.toStringAsFixed(1)} kg'),
              _buildStat('Calories', '${report.caloriesBurned}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black)),
        Text(label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.grey500)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
