import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ghire/app/routes/app_routes.dart';
import 'package:ghire/core/helper/popup_helper.dart';
import 'package:ghire/data/repositories/dashboard_repository.dart';
import 'package:ghire/data/services/auth_local_storage.dart';
import 'package:ghire/modules/dashboard/controllers/add_job_controller.dart';
import 'package:ghire/modules/dashboard/widgets/add_job_page.dart';
import '../models/client_option_model.dart';
import '../models/dashboard_model.dart';

class DashboardController extends GetxController {
  final DashboardRepository repository;

  DashboardController({required this.repository});

  final isLoading = false.obs;
  final showAllJobs = false.obs;

  final userName = ''.obs;
  final userId = 0.obs;

  final dashboard = Rxn<DashboardModel>();

  final clients = <ClientOptionModel>[].obs;

  // Master lists for the Add Job form (loaded with the dashboard)
  final kycDomainOptions = <ClientOptionModel>[];
  final qualificationOptions = <ClientOptionModel>[];
  final categoryOptions = <ClientOptionModel>[];

  final AuthLocalStorage _localStorage = AuthLocalStorage.instance;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;

    debugPrint('1️⃣ loadDashboard START');

    try {
      final token = _localStorage.getAccessToken();
      final userData = _localStorage.getUserData();

      if (token == null || token.isEmpty) {
        debugPrint('❌ Access token is missing');
        return;
      }

      if (userData == null) {
        debugPrint('❌ User data is missing');
        return;
      }

      userName.value = userData['UserFullName']?.toString() ?? '';
      userId.value = _parseInt(userData['UserId']);

      final dashboardResult = await repository.getDashboard(
        token: token,
        recruiterId: userId.value,
      );

      dashboard.value = dashboardResult;

      final clientResult = await repository.getClientList(
        token: token,
        recruiterId: userId.value,
      );
      clients.assignAll(clientResult);

      final results = await Future.wait([
        _safeDropdown(6, token), // Onboarding / KYC Domain
        _safeDropdown(3, token), // Qualification
        _safeDropdown(4, token), // Category
      ]);

      kycDomainOptions.assignAll(results[0]);
      qualificationOptions.assignAll(results[1]);
      categoryOptions.assignAll(results[2]);
    } catch (error, stackTrace) {
      debugPrint('❌ DASHBOARD ERROR: $error');
      debugPrint('$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  void toggleShowAllJobs() {
    showAllJobs.toggle();
  }

  Future<List<ClientOptionModel>> _safeDropdown(int op, String token) async {
    try {
      return await repository.getDropdownList(
        token: token,
        recruiterId: userId.value,
        op: op,
      );
    } catch (error) {
      debugPrint('DROPDOWN OP $op ERROR: $error');
      return [];
    }
  }

  Future<void> openAddJob() async {
    if (isLoading.value) {
      PopupHelper.error('Data is still loading. Please try again in a moment.');
      return;
    }

    final user = _localStorage.getUserData();

    if (user == null) {
      PopupHelper.error('User session not found. Please log in again.');
      return;
    }

    // Case-insensitive lookup so "BranchName" / "branch_name" both match.
    String read(List<String> keys) {
      final lower = {
        for (final e in user.entries) e.key.toString().toLowerCase(): e.value,
      };
      for (final key in keys) {
        final v = lower[key.toLowerCase()];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return '';
    }

    final uid = read(['UserId', 'Id', 'user_id']);
    final uname = read(['UserFullName', 'EmployeeName']);
    final branchName = read(['BranchName', 'Branch_Name', 'Branch']);

    final tag = 'add-job-${DateTime.now().millisecondsSinceEpoch}';

    // The controller is created in a binding, so GetX deletes it only after
    // the page has fully closed (no "controller not found" / "disposed
    // TextEditingController" errors during the exit animation).
    final saved = await Get.to<bool>(
      () => AddJobPage(controllerTag: tag),
      binding: BindingsBuilder(() {
        Get.put(
          AddJobController(
            clients: clients.toList(),
            kycDomainOptions: kycDomainOptions.toList(),
            qualificationOptions: qualificationOptions.toList(),
            categoryOptions: categoryOptions.toList(),
            userId: uid,
            userName: uname,
            userBranch: branchName,
            repository: repository,
          ),
          tag: tag,
        );
      }),
    );

    // Job was saved: reload the dashboard.
    if (saved == true) {
      await refreshDashboard();
    }
  }

  Future<void> logout() async {
    // Session lives in GetStorage (AuthLocalStorage), not SharedPreferences.
    await _localStorage.logout();

    Get.offAllNamed('/login');
  }

  void openJobDetails(dynamic job) {
    Get.toNamed(AppRoutes.jobDetails, arguments: {'jobData': job});
  }

  int _parseInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
