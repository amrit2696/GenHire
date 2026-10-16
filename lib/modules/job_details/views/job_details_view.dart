import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import 'package:ghire/data/repositories/dashboard_repository.dart';
import 'package:ghire/modules/candidates/views/candidate_list_view.dart';
import 'package:ghire/modules/job_details/widgets/add_cadidate_dialog.dart';
import 'package:ghire/modules/job_details/widgets/job_stat_title.dart';
import '../controllers/job_details_controller.dart';
import '../widgets/job_details_header.dart';
import '../widgets/job_description_card.dart';
import '../widgets/hiring_progress_card.dart';

class JobDetailsView extends GetView<JobDetailsController> {
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: AppBar(
        backgroundColor: AppColor.scaffold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Job Details',
          style: b20.copyWith(color: AppColor.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            // Validate the selected job before reading its fields.
            if (!c.hasJobData) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work_off_outlined,
                        size: 48.r,
                        color: AppColor.textSecondary,
                      ),
                      AppSpace.h16,
                      Text(
                        'Job details not available',
                        style: sb16.copyWith(color: AppColor.textPrimary),
                      ),
                      AppSpace.h8,
                      Text(
                        'Please return to the dashboard and select a job again.',
                        textAlign: TextAlign.center,
                        style: n14.copyWith(color: AppColor.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JobDetailsHeader(
                    title: c.positionName,
                    location: c.location,
                    category: c.recruitmentType,
                  ),

                  AppSpace.h20,

                  JobDescriptionCard(
                    details: [
                      c.positionName,
                      'Client Name: ${c.clientName}',
                      'Branch: ${c.branchName}',
                      'Recruiter: ${c.recruiterName}',
                      'Department: ${c.department}',
                      'Minimum CTC: ${c.minimumCtc}',
                      'Qualification: ${c.qualification}',
                      'Experience: ${c.experience}',
                      'Age: ${c.ageRange}',
                      'Mandate ID: ${c.mandateId}',
                      if (c.description.isNotEmpty)
                        'Description: ${c.description}',
                    ],
                  ),

                  AppSpace.h20,

                  Row(
                    children: [
                      Expanded(
                        child: JobStatTile(
                          label: 'Total Vacancies',
                          value: '${c.vacancies}',
                          icon: Icons.people_alt_rounded,
                          accentColor: AppColor.primary,
                          backgroundColor: AppColor.primaryLight,
                        ),
                      ),
                      AppSpace.w12,
                      Expanded(
                        child: JobStatTile(
                          label: 'Selected',
                          value: '${c.selected}',
                          icon: Icons.check_circle_outline_rounded,
                          accentColor: AppColor.accent,
                          backgroundColor: AppColor.accent.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),

                  AppSpace.h20,

                  InkWell(
                    onTap: () {
                      Get.to(() => CandidateListView());
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: _SummaryTile(
                      title: 'Candidates Selected',
                      value: '${c.selected} out of ${c.vacancies}',
                      color: AppColor.accent,
                      icon: Icons.people_alt_outlined,
                    ),
                  ),

                  AppSpace.h12,

                  _SummaryTile(
                    title: 'Remaining Positions',
                    value: '${c.remaining}',
                    color: AppColor.primary,
                    icon: Icons.work_outline_rounded,
                  ),

                  AppSpace.h24,

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          title: 'Selection',
                          icon: Icons.check_circle_outline,
                          color: AppColor.primary,
                          onTap: () async {
                            final saved = await Get.dialog<bool>(
                              AddCandidateDialog(
                                repository: DashboardRepository(),
                                mandateId: int.tryParse(c.mandateId) ?? 0,

                                // Replace this with the actual recruiter ID from your
                                // authenticated user data or job model.
                                recruiterId: 540,

                                recruiterName: c.recruiterName,
                                clientName: c.clientName,
                                positionName: c.positionName,
                                positionNo: c.mandateId,
                                mandateDate: '',
                                selectedCandidate: '${c.selected}',
                              ),
                              barrierDismissible: false,
                            );

                            if (saved == true) {
                              // Refresh job/dashboard data here if required.
                            }
                          },
                        ),
                      ),
                      AppSpace.w12,
                      Expanded(
                        child: _ActionButton(
                          title: 'Joining',
                          icon: Icons.people_alt_outlined,
                          color: AppColor.accent,
                          onTap: () {
                            Get.snackbar(
                              'Joining',
                              'Connect your candidate joining screen here.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  AppSpace.h24,

                  HiringProgressCard(
                    selected: c.selected,
                    total: c.vacancies,
                    progress: c.progress,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.035),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppSpace.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: n14.copyWith(color: AppColor.textSecondary)),
                AppSpace.h4,
                Text(value, style: sb18.copyWith(color: AppColor.textPrimary)),
              ],
            ),
          ),
          Icon(icon, color: color, size: 22.r),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 21.r),
        label: Text(title, style: sb14.copyWith(color: AppColor.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColor.white,
          elevation: 3,
          shadowColor: color.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
      ),
    );
  }
}
