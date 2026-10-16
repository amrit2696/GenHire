import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/space/space.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const LoginButton({super.key, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.6),
          elevation: 8,
          shadowColor: AppColor.primary.withValues(alpha: 0.30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColor.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign In', style: sb20.copyWith(color: AppColor.white)),

                  AppSpace.w12,

                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColor.white,
                    size: 32.sp,
                  ),
                ],
              ),
      ),
    );
  }
}
