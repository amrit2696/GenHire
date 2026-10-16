import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/theme/app_theme.dart';


class WelcomeCatchyCard extends StatelessWidget {
  const WelcomeCatchyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.r),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.primary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.20),
            offset: Offset(0, 4.h),
            blurRadius: 12.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🚀',
            style: TextStyle(
              fontSize: 44.sp,
            ),
          ),

          AppSpace.h10,

          Text(
            'Hire Smarter, Grow Faster',
            textAlign: TextAlign.center,
            style: xb24.copyWith(
              color: AppColor.textPrimary,
            ),
          ),

          AppSpace.h10,

          Text(
            "GHire empowers you to build high-performing teams "
            "with cutting-edge recruitment technology and expert "
            "HR solutions.",
            textAlign: TextAlign.center,
            style: n16.copyWith(
              color: AppColor.textSecondary,
              height: 1.47,
            ),
          ),
        ],
      ),
    );
  }
}