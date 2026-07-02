import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/constants/app_colors.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            // Tabs
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  _buildTab('HIIT', true),
                  _buildTab('Strength', false),
                  _buildTab('Yoga', false),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey200),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child:
                              const Icon(Icons.play_arrow, color: AppColors.grey600),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Workout ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                '${12 + index * 5} min • ${4 + index} exercises',
                                style: TextStyle(
                                  color: AppColors.grey500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: AppColors.grey400, size: 16.sp),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.grey600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
