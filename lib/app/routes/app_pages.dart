import 'package:get/get.dart';
import 'package:ghire/modules/auth/bindings/login_binding.dart';
import 'package:ghire/modules/auth/views/login_view.dart';
import 'package:ghire/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:ghire/modules/dashboard/views/dashboard_view.dart';
import 'package:ghire/modules/job_details/bindings/job_details_binding.dart';
import 'package:ghire/modules/job_details/views/job_details_view.dart';
import 'package:ghire/modules/splash/bindings/splash_binding.dart';
import 'package:ghire/modules/welcome/bindings/wel_binding.dart';
import 'package:ghire/modules/welcome/views/wel_view.dart';
import '../../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.jobDetails,
      page: () => const JobDetailsView(),
      binding: JobDetailsBinding(),
    ),
  ];
}
