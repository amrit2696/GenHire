import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class JobDescriptionCard extends StatelessWidget {
  final String title;
  final List<String> details;

  const JobDescriptionCard({
    super.key,
    this.title = 'Job Description',
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColor.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.045),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColor.primary,
                size: 26.r,
              ),
              AppSpace.w10,
              Expanded(
                child: Text(
                  title,
                  style: sb18.copyWith(color: AppColor.textPrimary),
                ),
              ),
            ],
          ),
          AppSpace.h16,
          ...details.map(
            (detail) => Padding(
              padding: EdgeInsets.only(bottom: 9.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: n14),
                  Expanded(
                    child: Text(
                      detail,
                      style: n14.copyWith(
                        color: AppColor.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
