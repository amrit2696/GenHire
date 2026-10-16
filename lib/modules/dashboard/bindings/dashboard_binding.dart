import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ghire/data/repositories/dashboard_repository.dart';
import 'package:ghire/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio());

    Get.lazyPut<DashboardRepository>(() => DashboardRepository());

    Get.lazyPut<DashboardController>(
      () => DashboardController(repository: Get.find<DashboardRepository>()),
    );
  }
}
