import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ghire/core/theme/app_colors.dart';
import 'package:ghire/modules/candidates/service/candidate_resume_service.dart';
import 'package:printing/printing.dart';

import '../models/candidate_model.dart';

class CandidateResumeView extends StatefulWidget {
  final CandidateModel candidate;

  const CandidateResumeView({super.key, required this.candidate});

  @override
  State<CandidateResumeView> createState() => _CandidateResumeViewState();
}

class _CandidateResumeViewState extends State<CandidateResumeView> {
  final CandidateResumeService _resumeService = CandidateResumeService();

  bool _sharing = false;

  String get _fileName =>
      '${widget.candidate.name.replaceAll(' ', '_')}_Resume.pdf';

  Future<void> _shareResume() async {
    if (_sharing) return;

    setState(() => _sharing = true);

    try {
      final bytes = await _resumeService.generateResume(widget.candidate);

      await Printing.sharePdf(bytes: bytes, filename: _fileName);
    } catch (error, stackTrace) {
      debugPrint('RESUME SHARE ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        Get.snackbar(
          'Unable to share resume',
          'Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Resume Preview'),
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Save or share PDF',
            onPressed: _sharing ? null : _shareResume,
            icon: _sharing
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: const Color(0xFFE9EAF0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColor.primary,
                  size: 27,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Demo PDF • ${widget.candidate.name}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (_) => _resumeService.generateResume(widget.candidate),
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              canChangeOrientation: false,
              pdfFileName: _fileName,
              loadingWidget: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
