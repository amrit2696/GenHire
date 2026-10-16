import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/space/space.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/core/utils/text_style.dart';
import 'app_select_field.dart';

/// A dropdown-looking field that opens a bottom sheet with a search box.
class AppSearchableSelectField extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final String searchHint;
  final List<AppSelectOption> options;
  final ValueChanged<AppSelectOption> onChanged;
  final bool required;
  final String? error;

  const AppSearchableSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.placeholder = 'Select',
    this.searchHint = 'Search…',
    this.required = true,
    this.error,
  });

  Future<void> _open(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final selected = await showModalBottomSheet<AppSelectOption>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (_) => _SearchSheet(
        title: label,
        searchHint: searchHint,
        options: options,
        selectedLabel: value,
      ),
    );

    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final hasError = error != null;

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
                border: _border(hasError ? AppColor.error : AppColor.border),
                enabledBorder: _border(
                  hasError ? AppColor.error : AppColor.border,
                ),
                errorText: error,
                errorBorder: _border(AppColor.error),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 18.sp,
                    color: AppColor.textSecondary,
                  ),
                  AppSpace.w8,
                  Expanded(
                    child: Text(
                      hasValue ? value! : placeholder,
                      overflow: TextOverflow.ellipsis,
                      style: n14.copyWith(
                        color: hasValue ? AppColor.textPrimary : AppColor.hint,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.sp,
                    color: AppColor.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
    borderSide: BorderSide(color: color),
  );
}

class _SearchSheet extends StatefulWidget {
  final String title;
  final String searchHint;
  final List<AppSelectOption> options;
  final String? selectedLabel;

  const _SearchSheet({
    required this.title,
    required this.searchHint,
    required this.options,
    required this.selectedLabel,
  });

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.options
        : widget.options
              .where((o) => o.label.toLowerCase().contains(q))
              .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select ${widget.title}',
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: n14.copyWith(color: AppColor.textPrimary),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintStyle: n14.copyWith(color: AppColor.hint),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColor.background,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColor.primary),
                  ),
                ),
              ),
            ),
            AppSpace.h8,
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No results found',
                        style: n14.copyWith(color: AppColor.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: AppColor.divider),
                      itemBuilder: (_, i) {
                        final option = filtered[i];
                        final isSelected = option.label == widget.selectedLabel;
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
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColor.primary,
                                )
                              : null,
                          onTap: () => Navigator.pop(context, option),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
