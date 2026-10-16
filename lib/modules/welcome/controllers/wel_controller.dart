import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class WelcomeController extends GetxController {
  void getStarted() {
    Get.offNamed(AppRoutes.login);
  }
}
