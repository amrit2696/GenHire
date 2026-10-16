import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 420.h,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/of.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(color: AppColor.primary);
                },
              ),
            ),

            // Coral Overlay
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 35.h,
                  bottom: 30.h,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Text(
                      'GHire',
                      style: xb30.copyWith(
                        color: AppColor.white,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const Spacer(),

                    // Hero Content
                    Text(
                      "Building Tomorrow's Workforce",
                      style: xb34.copyWith(color: AppColor.white, height: 1.23),
                    ),

                    AppSpace.h12,

                    Text(
                      "Transform your hiring strategy with GHire's "
                      "comprehensive recruitment and HR solutions. "
                      "From talent acquisition to workforce management, "
                      "we've got you covered.",
                      style: n16.copyWith(
                        color: AppColor.white.withValues(alpha: 0.90),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
