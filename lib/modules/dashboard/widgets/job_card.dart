import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import '../models/dashboard_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final Color accentColor;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.08),
              offset: Offset(0, 2.h),
              blurRadius: 8.r,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/icons/briefcase.png',
                      width: 20.w,
                      height: 20.w,
                      color: accentColor,
                    ),
                  ),
                ),

                AppSpace.w10,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: sb14.copyWith(color: AppColor.textPrimary),
                      ),
                      AppSpace.h4,
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/location.png',
                            height: 16.w,
                            width: 16.w,
                            color: AppColor.textSecondary,
                          ),
                          AppSpace.w4,
                          Expanded(
                            child: Text(
                              job.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: n12.copyWith(
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                AppSpace.w10,

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Active',
                    style: sb10.copyWith(color: accentColor),
                  ),
                ),
              ],
            ),

            AppSpace.h10,

            Divider(height: 1, color: AppColor.divider),

            AppSpace.h10,

            Row(
              children: [
                Expanded(
                  child: _JobStat(
                    imagePath: 'assets/icons/man.png',
                    text: 'Vacancies:',
                    value: '${job.vacancies}',
                  ),
                ),

                _Divider(),

                Expanded(
                  child: _JobStat(
                    imagePath: 'assets/icons/tick.png',
                    text: 'Selected:',
                    value: '${job.selected}',
                    valueColor: AppColor.success,
                  ),
                ),

                _Divider(),

                Expanded(
                  child: _JobStat(
                    imagePath: 'assets/icons/skill.png',
                    text: job.department,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JobStat extends StatelessWidget {
  final String imagePath;
  final String text;
  final String? value;
  final Color? valueColor;

  const _JobStat({
    required this.imagePath,
    required this.text,
    this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          height: 16.w,
          width: 16.w,
          color: AppColor.textSecondary,
        ),
        AppSpace.w4,
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: text,
              style: n10.copyWith(color: AppColor.textSecondary),
              children: value == null
                  ? null
                  : [
                      TextSpan(
                        text: ' $value',
                        style: sb10.copyWith(
                          color: valueColor ?? AppColor.textPrimary,
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20.h,
      color: AppColor.border,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}
