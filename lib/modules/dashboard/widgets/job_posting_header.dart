import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class JobPostingsHeader extends StatelessWidget {
  final int totalJobs;
  final VoidCallback onAddJob;

  const JobPostingsHeader({
    super.key,
    required this.totalJobs,
    required this.onAddJob,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '📋 Job Postings',
                  style: b18.copyWith(color: AppColor.textPrimary),
                ),
                AppSpace.w10,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$totalJobs Total Jobs',
                    style: sb10.copyWith(color: AppColor.primary),
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: onAddJob,
            icon: Image.asset(
              'assets/icons/add.png',
              width: 20.w,
              height: 20.w,
              color: AppColor.white,
            ),
            label: Text('Add Job', style: sb12.copyWith(color: AppColor.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              elevation: 5,
              shadowColor: AppColor.primary.withValues(alpha: 0.25),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
