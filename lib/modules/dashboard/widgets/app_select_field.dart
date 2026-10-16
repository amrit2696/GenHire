import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';

class AppSelectOption {
  final String id;
  final String label;

  const AppSelectOption({required this.id, required this.label});
}

/// Dropdown-style field that opens a bottom sheet list.
///
/// Built without DropdownButtonFormField, which was the widget in every
/// render-tree assertion. If [onLockedTap] is set, the field is "locked":
/// tapping it runs that callback instead of opening the list.
class AppSelectField extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final List<AppSelectOption> options;
  final ValueChanged<AppSelectOption> onChanged;
  final bool required;
  final String? error;
  final VoidCallback? onLockedTap;

  const AppSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.options,
    required this.onChanged,
    this.required = true,
    this.error,
    this.onLockedTap,
  });

  Future<void> _open(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (onLockedTap != null) {
      onLockedTap!();
      return;
    }

    if (options.isEmpty) return;

    final selected = await showModalBottomSheet<AppSelectOption>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (_) =>
          _OptionSheet(title: label, options: options, selectedLabel: value),
    );

    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

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

          InkWell(
            onTap: () => _open(context),
            borderRadius: BorderRadius.circular(10.r),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.background,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
                border: _border(AppColor.border),
                enabledBorder: _border(AppColor.border),
                errorBorder: _border(AppColor.error),
                focusedErrorBorder: _border(AppColor.error),
                errorText: error,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: n14.copyWith(
                        color: hasValue ? AppColor.textPrimary : AppColor.hint,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColor.primary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color),
    );
  }
}

class _OptionSheet extends StatelessWidget {
  final String title;
  final List<AppSelectOption> options;
  final String? selectedLabel;

  const _OptionSheet({
    required this.title,
    required this.options,
    required this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.65;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSpace.h12,
          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select $title',
                    style: b14.copyWith(color: AppColor.textPrimary),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColor.divider),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              itemCount: options.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: AppColor.divider),
              itemBuilder: (_, index) {
                final option = options[index];
                final isSelected = option.label == selectedLabel;

                return ListTile(
                  title: Text(
                    option.label,
                    style: (isSelected ? sb14 : n14).copyWith(
                      color: isSelected
                          ? AppColor.primary
                          : AppColor.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColor.primary)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
