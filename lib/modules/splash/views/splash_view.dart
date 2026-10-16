import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/app/routes/app_routes.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/theme/app_theme.dart';
import 'package:ghire/core/utils/text_style.dart' hide sb14, n14;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _glowController;
  late AnimationController _dotController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_logoController);

    _rotationAnimation = Tween<double>(begin: -0.12, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _slideAnimation = Tween<double>(begin: 40.h, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(begin: 20.r, end: 45.r).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _logoController.forward();

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.welcome);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _glowController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (context, child) {
        final value = sin((_dotController.value * 2 * pi) - (index * 0.6));

        return Transform.scale(
          scale: 0.8 + (value.abs() * 0.5),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _glowController,
          _dotController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryDark,
                  AppColor.primary,
                  AppColor.secondary,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Top decorative circle
                Positioned(
                  top: -80.h,
                  right: -50.w,
                  child: Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryLight.withValues(alpha: 0.12),
                    ),
                  ),
                ),

                // Bottom decorative circle
                Positioned(
                  bottom: -120.h,
                  left: -60.w,
                  child: Container(
                    width: 300.w,
                    height: 300.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryDark.withValues(alpha: 0.18),
                    ),
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GHire Logo
                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Glow
                                    Container(
                                      width: 250.w,
                                      height: 150.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.primaryLight
                                                .withValues(alpha: 0.35),
                                            blurRadius: _glowAnimation.value,
                                            spreadRadius: 12.r,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // GHire text container
                                    Container(
                                      width: 250.w,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 25.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(
                                          36.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.black.withValues(
                                              alpha: 0.15,
                                            ),
                                            blurRadius: 25.r,
                                            offset: Offset(0, 12.h),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'GHire',
                                          textAlign: TextAlign.center,
                                          style: xb34.copyWith(
                                            color: AppColor.primaryDark,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        AppSpace.h40,

                        // Application tagline
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'SMARTER HIRING',
                            textAlign: TextAlign.center,
                            style: sb14.copyWith(
                              color: AppColor.white.withValues(alpha: 0.90),
                              letterSpacing: 4,
                            ),
                          ),
                        ),

                        AppSpace.h8,

                        // Application name
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'GHire',
                            textAlign: TextAlign.center,
                            style: xb30.copyWith(
                              color: AppColor.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        AppSpace.h12,

                        // Description
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Text(
                              'Build better teams with smarter recruitment and modern HR solutions.',
                              textAlign: TextAlign.center,
                              style: n14.copyWith(
                                color: AppColor.primaryLight,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        AppSpace.h40,

                        // Loading dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [buildDot(0), buildDot(1), buildDot(2)],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
