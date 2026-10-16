import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/helper/popup_helper.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import 'package:ghire/modules/dashboard/models/client_option_model.dart';
import 'package:ghire/modules/dashboard/widgets/app_select_field.dart';
import 'package:ghire/modules/dashboard/widgets/selection_card.dart';
import 'package:ghire/modules/dashboard/widgets/sreachable_selected_field.dart';
import '../controllers/add_job_controller.dart';
import 'form_field.dart';

/// Full-screen "Post a New Job" form.
///
/// Open it with a binding so GetX deletes the controller only after the
/// page has fully closed (see DashboardController.openAddJob).
class AddJobPage extends StatelessWidget {
  final String controllerTag;

  const AddJobPage({super.key, required this.controllerTag});

  AddJobController get controller =>
      Get.find<AddJobController>(tag: controllerTag);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildScaffold(context),

        // Blocks the back button while saving (draws nothing).
        Obx(
          () => PopScope(
            canPop: !controller.isSaving.value,
            child: const SizedBox.shrink(),
          ),
        ),

        // Full-page loading overlay while saving.
        Obx(
          () => controller.isSaving.value
              ? _buildSavingOverlay()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: Obx(() => _buildForm(context))),
          ],
        ),
      ),
      // Scaffold keeps this at the screen bottom, so the keyboard
      // covers it instead of pushing it up.
      bottomNavigationBar: _buildFooter(),
    );
  }

  // ───────────────────────── Header ─────────────────────────

  Widget _buildHeader(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, topInset + 14.h, 12.w, 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primaryDark, AppColor.primary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.work_outline_rounded,
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
                  'Post a New Job',
                  style: b20.copyWith(color: AppColor.white),
                ),
                AppSpace.h2,
                Text(
                  'Fill in the details below',
                  style: n12.copyWith(
                    color: AppColor.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: Get.back,
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

  // ───────────────────────── Saving overlay ─────────────────────────

  Widget _buildSavingOverlay() {
    return Positioned.fill(
      child: AbsorbPointer(
        child: Material(
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 26.h),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 34.w,
                    height: 34.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColor.primary,
                    ),
                  ),
                  AppSpace.h12,
                  Text(
                    'Saving job…',
                    style: sb14.copyWith(color: AppColor.textPrimary),
                  ),
                  AppSpace.h2,
                  Text(
                    'Please wait a moment',
                    style: n12.copyWith(color: AppColor.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Form ─────────────────────────

  Widget _buildForm(BuildContext context) {
    final errorCount = controller.errors.length;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
      child: Column(
        children: [
          if (errorCount > 0) _buildErrorBanner(errorCount),
          _buildRecruiterSection(),
          _buildPositionSection(),
          _buildPayrollSection(),
          _buildExperienceSection(context),
          AppSpace.h12,
        ],
      ),
    );
  }

  Widget _buildErrorBanner(int count) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.error.withValues(alpha: 0.08),
        border: Border.all(color: AppColor.error.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColor.error, size: 18.sp),
          AppSpace.w8,
          Expanded(
            child: Text(
              '$count ${count == 1 ? 'field needs' : 'fields need'} your attention',
              style: sb12.copyWith(color: AppColor.error),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Section 1 ─────────────────────────

  Widget _buildRecruiterSection() {
    return DashboardSectionCard(
      step: 1,
      total: 4,
      icon: Icons.people_outline,
      title: 'Recruiter & Client Details',
      subtitle: 'Who is hiring and for whom',
      child: Column(
        children: [
          // Domain: first option is pre-selected by the controller
          _select(
            field: 'domain',
            label: 'Domain',
            options: controller.domainOptions,
            value: controller.domain.value,
          ),

          // Branch: from the logged-in user
          DashboardFormField(
            label: 'Branch',
            required: true,
            enabled: false,
            icon: Icons.apartment_outlined,
            value: controller.branch.value,
            error: controller.errors['branch'],
          ),

          // Recruiter: logged-in user's name
          DashboardFormField(
            label: 'Recruiter',
            required: true,
            enabled: false,
            icon: Icons.person_outline,
            value: controller.recruiter.value,
            error: controller.errors['recruiter'],
          ),

          _selectModels(
            field: 'kycDomain',
            label: 'Onboarding / KYC Domain',
            options: controller.kycDomainOptions,
            value: controller.kycDomain.value,
          ),

          // Client: searchable
          AppSearchableSelectField(
            label: 'Client',
            value: controller.client.value,
            placeholder: controller.clients.isEmpty
                ? 'Loading clients…'
                : 'Search & select client',
            searchHint: 'Search client by name…',
            options: controller.clients
                .map(
                  (client) => AppSelectOption(
                    id: client.id.toString(),
                    label: client.label,
                  ),
                )
                .toList(),
            onChanged: (option) {
              controller.setDropdownValue(
                field: 'client',
                value: option.label,
                id: option.id,
              );
            },
            error: controller.errors['client'],
          ),

          // Client office: locked until a client is selected
          _selectModels(
            field: 'clientOffice',
            label: 'Client Office',
            options: controller.clientOfficeOptions,
            value: controller.clientOffice.value,
            placeholder: controller.clientId.value.isEmpty
                ? 'Select client first'
                : controller.isLoadingOffices.value
                ? 'Loading offices…'
                : 'Select',
            onLockedTap: controller.clientId.value.isEmpty
                ? () => PopupHelper.error('Please select a client first.')
                : null,
          ),

          DashboardFormField(
            label: "Recruiter's Position No.",
            required: true,
            icon: Icons.tag,
            controller: controller.recruiterPositionNoController,
            keyboardType: TextInputType.number,
            error: controller.errors['recruiterPositionNo'],
            onChanged: (value) {
              controller.updateTextField('recruiterPositionNo', value);
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Section 2 ─────────────────────────

  Widget _buildPositionSection() {
    return DashboardSectionCard(
      step: 2,
      total: 4,
      icon: Icons.description_outlined,
      title: 'Position Details',
      subtitle: 'Role, openings and location',
      child: Column(
        children: [
          DashboardFormField(
            label: 'Position Name',
            required: true,
            icon: Icons.work_outline,
            controller: controller.positionNameController,
            error: controller.errors['positionName'],
            onChanged: (value) {
              controller.updateTextField('positionName', value);
            },
          ),

          // Mirrors Recruiter's Position No.
          DashboardFormField(
            label: 'Position No./Vacancy',
            required: true,
            enabled: false,
            icon: Icons.tag,
            controller: controller.positionVacancyController,
            hint: "Copied from Recruiter's Position No.",
          ),

          DashboardFormField(
            label: 'Position Location',
            required: true,
            icon: Icons.location_on_outlined,
            controller: controller.positionLocationController,
            error: controller.errors['positionLocation'],
            onChanged: (value) {
              controller.updateTextField('positionLocation', value);
            },
          ),

          DashboardFormField(
            label: 'Position Description',
            multiline: true,
            controller: controller.positionDescriptionController,
            hint: 'Responsibilities, requirements, perks…',
            onChanged: (value) {
              controller.updateTextField('positionDescription', value);
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Section 3 ─────────────────────────

  Widget _buildPayrollSection() {
    return DashboardSectionCard(
      step: 3,
      total: 4,
      icon: Icons.account_balance_wallet_outlined,
      title: 'Payroll Details',
      subtitle: 'How the candidate will be paid',
      child: Column(
        children: [
          _select(
            field: 'payrollType',
            label: 'Payroll Type',
            options: const ['Genius Payroll'],
            value: controller.payrollType.value,
          ),

          _select(
            field: 'recruitmentType',
            label: 'Recruitment Type',
            options: controller.recruitmentTypeOptions,
            value: controller.recruitmentType.value,
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Section 4 ─────────────────────────

  Widget _buildExperienceSection(BuildContext context) {
    return DashboardSectionCard(
      step: 4,
      total: 4,
      icon: Icons.trending_up,
      title: 'CTC & Experiences Details',
      subtitle: 'Salary band, experience and eligibility',
      child: Column(
        children: [
          DashboardFormField(
            label: 'Skills (Use ,)',
            required: true,
            icon: Icons.lightbulb_outline,
            controller: controller.skillsController,
            hint: 'e.g. React Native, Node.js, SQL',
            error: controller.errors['skills'],
            onChanged: (value) {
              controller.updateTextField('skills', value);
            },
          ),

          _selectModels(
            field: 'categoryName',
            label: 'Category Name',
            options: controller.categoryOptions,
            value: controller.categoryName.value,
          ),

          _twoColumnFields(
            _numberField(
              label: 'Min CTC (Lakh INR)',
              hint: 'Eg. 1.5',
              field: 'minCTC',
              textController: controller.minCtcController,
              decimal: true,
            ),
            _numberField(
              label: 'Max CTC (Lakh INR)',
              hint: 'Eg. 7.0',
              field: 'maxCTC',
              textController: controller.maxCtcController,
              decimal: true,
            ),
          ),

          _twoColumnFields(
            _numberField(
              label: 'Min Exp. (Yrs)',
              hint: 'Eg. 0.6',
              field: 'minExp',
              textController: controller.minExpController,
              decimal: true,
            ),
            _numberField(
              label: 'Max Exp. (Yrs)',
              hint: 'Eg. 10',
              field: 'maxExp',
              textController: controller.maxExpController,
              decimal: true,
            ),
          ),

          _twoColumnFields(
            _numberField(
              label: 'Min. Age (Yrs)',
              hint: 'Eg. 18',
              field: 'minAge',
              textController: controller.minAgeController,
            ),
            _numberField(
              label: 'Max. Age (Yrs)',
              hint: 'Eg. 40',
              field: 'maxAge',
              textController: controller.maxAgeController,
            ),
          ),

          _selectModels(
            field: 'qualification',
            label: 'Qualification',
            options: controller.qualificationOptions,
            value: controller.qualification.value,
          ),

          // Calendar: today to +3 months
          DashboardFormField(
            label: 'Mandate Received Date',
            required: true,
            readOnly: true,
            icon: Icons.calendar_today_outlined,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
            hint: 'Select date',
            controller: controller.mandateDateController,
            error: controller.errors['mandateDate'],
            onTap: () => controller.pickMandateDate(context),
          ),

          DashboardFormField(
            label: 'Remarks',
            multiline: true,
            controller: controller.remarksController,
            hint: 'Anything else the team should know…',
            onChanged: (value) {
              controller.updateTextField('remarks', value);
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Widget _numberField({
    required String label,
    required String hint,
    required String field,
    required TextEditingController textController,
    bool decimal = false,
  }) {
    return DashboardFormField(
      label: label,
      required: true,
      controller: textController,
      hint: hint,
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      error: controller.errors[field],
      onChanged: (value) => controller.updateTextField(field, value),
    );
  }

  Widget _twoColumnFields(Widget first, Widget second) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        AppSpace.w12,
        Expanded(child: second),
      ],
    );
  }

  /// For fixed string lists.
  Widget _select({
    required String field,
    required String label,
    required List<String> options,
    required String value,
    String placeholder = 'Select',
  }) {
    return AppSelectField(
      label: label,
      value: value,
      placeholder: placeholder,
      options: options
          .map((item) => AppSelectOption(id: item, label: item))
          .toList(),
      onChanged: (option) {
        controller.setDropdownValue(field: field, value: option.label);
      },
      error: controller.errors[field],
    );
  }

  /// For lists that come from the API (passes the selected id back).
  Widget _selectModels({
    required String field,
    required String label,
    required List<ClientOptionModel> options,
    required String value,
    String placeholder = 'Select',
    VoidCallback? onLockedTap,
  }) {
    return AppSelectField(
      label: label,
      value: value,
      placeholder: placeholder,
      onLockedTap: onLockedTap,
      options: options
          .map((e) => AppSelectOption(id: e.id.toString(), label: e.label))
          .toList(),
      onChanged: (option) => controller.setDropdownValue(
        field: field,
        value: option.label,
        id: option.id,
      ),
      error: controller.errors[field],
    );
  }

  // ───────────────────────── Footer ─────────────────────────

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryDark.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Row(
            children: [
              // Cancel
              Expanded(
                flex: 2,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.06),
                    border: Border.all(
                      color: AppColor.primary.withValues(alpha: 0.25),
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: Get.back,
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: sb14.copyWith(color: AppColor.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              AppSpace.w12,

              // Save
              Expanded(
                flex: 3,
                child: Container(
                  height: 50.h,
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: controller.saveJob,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColor.white,
                            size: 20.sp,
                          ),
                          AppSpace.w8,
                          Text(
                            'Save Job',
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
        ),
      ),
    );
  }
}
