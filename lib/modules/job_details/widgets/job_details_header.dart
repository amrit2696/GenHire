import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class JobDetailsHeader extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final String status;

  const JobDetailsHeader({
    super.key,
    required this.title,
    required this.location,
    required this.category,
    this.status = 'Active',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.22),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/rs.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(color: AppColor.primary);
                },
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xDD452DCE), // Strong transparent blue
                      Color(0xDD3830B8), // Medium blue
                      AppColor.primary, // Solid primary blue
                    ],
                  ),
                ),
              ),
            ),

            // Header Content
            Padding(
              padding: EdgeInsets.all(22.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 62.r,
                        height: 62.r,
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.17),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.white.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Icon(
                          Icons.work_outline_rounded,
                          size: 32.r,
                          color: AppColor.white,
                        ),
                      ),
                      AppSpace.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: sb20.copyWith(
                                color: AppColor.white,
                                height: 1.25,
                              ),
                            ),
                            AppSpace.h8,
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColor.white,
                                  size: 18.r,
                                ),
                                AppSpace.w4,
                                Expanded(
                                  child: Text(
                                    location,
                                    style: n14.copyWith(color: AppColor.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpace.h20,
                  Divider(
                    color: AppColor.white.withValues(alpha: 0.55),
                    height: 1,
                  ),
                  AppSpace.h16,
                  Row(
                    children: [
                      Expanded(
                        child: _HeaderInfo(
                          label: 'Category',
                          value: category.isEmpty ? 'Not specified' : category,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 42.h,
                        color: AppColor.white.withValues(alpha: 0.4),
                      ),
                      Expanded(
                        child: _HeaderInfo(
                          label: 'Status',
                          value: status,
                          centered: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool centered;

  const _HeaderInfo({
    required this.label,
    required this.value,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: n12.copyWith(color: AppColor.white.withValues(alpha: 0.85)),
          ),
          AppSpace.h8,
          Text(
            value,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sb14.copyWith(color: AppColor.white),
          ),
        ],
      ),
    );
  }
}
