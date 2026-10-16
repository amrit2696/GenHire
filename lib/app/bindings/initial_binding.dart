import 'package:get/get.dart';
import '../../core/storage/local_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage
    Get.put<LocalStorage>(
      LocalStorage(),
      permanent: true,
    );

    // // API Client
    // Get.put<ApiClient>(
    //   ApiClient(),
    //   permanent: true,
    // );
  }
}