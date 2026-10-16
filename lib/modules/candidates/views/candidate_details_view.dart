import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/theme/app_colors.dart';

import '../models/candidate_model.dart';
import 'candidate_resume_view.dart';

class CandidateDetailsView extends StatelessWidget {
  final CandidateModel candidate;

  const CandidateDetailsView({super.key, required this.candidate});

  static const Color _primary = AppColor.primary;

  @override
  Widget build(BuildContext context) {
    final approved = candidate.status == 'Approved';
    final statusColor = approved
        ? const Color(0xFF15803D)
        : const Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Candidate Details'),
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            padding: EdgeInsets.all(22.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColor.primary, AppColor.primaryDark],
              ),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38.r,
                  backgroundColor: Colors.white,
                  child: Text(
                    candidate.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  candidate.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  candidate.position,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    candidate.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          _sectionTitle('Personal Information'),
          _detailsCard([
            _detailRow(Icons.person_outline, 'Full Name', candidate.name),
            _detailRow(Icons.mail_outline, 'Email', candidate.email),
            _detailRow(Icons.phone_outlined, 'Phone', candidate.phone),
            _detailRow(
              Icons.badge_outlined,
              'Aadhaar Number',
              candidate.aadhaarNumber,
              copyable: true,
            ),
            _detailRow(Icons.vpn_key_outlined, 'SSO ID', candidate.ssoId),
          ]),
          SizedBox(height: 20.h),
          _sectionTitle('Professional Information'),
          _detailsCard([
            _detailRow(Icons.work_outline, 'Position', candidate.position),
            _detailRow(
              Icons.workspace_premium_outlined,
              'Experience',
              candidate.experience,
            ),
            _detailRow(
              Icons.location_on_outlined,
              'Location',
              candidate.location,
            ),
            _detailRow(
              Icons.person_outline,
              'Recruiter',
              candidate.recruiterName,
            ),
          ]),
          SizedBox(height: 20.h),
          _sectionTitle('Resume'),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17.r),
              border: Border.all(color: const Color(0xFFE9EAF0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8E8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: _primary,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${candidate.name.replaceAll(' ', '_')}_Resume.pdf',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Sample PDF • Demo document',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'View resume',
                  onPressed: () {
                    Get.to(() => CandidateResumeView(candidate: candidate));
                  },
                  icon: const Icon(Icons.visibility_outlined, color: _primary),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF202333),
        ),
      ),
    );
  }

  Widget _detailsCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: const Color(0xFFE9EAF0)),
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    bool copyable = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19.sp, color: _primary),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF303446),
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              tooltip: 'Copy Aadhaar number',
              visualDensity: VisualDensity.compact,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                Get.snackbar(
                  'Copied',
                  'Aadhaar number copied to clipboard.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: Icon(Icons.copy_rounded, size: 17.sp),
            ),
        ],
      ),
    );
  }
}
