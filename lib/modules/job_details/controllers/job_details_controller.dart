import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:ghire/core/helper/popup_helper.dart';
import 'package:ghire/data/repositories/job_details_repo.dart';
import 'package:ghire/data/services/auth_local_storage.dart';
import 'package:ghire/modules/dashboard/models/dashboard_model.dart';

class JobDetailsController extends GetxController {
  late final JobModel job;

  bool hasJobData = false;

  final JobDetailsRepo _repository = JobDetailsRepo();
  final AuthLocalStorage _localStorage = AuthLocalStorage.instance;

  final isSavingSelection = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadJobData();
  }

  void _loadJobData() {
    final arguments = Get.arguments;

    debugPrint('JOB DETAILS ARGUMENTS: $arguments');

    final dynamic data = arguments is Map ? arguments['jobData'] : arguments;

    if (data is JobModel) {
      job = data;
      hasJobData = true;

      debugPrint('JOB DETAILS LOADED: ${job.title}');
      debugPrint('CLIENT: ${job.clientName}');
      debugPrint('LOCATION: ${job.location}');
    } else {
      hasJobData = false;
      debugPrint('ERROR: JobModel not received');
    }
  }

  String get positionName => job.title.isNotEmpty ? job.title : 'Job Details';

  String get location =>
      job.location.isNotEmpty ? job.location : 'Not specified';

  String get clientName =>
      job.clientName.isNotEmpty ? job.clientName : 'Not specified';

  String get recruitmentType =>
      job.recruitmentType.isNotEmpty ? job.recruitmentType : 'Not specified';

  String get qualification =>
      job.qualification.isNotEmpty ? job.qualification : 'Not specified';

  String get description => job.positionDescription.isNotEmpty
      ? job.positionDescription
      : 'No description available';

  int get vacancies => job.vacancies;

  int get selected => job.selected;

  int get remaining => (vacancies - selected).clamp(0, vacancies);

  double get progress {
    if (vacancies <= 0) return 0;
    return (selected / vacancies).clamp(0.0, 1.0);
  }

  String get minimumCtc {
    final value = job.minCTC?.toString() ?? '';

    return value.isEmpty ? 'Not specified' : '₹ $value LPA';
  }

  String get experience {
    final min = job.minExperience?.toString() ?? '0';
    final max = job.maxExperience?.toString() ?? '0';

    return '$min - $max Years';
  }

  String get ageRange {
    final min = job.minAge?.toString() ?? 'Not specified';
    final max = job.maxAge?.toString() ?? 'Not specified';

    return '$min - $max Years';
  }

  String get recruiterName =>
      job.recruiterName.isNotEmpty ? job.recruiterName : 'Not specified';

  String get branchName =>
      job.branchName.isNotEmpty ? job.branchName : 'Not specified';

  String get department =>
      job.department.isNotEmpty ? job.department : 'Not specified';

  String get mandateSkill =>
      job.mandateSkill.isNotEmpty ? job.mandateSkill : 'Not specified';

  String get mandateId => job.mandateId.toString();

  //-----------------------------------------------------------------------

  Future<bool> saveSelection({
    required int mandateId,
    required int recruiterId,
    required String candidateName,
    required String mobile,
    required String email,
    required String experience,
    required String aadhaarNo,
    required String ssoId,
    String? resumeName,
    Uint8List? resumeBytes,
    PlatformFile? resume,
  }) async {
    if (isSavingSelection.value) return false;

    // Basic validation
    if (mandateId <= 0 || recruiterId <= 0) {
      PopupHelper.error('Invalid mandate or recruiter ID.');
      return false;
    }

    if (candidateName.trim().isEmpty) {
      PopupHelper.error('Please enter candidate name.');
      return false;
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile.trim())) {
      PopupHelper.error('Please enter a valid 10-digit mobile number.');
      return false;
    }

    if (email.trim().isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      PopupHelper.error('Please enter a valid email address.');
      return false;
    }

    if (!RegExp(r'^\d{12}$').hasMatch(aadhaarNo.trim())) {
      PopupHelper.error('Please enter a valid 12-digit Aadhaar number.');
      return false;
    }

    if (experience.trim().isNotEmpty) {
      final value = double.tryParse(experience.trim());

      if (value == null || !value.isFinite || value < 0) {
        PopupHelper.error('Please enter valid experience.');
        return false;
      }
    }

    // Validate resume if provided.
    const maxResumeBytes = 5 * 1024 * 1024;
    String fileBase64 = '';

    if (resumeBytes != null) {
      final extension = (resumeName ?? '').split('.').last.toLowerCase();

      if (!['pdf', 'doc', 'docx'].contains(extension)) {
        PopupHelper.error('Only PDF, DOC and DOCX files are allowed.');
        return false;
      }

      if (resumeBytes.isEmpty) {
        PopupHelper.error('The selected resume is empty.');
        return false;
      }

      if (resumeBytes.length > maxResumeBytes) {
        PopupHelper.error('Resume must be 5 MB or smaller.');
        return false;
      }

      fileBase64 = base64Encode(resumeBytes);
    }

    // Read authentication data saved during login.
    final token = _localStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      PopupHelper.error('Your session has expired. Please log in again.');
      return false;
    }

    final userData = _localStorage.getUserData();

    if (userData == null) {
      PopupHelper.error('Logged-in user details were not found.');
      return false;
    }

    // Adjust these keys to match the actual login API response.
    final normalizedUserData = <String, dynamic>{
      for (final entry in userData.entries)
        entry.key.toLowerCase(): entry.value,
    };

    String userId = '';

    for (final key in ['username', 'loginname', 'loginid', 'userid']) {
      final value = normalizedUserData[key]?.toString().trim() ?? '';

      if (value.isNotEmpty) {
        userId = value;
        break;
      }
    }

    if (userId.isEmpty) {
      PopupHelper.error(
        'Could not find the logged-in username. '
        'Please check the login API response.',
      );
      return false;
    }

    isSavingSelection.value = true;

    try {
      final body = <String, dynamic>{
        'Operation': 3,
        'MandateID': mandateId,
        'RequiterId': recruiterId,
        'CandidateName': candidateName.trim(),
        'Mobile': mobile.trim(),
        'Email': email.trim(),
        'Experience': experience.trim(),
        'AadhaarNo': aadhaarNo.trim(),
        'SSOID': ssoId.trim(),
        'UserID': userId,
        'FilePath': fileBase64,
      };

      // Do not print the complete body because it contains sensitive data.
      debugPrint(
        'SELECTION ADD REQUEST: '
        'MandateID=$mandateId, '
        'RequiterId=$recruiterId, '
        'ResumeAttached=${resume != null}',
      );

      final response = await _repository.saveSelection(
        token: token,
        body: body,
      );

      final status = response['Status'] == true;

      if (!status) {
        PopupHelper.error(
          response['Message']?.toString() ??
              'Failed to add candidate selection.',
        );
        return false;
      }

      PopupHelper.success(
        response['Message']?.toString() ??
            'Candidate selection added successfully.',
      );

      return true;
    } catch (error, stackTrace) {
      debugPrint('SAVE SELECTION ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      // DashboardRepository / ApiHandler may already display the API error.
      return false;
    } finally {
      isSavingSelection.value = false;
    }
  }
}
