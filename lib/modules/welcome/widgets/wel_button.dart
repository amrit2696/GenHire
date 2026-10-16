import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class WelcomeGetStartedButton extends StatelessWidget {
  final VoidCallback? onTap;

  const WelcomeGetStartedButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Button
            Positioned.fill(
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 10,
                  shadowColor: AppColor.primary.withValues(alpha: 0.40),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GET STARTED',
                      style: sb16.copyWith(
                        color: AppColor.white,
                        letterSpacing: 1.5,
                      ),
                    ),

                    AppSpace.w10,

                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 26.sp,
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            ),

            // Shimmer overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Shimmer.fromColors(
                  period: const Duration(milliseconds: 1800),
                  baseColor: Colors.transparent,
                  highlightColor: AppColor.white.withValues(alpha: 0.30),
                  direction: ShimmerDirection.ltr,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.20),
                          Colors.white.withValues(alpha: 0.45),
                          Colors.white.withValues(alpha: 0.20),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
