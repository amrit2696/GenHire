import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/utils/text_style.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/space/space.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  static const String _backgroundImage =
      'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 310.h,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(
                _backgroundImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(color: AppColor.primary);
                },
              ),
            ),

            // Coral overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application name
                  AppSpace.h10,
                  Text(
                    'GHire',
                    style: xb30.copyWith(
                      color: AppColor.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Welcome Back!',
                    style: xb30.copyWith(color: AppColor.white),
                  ),

                  AppSpace.h5,

                  Text(
                    'Sign in to continue your recruitment journey',
                    style: n16.copyWith(
                      color: AppColor.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),

                  AppSpace.h24,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
