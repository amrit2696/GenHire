import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class DashboardSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int step;
  final int total;
  final Widget child;

  const DashboardSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.total,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          top: BorderSide(color: AppColor.accent, width: 3.h),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.10),
            offset: Offset(0, 4.h),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: AppColor.white, size: 20.sp),
              ),

              AppSpace.w12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: b16.copyWith(color: AppColor.primary)),
                    AppSpace.h2,
                    Text(
                      subtitle,
                      style: n12.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$step/$total',
                  style: sb10.copyWith(color: AppColor.primary),
                ),
              ),
            ],
          ),

          AppSpace.h16,

          Divider(height: 1, color: AppColor.divider),

          AppSpace.h16,

          child,
        ],
      ),
    );
  }
}
