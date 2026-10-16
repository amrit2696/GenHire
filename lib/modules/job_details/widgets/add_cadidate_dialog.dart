import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/helper/popup_helper.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import 'package:ghire/data/repositories/dashboard_repository.dart';
import 'package:ghire/modules/dashboard/widgets/form_field.dart';
import 'package:ghire/modules/job_details/controllers/job_details_controller.dart';

class AddCandidateDialog extends StatefulWidget {
  final DashboardRepository repository;
  final int mandateId;
  final int recruiterId;
  final String recruiterName;
  final String clientName;
  final String positionName;
  final String positionNo;
  final String mandateDate;
  final String selectedCandidate;

  const AddCandidateDialog({
    super.key,
    required this.repository,
    required this.mandateId,
    required this.recruiterId,
    this.recruiterName = 'Recruiter Name',
    this.clientName = 'Client Name',
    this.positionName = 'Software Developer',
    this.positionNo = '10',
    this.mandateDate = '',
    this.selectedCandidate = '0',
  });

  @override
  State<AddCandidateDialog> createState() => _AddCandidateDialogState();
}

class _AddCandidateDialogState extends State<AddCandidateDialog> {
  static const int _maxResumeBytes = 5 * 1024 * 1024;

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _experienceController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _ssoController = TextEditingController();

  final Map<String, String> _errors = {};

  PlatformFile? _resume;
  String? _resumeError;
  Uint8List? _resumeBytes;
  bool get _saving => controller.isSavingSelection.value;

  final JobDetailsController controller = Get.find<JobDetailsController>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _experienceController.dispose();
    _aadhaarController.dispose();
    _ssoController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final errors = <String, String>{};

    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final experience = _experienceController.text.trim();
    final aadhaar = _aadhaarController.text.trim();

    if (name.isEmpty) {
      errors['name'] = 'Candidate name is required';
    }

    if (mobile.isEmpty) {
      errors['mobile'] = 'Mobile number is required';
    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      errors['mobile'] = 'Enter a valid 10-digit mobile number';
    }

    if (email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email address';
    }

    if (experience.isNotEmpty) {
      final value = double.tryParse(experience);

      if (value == null || !value.isFinite || value < 0) {
        errors['experience'] = 'Enter valid experience in years';
      }
    }

    if (aadhaar.isEmpty) {
      errors['aadhaar'] = 'Aadhaar number is required';
    } else if (!RegExp(r'^\d{12}$').hasMatch(aadhaar)) {
      errors['aadhaar'] = 'Aadhaar number must contain 12 digits';
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });

    return errors.isEmpty;
  }

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  Future<void> _pickResume() async {
    FocusScope.of(context).unfocus();
    setState(() => _resumeError = null);

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'doc', 'docx'],
      );

      if (file == null) return; // user cancelled

      final ext = file.name.split('.').last.toLowerCase();
      final length = await file.length();

      String? error;
      if (!['pdf', 'doc', 'docx'].contains(ext)) {
        error = 'Only PDF, DOC and DOCX files are allowed.';
      } else if (length == 0) {
        error = 'The selected file is empty.';
      } else if (length! > _maxResumeBytes) {
        error = 'Resume must be 5 MB or smaller.';
      }

      if (!mounted) return;

      if (error != null) {
        setState(() => _resumeError = error);
        return;
      }

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        _resume = file;
        _resumeBytes = bytes;
      });
    } catch (e, st) {
      debugPrint('RESUME PICKER ERROR: $e');
      debugPrintStack(stackTrace: st);
      if (mounted) {
        setState(() => _resumeError = 'Could not open file picker: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !_saving,
        child: Dialog(
          backgroundColor: AppColor.scaffold,
          clipBehavior: Clip.antiAlias,
          insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  Flexible(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                      child: Column(
                        children: [_buildMandateCard(), _buildForm()],
                      ),
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 10.w, 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primaryDark, AppColor.primary],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              color: AppColor.primary,
              size: 22.sp,
            ),
          ),
          AppSpace.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Selection',
                  style: b20.copyWith(color: AppColor.white),
                ),
                AppSpace.h2,
                Text(
                  'Add a candidate to this mandate',
                  style: n12.copyWith(
                    color: AppColor.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: AppColor.white, size: 22.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMandateCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 18.sp,
                color: AppColor.primary,
              ),
              AppSpace.w8,
              Text(
                'Mandate Details',
                style: sb12.copyWith(color: AppColor.primary),
              ),
            ],
          ),
          AppSpace.h12,
          _infoRow(
            _infoCell('Recruiter', widget.recruiterName),
            _infoCell('Client', widget.clientName),
          ),
          _infoRow(
            _infoCell('Position', widget.positionName),
            _infoCell('Position No.', widget.positionNo),
          ),
          _infoRow(
            _infoCell('Mandate Add Date', widget.mandateDate),
            _infoCell('Selected Candidate', widget.selectedCandidate),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(Widget first, Widget second, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          AppSpace.w12,
          Expanded(child: second),
        ],
      ),
    );
  }

  Widget _infoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: n12.copyWith(color: AppColor.textSecondary)),
        AppSpace.h2,
        Text(
          value.trim().isEmpty ? '—' : value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: sb12.copyWith(color: AppColor.textPrimary),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        DashboardFormField(
          label: 'Candidate Name',
          required: true,
          icon: Icons.person_outline,
          controller: _nameController,
          hint: 'Enter full name',
          error: _errors['name'],
          onChanged: (_) => _clearError('name'),
        ),

        DashboardFormField(
          label: 'Mobile No.',
          required: true,
          icon: Icons.phone_outlined,
          controller: _mobileController,
          hint: '10-digit mobile number',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          error: _errors['mobile'],
          onChanged: (_) => _clearError('mobile'),
        ),

        DashboardFormField(
          label: 'Email',
          icon: Icons.mail_outline,
          controller: _emailController,
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          error: _errors['email'],
          onChanged: (_) => _clearError('email'),
        ),

        DashboardFormField(
          label: 'Experience (Year)',
          icon: Icons.workspace_premium_outlined,
          controller: _experienceController,
          hint: 'Eg. 3.7',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}\.?\d{0,2}$')),
          ],
          error: _errors['experience'],
          onChanged: (_) => _clearError('experience'),
        ),

        DashboardFormField(
          label: 'Aadhaar No.',
          required: true,
          icon: Icons.badge_outlined,
          controller: _aadhaarController,
          hint: '12-digit Aadhaar number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          error: _errors['aadhaar'],
          onChanged: (_) => _clearError('aadhaar'),
        ),

        DashboardFormField(
          label: 'SSO ID/GC ID',
          icon: Icons.vpn_key_outlined,
          controller: _ssoController,
          hint: 'Optional',
        ),
        _buildResumePicker(),
      ],
    );
  }

  Widget _buildResumePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Resume', style: sb12.copyWith(color: AppColor.primary)),
          AppSpace.h5,
          InkWell(
            onTap: _saving ? null : _pickResume, // opens the picker
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _resumeError != null
                      ? Colors.red
                      : AppColor.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _resume == null
                        ? Icons.upload_file_outlined
                        : Icons.description_outlined,
                    color: AppColor.primary,
                  ),
                  AppSpace.w12,
                  Expanded(
                    child: Text(
                      _resume?.name ?? 'Choose file',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sb14.copyWith(color: AppColor.textPrimary),
                    ),
                  ),
                  if (_resume != null)
                    IconButton(
                      onPressed: _saving
                          ? null
                          : () => setState(() {
                              _resume = null;
                              _resumeBytes = null;
                            }),
                      icon: const Icon(Icons.close),
                    )
                  else
                    Icon(Icons.chevron_right_rounded, color: AppColor.primary),
                ],
              ),
            ),
          ),
          // The error goes below the box, not inside the Row.
          if (_resumeError != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text(
                _resumeError!,
                style: n12.copyWith(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submitSelection() async {
    FocusScope.of(context).unfocus();
    if (!_validateForm()) return;

    final success = await controller.saveSelection(
      mandateId: widget.mandateId,
      recruiterId: widget.recruiterId,
      candidateName: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      experience: _experienceController.text,
      aadhaarNo: _aadhaarController.text,
      ssoId: _ssoController.text,
      resumeName: _resume?.name,
      resumeBytes: _resumeBytes,
    );

    if (success && mounted) {
      Get.back(result: true);
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(top: BorderSide(color: AppColor.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: _saving ? null : () => Get.back(),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.06),
                  border: Border.all(
                    color: AppColor.primary.withValues(alpha: 0.25),
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Cancel',
                  style: sb14.copyWith(color: AppColor.textSecondary),
                ),
              ),
            ),
          ),
          AppSpace.w12,
          Expanded(
            flex: 3,
            child: Obx(
              () => InkWell(
                onTap: controller.isSavingSelection.value
                    ? null
                    : _submitSelection,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.primary, AppColor.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: controller.isSavingSelection.value
                      ? SizedBox(
                          height: 22.h,
                          width: 22.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add_alt_1_rounded,
                              color: AppColor.white,
                              size: 20.sp,
                            ),
                            AppSpace.w8,
                            Text(
                              'Add Selection',
                              style: b14.copyWith(color: AppColor.white),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
