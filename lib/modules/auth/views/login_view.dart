import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/space/space.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

import '../controllers/login_controller.dart';
import '../widgets/login_button.dart';
import '../widgets/login_header.dart';
import '../widgets/login_text_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const LoginHeader(),

                Transform.translate(
                  offset: Offset(0, -30.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _LoginFormCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.10),
            offset: Offset(0, 4.h),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email
            LoginTextField(
              label: 'Email Address',
              hintText: 'Enter your email',
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              onSubmitted: () {
                controller.passwordFocusNode.requestFocus();
              },
            ),

            AppSpace.h20,

            // Password
            Obx(
              () => LoginTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: !controller.isPasswordVisible.value,
                textInputAction: TextInputAction.done,
                validator: _validatePassword,
                onSubmitted: controller.login,
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor.primary,
                    size: 24.sp,
                  ),
                ),
              ),
            ),

            AppSpace.h20,

            // Remember Me
            Obx(
              () => InkWell(
                onTap: controller.toggleRememberMe,
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        color: controller.rememberMe.value
                            ? AppColor.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: controller.rememberMe.value
                              ? AppColor.primary
                              : AppColor.border,
                          width: 1.5,
                        ),
                      ),
                      child: controller.rememberMe.value
                          ? Icon(
                              Icons.check,
                              color: AppColor.white,
                              size: 15.sp,
                            )
                          : null,
                    ),

                    AppSpace.w10,

                    Text(
                      'Remember Me',
                      style: n16.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            AppSpace.h24,

            // Login Button
            Obx(
              () => LoginButton(
                onTap: controller.login,
                isLoading: controller.isLoading.value,
              ),
            ),

            AppSpace.h4,
          ],
        ),
      ),
    );
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    // if (!emailRegex.hasMatch(value.trim())) {
    //   return 'Please enter a valid email address';
    // }

    return null;
  }

  static String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
