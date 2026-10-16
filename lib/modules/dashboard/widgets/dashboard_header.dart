import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.onLogout,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 5.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: xb22.copyWith(color: AppColor.textPrimary),
                ),
                AppSpace.h2,
                Text(
                  'Welcome back, ${userName.isEmpty ? 'User' : userName}!',
                  style: n14.copyWith(color: AppColor.textSecondary),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onLogout,
            icon: Image.asset(
              'assets/icons/turn-off.png',
              height: 24.h,
              width: 24.w,
              color: AppColor.textPrimary,
            ),
          ),

          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primary, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/profile.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
