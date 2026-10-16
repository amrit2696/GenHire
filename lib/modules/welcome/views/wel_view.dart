import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/modules/welcome/controllers/wel_controller.dart';
import 'package:ghire/modules/welcome/widgets/wel_button.dart';
import 'package:ghire/modules/welcome/widgets/wel_catchy_card.dart';
import 'package:ghire/modules/welcome/widgets/wel_hero.dart';
import '../../../core/widgets/app_button.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            // Hero
            const WelcomeHero(),

            // Catchy Card
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 30.h,
                bottom: 20.h,
              ),
              child: const WelcomeCatchyCard(),
            ),

            // Get Started
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10, 20.w, 30.h),
              child: WelcomeGetStartedButton(onTap: controller.getStarted),
            ),

            AppSpace.h10,
          ],
        ),
      ),
    );
  }
}
