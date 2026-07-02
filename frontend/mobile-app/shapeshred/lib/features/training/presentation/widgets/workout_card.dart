import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/constants/app_colors.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String duration;
  final String level;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey100,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.fitness_center,
                color: AppColors.grey500, size: 32.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$duration • $level',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
