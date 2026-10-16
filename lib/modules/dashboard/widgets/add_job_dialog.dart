// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:ghire/core/space/space.dart';
// import 'package:ghire/core/theme/app_colors.dart';
// import 'package:ghire/core/utils/text_style.dart';
// import 'package:ghire/modules/dashboard/widgets/app_select_field.dart';
// import 'package:ghire/modules/dashboard/widgets/selection_card.dart';
// import '../controllers/add_job_controller.dart';
// import 'form_field.dart';

// class AddJobDialog extends StatelessWidget {
//   final String controllerTag;

//   const AddJobDialog({super.key, required this.controllerTag});

//   AddJobController get controller =>
//       Get.find<AddJobController>(tag: controllerTag);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.94,
//         height: MediaQuery.of(context).size.height * 0.92,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(22.r),
//           child: Column(
//             children: [
//               _buildHeader(),

//               Expanded(child: Obx(() => _buildForm())),

//               _buildFooter(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(20.w, 20.h, 12.w, 22.h),
//       decoration: BoxDecoration(color: AppColor.primaryDark),
//       child: Row(
//         children: [
//           Container(
//             width: 46.w,
//             height: 46.w,
//             decoration: BoxDecoration(
//               color: AppColor.white,
//               borderRadius: BorderRadius.circular(14.r),
//             ),
//             child: Icon(
//               Icons.work_outline_rounded,
//               color: AppColor.primary,
//               size: 22.sp,
//             ),
//           ),

//           AppSpace.w12,

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Post a New Job',
//                   style: b20.copyWith(color: AppColor.white),
//                 ),
//                 AppSpace.h2,
//                 Text(
//                   'Fill in the details below',
//                   style: n12.copyWith(
//                     color: AppColor.white.withValues(alpha: 0.8),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           InkWell(
//             onTap: Get.back,
//             borderRadius: BorderRadius.circular(18.r),
//             child: Container(
//               width: 36.w,
//               height: 36.w,
//               decoration: BoxDecoration(
//                 color: AppColor.white.withValues(alpha: 0.20),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.close, color: AppColor.white, size: 22.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForm() {
//     final errorCount = controller.errors.length;

//     return Container(
//       color: AppColor.scaffold,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
//         child: Column(
//           children: [
//             if (errorCount > 0) _buildErrorBanner(errorCount),

//             _buildRecruiterSection(),

//             _buildPositionSection(),

//             _buildPayrollSection(),

//             _buildExperienceSection(),

//             AppSpace.h12,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorBanner(int count) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(bottom: 14.h),
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: AppColor.error.withValues(alpha: 0.08),
//         border: Border.all(color: AppColor.error.withValues(alpha: 0.25)),
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline, color: AppColor.error, size: 18.sp),
//           AppSpace.w8,
//           Text(
//             '$count ${count == 1 ? 'field needs' : 'fields need'} your attention',
//             style: sb12.copyWith(color: AppColor.error),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecruiterSection() {
//     return DashboardSectionCard(
//       step: 1,
//       total: 4,
//       icon: Icons.people_outline,
//       title: 'Recruiter & Client Details',
//       subtitle: 'Who is hiring and for whom',
//       child: Column(
//         children: [
//           _select(
//             field: 'domain',
//             label: 'Domain',
//             options: controller.domainOptions,
//             value: controller.domain.value,
//           ),

//           _select(
//             field: 'branch',
//             label: 'Branch',
//             options: controller.branchOptions,
//             value: controller.branch.value,
//           ),

//           _select(
//             field: 'recruiter',
//             label: 'Recruiter',
//             options: [
//               if (controller.recruiter.value.isNotEmpty)
//                 controller.recruiter.value,
//             ],
//             value: controller.recruiter.value,
//             placeholder: 'Select Recruiter',
//           ),

//           _select(
//             field: 'kycDomain',
//             label: 'Onboarding / KYC Domain',
//             options: controller.kycDomainOptions,
//             value: controller.kycDomain.value,
//           ),

//           AppSelectField(
//             label: 'Client',
//             value: controller.client.value,
//             placeholder: controller.clients.isEmpty
//                 ? 'Loading clients…'
//                 : 'Select',
//             options: controller.clients
//                 .map(
//                   (client) => AppSelectOption(
//                     id: client.id.toString(),
//                     label: client.label,
//                   ),
//                 )
//                 .toList(),
//             onChanged: (option) {
//               controller.setDropdownValue(
//                 field: 'client',
//                 value: option.label,
//                 id: option.id,
//               );
//             },
//             error: controller.errors['client'],
//           ),

//           _select(
//             field: 'clientOffice',
//             label: 'Client Office',
//             options: controller.clientOfficeOptions,
//             value: controller.clientOffice.value,
//           ),

//           DashboardFormField(
//             label: "Recruiter's Position No.",
//             required: true,
//             controller: controller.recruiterPositionNoController,
//             keyboardType: TextInputType.number,
//             error: controller.errors['recruiterPositionNo'],
//             onChanged: (value) {
//               controller.updateTextField('recruiterPositionNo', value);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPositionSection() {
//     return DashboardSectionCard(
//       step: 2,
//       total: 4,
//       icon: Icons.description_outlined,
//       title: 'Position Details',
//       subtitle: 'Role, openings and location',
//       child: Column(
//         children: [
//           DashboardFormField(
//             label: 'Position Name',
//             required: true,
//             icon: Icons.work_outline,
//             controller: controller.positionNameController,
//             error: controller.errors['positionName'],
//             onChanged: (value) {
//               controller.updateTextField('positionName', value);
//             },
//           ),

//           DashboardFormField(
//             label: 'Position No./Vacancy',
//             required: true,
//             enabled: false,
//             value: controller.recruiterPositionNoController.text,
//           ),

//           DashboardFormField(
//             label: 'Position Location',
//             required: true,
//             icon: Icons.location_on_outlined,
//             controller: controller.positionLocationController,
//             error: controller.errors['positionLocation'],
//             onChanged: (value) {
//               controller.updateTextField('positionLocation', value);
//             },
//           ),

//           DashboardFormField(
//             label: 'Position Description',
//             multiline: true,
//             controller: controller.positionDescriptionController,
//             hint: 'Responsibilities, requirements, perks…',
//             onChanged: (value) {
//               controller.updateTextField('positionDescription', value);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPayrollSection() {
//     return DashboardSectionCard(
//       step: 3,
//       total: 4,
//       icon: Icons.account_balance_wallet_outlined,
//       title: 'Payroll Details',
//       subtitle: 'How the candidate will be paid',
//       child: Column(
//         children: [
//           _select(
//             field: 'payrollType',
//             label: 'Payroll Type',
//             options: const ['Genius Payroll'],
//             value: controller.payrollType.value,
//           ),

//           _select(
//             field: 'recruitmentType',
//             label: 'Recruitment Type',
//             options: controller.recruitmentTypeOptions,
//             value: controller.recruitmentType.value,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExperienceSection() {
//     return DashboardSectionCard(
//       step: 4,
//       total: 4,
//       icon: Icons.trending_up,
//       title: 'CTC & Experiences Details',
//       subtitle: 'Salary band, experience and eligibility',
//       child: Column(
//         children: [
//           DashboardFormField(
//             label: 'Skills (Use ,)',
//             required: true,
//             icon: Icons.lightbulb_outline,
//             controller: controller.skillsController,
//             hint: 'e.g. React Native, Node.js, SQL',
//             error: controller.errors['skills'],
//             onChanged: (value) {
//               controller.updateTextField('skills', value);
//             },
//           ),

//           _select(
//             field: 'categoryName',
//             label: 'Category Name',
//             options: controller.categoryOptions,
//             value: controller.categoryName.value,
//           ),

//           _twoColumnFields(
//             DashboardFormField(
//               label: 'Min CTC (Lakh INR)',
//               required: true,
//               controller: controller.minCtcController,
//               hint: 'Eg. 1.5',
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               error: controller.errors['minCTC'],
//               onChanged: (value) {
//                 controller.updateTextField('minCTC', value);
//               },
//             ),
//             DashboardFormField(
//               label: 'Max CTC (Lakh INR)',
//               required: true,
//               controller: controller.maxCtcController,
//               hint: 'Eg. 7.0',
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               error: controller.errors['maxCTC'],
//               onChanged: (value) {
//                 controller.updateTextField('maxCTC', value);
//               },
//             ),
//           ),

//           _twoColumnFields(
//             DashboardFormField(
//               label: 'Min Exp. (Yrs)',
//               required: true,
//               controller: controller.minExpController,
//               hint: 'Eg. 0.6',
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               error: controller.errors['minExp'],
//               onChanged: (value) {
//                 controller.updateTextField('minExp', value);
//               },
//             ),
//             DashboardFormField(
//               label: 'Max Exp. (Yrs)',
//               required: true,
//               controller: controller.maxExpController,
//               hint: 'Eg. 10',
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               error: controller.errors['maxExp'],
//               onChanged: (value) {
//                 controller.updateTextField('maxExp', value);
//               },
//             ),
//           ),

//           _twoColumnFields(
//             DashboardFormField(
//               label: 'Min. Age (Yrs)',
//               required: true,
//               controller: controller.minAgeController,
//               hint: 'Eg. 18',
//               keyboardType: TextInputType.number,
//               error: controller.errors['minAge'],
//               onChanged: (value) {
//                 controller.updateTextField('minAge', value);
//               },
//             ),
//             DashboardFormField(
//               label: 'Max. Age (Yrs)',
//               required: true,
//               controller: controller.maxAgeController,
//               hint: 'Eg. 40',
//               keyboardType: TextInputType.number,
//               error: controller.errors['maxAge'],
//               onChanged: (value) {
//                 controller.updateTextField('maxAge', value);
//               },
//             ),
//           ),

//           _select(
//             field: 'qualification',
//             label: 'Qualification',
//             options: controller.qualificationOptions,
//             value: controller.qualification.value,
//           ),

//           DashboardFormField(
//             label: 'Mandate Received Date',
//             required: true,
//             enabled: false,
//             icon: Icons.calendar_today_outlined,
//             value: controller.today,
//           ),

//           DashboardFormField(
//             label: 'Remarks',
//             multiline: true,
//             controller: controller.remarksController,
//             hint: 'Anything else the team should know…',
//             onChanged: (value) {
//               controller.updateTextField('remarks', value);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _twoColumnFields(Widget first, Widget second) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: first),
//         AppSpace.w12,
//         Expanded(child: second),
//       ],
//     );
//   }

//   Widget _select({
//     required String field,
//     required String label,
//     required List<String> options,
//     required String value,
//     String placeholder = 'Select',
//   }) {
//     return AppSelectField(
//       label: label,
//       value: value,
//       placeholder: placeholder,
//       options: options
//           .map((item) => AppSelectOption(id: item, label: item))
//           .toList(),
//       onChanged: (option) {
//         controller.setDropdownValue(field: field, value: option.label);
//       },
//       error: controller.errors[field],
//     );
//   }

//   Widget _buildFooter() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//       decoration: BoxDecoration(
//         color: AppColor.white,
//         border: Border(top: BorderSide(color: AppColor.divider)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: Get.back,
//               style: OutlinedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 48.h),
//                 side: BorderSide(color: AppColor.primary),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               child: Text(
//                 'Cancel',
//                 style: sb14.copyWith(color: AppColor.textSecondary),
//               ),
//             ),
//           ),

//           AppSpace.w12,

//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: controller.saveJob,
//               icon: Icon(
//                 Icons.check_circle_outline,
//                 color: AppColor.white,
//                 size: 20.sp,
//               ),
//               label: Text(
//                 'Save Job',
//                 style: b14.copyWith(color: AppColor.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.primary,
//                 minimumSize: Size(double.infinity, 48.h),
//                 elevation: 5,
//                 shadowColor: AppColor.primary.withValues(alpha: 0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
