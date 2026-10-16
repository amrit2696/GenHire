import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class HiringProgressCard extends StatelessWidget {
  final int selected;
  final int total;
  final double progress;

  const HiringProgressCard({
    super.key,
    required this.selected,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiring Progress',
            style: sb16.copyWith(color: AppColor.textPrimary),
          ),
          AppSpace.h16,
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9.h,
              backgroundColor: AppColor.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
          ),
          AppSpace.h10,
          Center(
            child: Text(
              '$selected out of $total positions filled',
              style: n12.copyWith(color: AppColor.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
