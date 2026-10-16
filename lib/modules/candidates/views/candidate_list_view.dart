import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/modules/candidates/views/candidate_details_view.dart';

import '../controllers/candidate_list_controller.dart';
import '../widgets/candidate_card.dart';

class CandidateListView extends StatelessWidget {
  CandidateListView({super.key});

  final CandidateListController controller = Get.put(CandidateListController());

  static Color _primary = AppColor.primary;
  static const Color _background = Color(0xFFF6F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Selected Candidates',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF202333),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Column(
                children: [
                  _buildSummary(),
                  SizedBox(height: 16.h),
                  TextField(
                    onChanged: controller.searchCandidates,
                    decoration: InputDecoration(
                      hintText: 'Search name, email or phone',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: const BorderSide(color: Color(0xFFE9EAF0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: const BorderSide(color: Color(0xFFE9EAF0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(color: _primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _filterChip('All'),
                          SizedBox(width: 8.w),
                          _filterChip('Approved'),
                          SizedBox(width: 8.w),
                          _filterChip('Not-Join'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final candidates = controller.filteredCandidates;

                if (candidates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 56.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No candidates found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Try changing your search or filter.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];

                    return CandidateCard(
                      candidate: candidate,
                      onTap: () {
                        Get.to(
                          () => CandidateDetailsView(candidate: candidate),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.primary, AppColor.primaryDark],
          ),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _summaryValue(
                'Total Candidates',
                controller.candidates.length.toString(),
              ),
            ),
            _summaryDivider(),
            Expanded(
              child: _summaryValue(
                'Approved',
                controller.approvedCount.toString(),
              ),
            ),
            _summaryDivider(),
            Expanded(
              child: _summaryValue(
                'Not-Join',
                controller.notJoinedCount.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _summaryDivider() {
    return Container(
      height: 42.h,
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: Colors.white.withValues(alpha: 0.35),
    );
  }

  Widget _filterChip(String label) {
    final selected = controller.selectedFilter.value == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => controller.filterCandidates(label),
      backgroundColor: Colors.white,
      selectedColor: _primary,
      side: BorderSide(color: selected ? _primary : const Color(0xFFE9EAF0)),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF626678),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.r)),
    );
  }
}
