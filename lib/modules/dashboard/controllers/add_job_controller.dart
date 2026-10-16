import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ghire/core/helper/popup_helper.dart';
import 'package:ghire/data/repositories/dashboard_repository.dart';
import 'package:ghire/data/services/auth_local_storage.dart';
import '../models/client_option_model.dart';

class AddJobController extends GetxController {
  // Lists loaded once by DashboardController
  final List<ClientOptionModel> clients;
  final List<ClientOptionModel> kycDomainOptions;
  final List<ClientOptionModel> qualificationOptions;
  final List<ClientOptionModel> categoryOptions;

  // Logged-in user
  final String userId;
  final String userName;
  final String userBranch;

  final DashboardRepository repository;

  AddJobController({
    required this.clients,
    required this.kycDomainOptions,
    required this.qualificationOptions,
    required this.categoryOptions,
    required this.repository,
    required this.userId,
    required this.userName,
    required this.userBranch,
  });

  int get _recruiterId => int.tryParse(userId) ?? 0;
  String get _token => AuthLocalStorage.instance.getAccessToken() ?? '';

  // Client office list: loaded per selected client
  final clientOfficeOptions = <ClientOptionModel>[].obs;
  final isLoadingOffices = false.obs;

  final isSaving = false.obs;

  // Text fields
  final recruiterPositionNoController = TextEditingController();

  /// Mirrors [recruiterPositionNoController] (read-only in the UI).
  final positionVacancyController = TextEditingController();

  final positionNameController = TextEditingController();
  final positionLocationController = TextEditingController();
  final positionDescriptionController = TextEditingController();
  final skillsController = TextEditingController();
  final minCtcController = TextEditingController();
  final maxCtcController = TextEditingController();
  final minExpController = TextEditingController();
  final maxExpController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final remarksController = TextEditingController();

  /// Shown in the Mandate Received Date field.
  final mandateDateController = TextEditingController();

  // Dropdown values (labels)
  final domain = ''.obs;
  final branch = ''.obs;
  final recruiter = ''.obs;
  final kycDomain = ''.obs;
  final client = ''.obs;
  final clientOffice = ''.obs;
  final payrollType = 'Genius Payroll'.obs;
  final recruitmentType = ''.obs;
  final categoryName = ''.obs;
  final qualification = ''.obs;

  // Dropdown ids (sent to the save API)
  final clientId = ''.obs;
  final kycDomainId = ''.obs;
  final clientOfficeId = ''.obs;
  final categoryId = ''.obs;

  final mandateDate = Rxn<DateTime>();

  final errors = <String, String>{}.obs;

  final domainOptions = const ['FSSR-GENERAL'];
  final recruitmentTypeOptions = const ['White Collar', 'Blue Collar'];

  // ───────────────────────── Lifecycle ─────────────────────────

  @override
  void onInit() {
    super.onInit();

    // Domain: first available option
    if (domainOptions.isNotEmpty) domain.value = domainOptions.first;

    // Branch and recruiter from the logged-in user
    branch.value = userBranch;
    recruiter.value = userName;

    // Keep Position No./Vacancy in sync with Recruiter's Position No.
    recruiterPositionNoController.addListener(_syncPositionNo);

    // Default mandate date = today
    _setMandateDate(DateTime.now());
  }

  void _syncPositionNo() {
    if (positionVacancyController.text != recruiterPositionNoController.text) {
      positionVacancyController.text = recruiterPositionNoController.text;
    }
  }

  // ───────────────────────── Client offices ─────────────────────────

  Future<void> _loadClientOffices(String selectedClientId) async {
    clientOffice.value = '';
    clientOfficeId.value = '';
    clientOfficeOptions.clear();
    isLoadingOffices.value = false;

    if (selectedClientId.isEmpty) return;

    isLoadingOffices.value = true;

    try {
      final offices = await repository.getDropdownList(
        token: _token,
        recruiterId: _recruiterId,
        op: 2,
        clientId: selectedClientId,
      );

      // Ignore the response if the user picked a different client meanwhile.
      if (clientId.value == selectedClientId) {
        clientOfficeOptions.assignAll(offices);
      }
    } catch (error) {
      debugPrint('LOAD CLIENT OFFICES ERROR: $error');
    } finally {
      if (clientId.value == selectedClientId) {
        isLoadingOffices.value = false;
      }
    }
  }

  // ───────────────────────── Date picker ─────────────────────────

  DateTime get _firstDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _lastDate {
    final first = _firstDate;
    // DateTime normalises overflow (e.g. Nov 30 + 3 months), so clamp the day.
    final targetMonth = first.month + 3;
    final lastDayOfTargetMonth = DateTime(first.year, targetMonth + 1, 0).day;
    final day = first.day > lastDayOfTargetMonth
        ? lastDayOfTargetMonth
        : first.day;
    return DateTime(first.year, targetMonth, day);
  }

  Future<void> pickMandateDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: mandateDate.value ?? _firstDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      helpText: 'Mandate Received Date',
    );

    if (picked != null) {
      _setMandateDate(picked);
      _removeError('mandateDate');
    }
  }

  void _setMandateDate(DateTime date) {
    mandateDate.value = date;
    mandateDateController.text = _format(date);
  }

  String _format(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  String _apiDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  // ───────────────────────── Form logic ─────────────────────────

  void setDropdownValue({
    required String field,
    required String value,
    String? id,
  }) {
    switch (field) {
      case 'domain':
        domain.value = value;
        break;

      case 'branch':
        branch.value = value;
        break;

      case 'recruiter':
        recruiter.value = value;
        break;

      case 'kycDomain':
        kycDomain.value = value;
        kycDomainId.value = id ?? '';
        break;

      case 'client':
        client.value = value;
        clientId.value = id ?? '';
        _loadClientOffices(clientId.value);
        break;

      case 'clientOffice':
        clientOffice.value = value;
        clientOfficeId.value = id ?? '';
        break;

      case 'payrollType':
        payrollType.value = value;
        break;

      case 'recruitmentType':
        recruitmentType.value = value;
        break;

      case 'categoryName':
        categoryName.value = value;
        categoryId.value = id ?? '';
        break;

      case 'qualification':
        qualification.value = value;
        break;
    }

    _removeError(field);
  }

  void updateTextField(String field, String value) {
    _removeError(field);
  }

  void _removeError(String field) {
    if (errors.containsKey(field)) {
      errors.remove(field);
    }
  }

  Map<String, String> get formValues {
    return {
      'domain': domain.value,
      'branch': branch.value,
      'recruiter': recruiter.value,
      'kycDomain': kycDomain.value,
      'client': client.value,
      'clientOffice': clientOffice.value,
      'recruiterPositionNo': recruiterPositionNoController.text,
      'positionName': positionNameController.text,
      'positionLocation': positionLocationController.text,
      'positionDescription': positionDescriptionController.text,
      'payrollType': payrollType.value,
      'recruitmentType': recruitmentType.value,
      'skills': skillsController.text,
      'categoryName': categoryName.value,
      'minCTC': minCtcController.text,
      'maxCTC': maxCtcController.text,
      'minExp': minExpController.text,
      'maxExp': maxExpController.text,
      'minAge': minAgeController.text,
      'maxAge': maxAgeController.text,
      'qualification': qualification.value,
      'mandateDate': mandateDateController.text,
      'remarks': remarksController.text,
    };
  }

  bool validate() {
    final values = formValues;
    final newErrors = <String, String>{};

    const requiredFields = [
      'domain',
      'branch',
      'recruiter',
      'kycDomain',
      'client',
      'clientOffice',
      'recruiterPositionNo',
      'positionName',
      'positionLocation',
      'payrollType',
      'recruitmentType',
      'skills',
      'categoryName',
      'minCTC',
      'maxCTC',
      'minExp',
      'maxExp',
      'minAge',
      'maxAge',
      'qualification',
      'mandateDate',
    ];

    for (final key in requiredFields) {
      if ((values[key] ?? '').trim().isEmpty) {
        newErrors[key] = 'Required';
      }
    }

    _validateRange(newErrors, values, 'minCTC', 'maxCTC');
    _validateRange(newErrors, values, 'minExp', 'maxExp');
    _validateRange(newErrors, values, 'minAge', 'maxAge');

    errors.assignAll(newErrors);

    return newErrors.isEmpty;
  }

  void _validateRange(
    Map<String, String> errors,
    Map<String, String> values,
    String minKey,
    String maxKey,
  ) {
    if (errors.containsKey(minKey) || errors.containsKey(maxKey)) {
      return;
    }

    final min = double.tryParse(values[minKey] ?? '');
    final max = double.tryParse(values[maxKey] ?? '');

    if (min != null && max != null && min > max) {
      errors[maxKey] = 'Must be ≥ minimum';
    }
  }

  // ───────────────────────── Save ─────────────────────────

  /// The API's "UserID" is the login username (e.g. "rmstestuser").
  /// Key names are guesses: confirm against the stored user data.
  String get _loginUserName {
    final data = AuthLocalStorage.instance.getUserData() ?? {};
    final lower = {
      for (final e in data.entries) e.key.toString().toLowerCase(): e.value,
    };

    for (final key in ['username', 'loginname', 'loginid']) {
      final v = lower[key]?.toString().trim() ?? '';
      if (v.isNotEmpty) return v;
    }

    return userName;
  }

  Future<void> saveJob() async {
    if (isSaving.value) return;

    FocusManager.instance.primaryFocus?.unfocus();

    if (!validate()) {
      PopupHelper.error('Please complete the required fields.');
      return;
    }

    isSaving.value = true;

    try {
      final body = {
        'Operation': 1,
        'RecruiterId': _recruiterId,
        'ClientId': int.tryParse(clientId.value) ?? 0,
        'ClientOfficeID': int.tryParse(clientOfficeId.value) ?? 0,
        'GSPPIDomain': kycDomainId.value,
        'PositionName': positionNameController.text.trim(),
        'PositionNo':
            int.tryParse(recruiterPositionNoController.text.trim()) ?? 0,
        'PositionLocation': positionLocationController.text.trim(),
        'PositionDescription': positionDescriptionController.text.trim(),
        'RecruitmentType': recruitmentType.value,
        'PayrollType': payrollType.value,
        'MandateSkill': skillsController.text.trim(),
        'Category': categoryId.value,
        'MinCTC': double.tryParse(minCtcController.text.trim()) ?? 0,
        'MaxCTC': double.tryParse(maxCtcController.text.trim()) ?? 0,
        'Qualification': qualification.value,
        'MinExperience': double.tryParse(minExpController.text.trim()) ?? 0,
        'MaxExperience': double.tryParse(maxExpController.text.trim()) ?? 0,
        'MinAge': int.tryParse(minAgeController.text.trim()) ?? 0,
        'MaxAge': int.tryParse(maxAgeController.text.trim()) ?? 0,
        'RecivedDate': _apiDate(mandateDate.value ?? DateTime.now()),
        'Remarks': remarksController.text.trim(),
        'UserID': _loginUserName,
      };

      debugPrint('SAVE JOB BODY: $body');

      final response = await repository.saveMandate(token: _token, body: body);

      if (response['Status'] == false) {
        PopupHelper.error(
          response['Message']?.toString() ?? 'Could not save the job.',
        );
        return;
      }

      final savedName = positionNameController.text.trim();

      // Hide the loader first, then close the page and return `true`
      // so the dashboard knows to reload.
      isSaving.value = false;
      Get.back(result: true);

      PopupHelper.success(
        response['Message']?.toString() ??
            '"$savedName" has been saved successfully.',
      );
    } catch (error) {
      debugPrint('SAVE JOB ERROR: $error');
      // ApiHandler already shows the error popup.
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    recruiterPositionNoController.removeListener(_syncPositionNo);

    recruiterPositionNoController.dispose();
    positionVacancyController.dispose();
    positionNameController.dispose();
    positionLocationController.dispose();
    positionDescriptionController.dispose();
    skillsController.dispose();
    minCtcController.dispose();
    maxCtcController.dispose();
    minExpController.dispose();
    maxExpController.dispose();
    minAgeController.dispose();
    maxAgeController.dispose();
    remarksController.dispose();
    mandateDateController.dispose();

    super.onClose();
  }
}
