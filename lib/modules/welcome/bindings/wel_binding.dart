import 'package:get/get.dart';
import 'package:ghire/modules/welcome/controllers/wel_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}