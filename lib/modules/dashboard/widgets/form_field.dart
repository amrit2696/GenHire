import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class DashboardFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;

  /// Static text, used only when no [controller] is given.
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final bool required;
  final bool enabled;

  /// Looks normal (not greyed) but can't be typed into. Use with [onTap]
  /// for pickers such as the calendar.
  final bool readOnly;
  final bool multiline;
  final IconData? icon;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? error;

  const DashboardFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.value,
    this.onChanged,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.multiline = false,
    this.icon,
    this.suffixIcon,
    this.error,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final useStaticValue = controller == null && value != null;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: sb12.copyWith(color: AppColor.primary),
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: sb12.copyWith(color: AppColor.error),
                      ),
                    ]
                  : null,
            ),
          ),

          AppSpace.h5,

          TextFormField(
            key: useStaticValue ? ValueKey(value) : null,
            controller: controller,
            initialValue: useStaticValue ? value : null,
            onChanged: onChanged,
            onTap: onTap,
            enabled: enabled,
            readOnly: readOnly,
            keyboardType: keyboardType,
            maxLines: multiline ? 4 : 1,
            minLines: multiline ? 4 : 1,
            inputFormatters: inputFormatters,
            style: n14.copyWith(
              color: enabled ? AppColor.textPrimary : AppColor.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: n14.copyWith(color: AppColor.hint),
              prefixIcon: icon == null
                  ? null
                  : Icon(icon, size: 17.sp, color: AppColor.textSecondary),
              suffixIcon: suffixIcon == null
                  ? null
                  : Icon(suffixIcon, size: 18.sp, color: AppColor.primary),
              filled: true,
              fillColor: enabled
                  ? AppColor.background
                  : AppColor.disabled.withValues(alpha: 0.35),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: multiline ? 12.h : 14.h,
              ),
              border: _border(AppColor.border),
              enabledBorder: _border(AppColor.border),
              disabledBorder: _border(AppColor.border.withValues(alpha: 0.6)),
              focusedBorder: _border(AppColor.primary),
              errorBorder: _border(AppColor.error),
              focusedErrorBorder: _border(AppColor.error),
              errorText: error,
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
