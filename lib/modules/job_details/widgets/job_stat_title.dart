import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class JobStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;

  const JobStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 25.r),
          AppSpace.h12,
          Text(value, style: xb24.copyWith(color: AppColor.textPrimary)),
          AppSpace.h4,
          Text(label, style: n12.copyWith(color: AppColor.textSecondary)),
        ],
      ),
    );
  }
}
