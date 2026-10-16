import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/theme/app_theme.dart';

class AppButton extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.suffix,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColor.buttonPrimary;

    final textColor = widget.textColor ?? AppColor.buttonText;

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
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: textColor,
                  elevation: 10,
                  shadowColor: AppColor.primary.withValues(alpha: 0.40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: sb16.copyWith(
                        color: textColor,
                        letterSpacing: 1.5,
                      ),
                    ),

                    if (widget.suffix != null) ...[
                      AppSpace.w10,
                      widget.suffix!,
                    ],
                  ],
                ),
              ),
            ),

            // Shimmer
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    final position = (_shimmerController.value * 2) - 1;

                    return FractionalTranslation(
                      translation: Offset(position, 0),
                      child: Transform.rotate(
                        angle: 0.25,
                        child: Container(
                          width: 55.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColor.white.withValues(alpha: 0.18),
                                AppColor.white.withValues(alpha: 0.45),
                                AppColor.white.withValues(alpha: 0.18),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
