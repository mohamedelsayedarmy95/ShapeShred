import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String level;
  final String memberSince;
  final String? avatarUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.level,
    required this.memberSince,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColorPalette.gray900, AppColorPalette.gray800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColorPalette.gray900.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColorPalette.pureWhite,
                width: 3,
              ),
              color: AppColorPalette.gray700,
            ),
            child: avatarUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColorPalette.gray700,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColorPalette.pureWhite,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColorPalette.gray700,
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: AppColorPalette.pureWhite,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'A',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColorPalette.pureWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: AppSpacing.space16.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColorPalette.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorPalette.gray700,
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        color: AppColorPalette.pureWhite,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        level,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColorPalette.pureWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  memberSince,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColorPalette.gray400,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColorPalette.gray700,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_outlined,
                color: AppColorPalette.pureWhite,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
