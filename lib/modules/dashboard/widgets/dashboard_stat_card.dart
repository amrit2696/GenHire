import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class DashboardStatCard extends StatelessWidget {
  final String label;
  final int value;
  final String imagePath;
  final Color iconColor;
  final Color backgroundColor;

  const DashboardStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.imagePath,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.w,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            offset: Offset(0, 2.h),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              imagePath,
              width: 24.w,
              height: 24.w,
              color: iconColor,
            ),
          ),
          AppSpace.h8,
          Text('$value', style: xb24.copyWith(color: AppColor.textPrimary)),
          AppSpace.h2,
          Text(label, style: n12.copyWith(color: AppColor.textSecondary)),
        ],
      ),
    );
  }
}
