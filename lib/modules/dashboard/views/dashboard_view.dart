import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import 'package:ghire/modules/dashboard/widgets/job_posting_header.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/job_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              RefreshIndicator(
                color: AppColor.primary,
                onRefresh: controller.refreshDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Column(
                    children: [
                      DashboardHeader(
                        userName: controller.userName.value,
                        onLogout: controller.logout,
                      ),

                      AppSpace.h16,

                      _buildStats(),

                      AppSpace.h16,

                      JobPostingsHeader(
                        totalJobs: controller.dashboard.value?.jobs.length ?? 0,
                        onAddJob: controller.openAddJob,
                      ),

                      AppSpace.h16,

                      _buildJobs(),

                      AppSpace.h10,
                    ],
                  ),
                ),
              ),

              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: AppColor.white.withValues(alpha: 0.55),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStats() {
    final data = controller.dashboard.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          DashboardStatCard(
            label: 'Job Openings',
            value: data?.mandateCount ?? 0,
            imagePath: 'assets/icons/briefcase.png',
            iconColor: const Color(0xFF5145CD),
            backgroundColor: const Color(0xFFEAE8FF),
          ),

          DashboardStatCard(
            label: 'Joining',
            value: data?.joiningCount ?? 0,
            imagePath: 'assets/icons/tick.png',
            iconColor: const Color(0xFF16834A),
            backgroundColor: const Color(0xFFDDF5E6),
          ),

          DashboardStatCard(
            label: 'Kyc',
            value: data?.kycCount ?? 0,
            imagePath: 'assets/icons/man.png',
            iconColor: const Color(0xFF087EA4),
            backgroundColor: const Color(0xFFDDF3FA),
          ),

          DashboardStatCard(
            label: 'Payroll',
            value: data?.payrollCount ?? 0,
            imagePath: 'assets/icons/payroll.png',
            iconColor: const Color(0xFFB96A08),
            backgroundColor: const Color(0xFFFFEDCC),
          ),
        ],
      ),
    );
  }

  Widget _buildJobs() {
    final jobs = controller.dashboard.value?.jobs ?? [];

    final displayedJobs = controller.showAllJobs.value
        ? jobs
        : jobs.take(4).toList();

    if (jobs.isEmpty && !controller.isLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Text(
          'No job postings found.',
          style: n14.copyWith(color: AppColor.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: displayedJobs
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: JobCard(
                      job: entry.value,
                      accentColor: _getJobColor(entry.key),
                      onTap: () {
                        controller.openJobDetails(entry.value);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        if (jobs.length > 4)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _buildViewAllButton(),
          ),
      ],
    );
  }

  Widget _buildViewAllButton() {
    final showAll = controller.showAllJobs.value;

    return OutlinedButton(
      onPressed: controller.toggleShowAllJobs,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 48.h),
        backgroundColor: AppColor.white,
        side: BorderSide(color: AppColor.primary.withValues(alpha: 0.20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showAll)
            Image.asset(
              'assets/icons/top.png',
              width: 16.w,
              height: 16.w,
              color: AppColor.primary,
            ),

          if (showAll) AppSpace.w8,

          Text(
            showAll ? 'Show Less' : 'View All Jobs',
            style: sb14.copyWith(color: AppColor.primary),
          ),

          if (!showAll) AppSpace.w8,

          if (!showAll)
            Image.asset(
              'assets/icons/arrow.png',
              width: 16.w,
              height: 16.w,
              color: AppColor.primary,
            ),
        ],
      ),
    );
  }

  Color _getJobColor(int index) {
    final colors = [
      AppColor.primary,
      AppColor.success,
      AppColor.info,
      AppColor.warning,
      AppColor.accent,
      AppColor.secondary,
    ];

    return colors[index % colors.length];
  }
}
