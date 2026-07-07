import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hasTrailing;

  SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hasTrailing = true,
  });
}

class SettingsList extends StatelessWidget {
  final List<SettingsItem> items;

  const SettingsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorPalette.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
        border: Border.all(color: AppColorPalette.gray200),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsTile(item: items[i]),
            if (i < items.length - 1)
              Padding(
                padding: EdgeInsets.only(left: 56.w),
                child: Divider(
                  color: AppColorPalette.gray100,
                  height: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final SettingsItem item;

  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space16.h,
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColorPalette.gray50,
                borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
              ),
              child: Icon(
                item.icon,
                color: AppColorPalette.gray900,
                size: 20.sp,
              ),
            ),
            SizedBox(width: AppSpacing.space16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    SizedBox(height: AppSpacing.space2.h),
                    Text(
                      item.subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.hasTrailing)
              Icon(
                Icons.chevron_right,
                color: AppColorPalette.gray400,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
