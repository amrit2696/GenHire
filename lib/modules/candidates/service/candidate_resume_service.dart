import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/candidate_model.dart';

class CandidateResumeService {
  Future<Uint8List> generateResume(CandidateModel candidate) async {
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Text(
            'CURRICULUM VITAE',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            candidate.name,
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(candidate.position),
          pw.Divider(height: 30),
          pw.Text(
            'CONTACT INFORMATION',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Email: ${candidate.email}'),
          pw.Text('Phone: ${candidate.phone}'),
          pw.Text('Location: ${candidate.location}'),
          pw.SizedBox(height: 24),
          pw.Text(
            'PROFESSIONAL SUMMARY',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Motivated professional with ${candidate.experience} of '
            'experience. Interested in contributing technical knowledge, '
            'problem-solving skills, and teamwork to a growing organization.',
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'EXPERIENCE',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Bullet(text: 'Relevant experience: ${candidate.experience}'),
          pw.Bullet(text: 'Position: ${candidate.position}'),
          pw.Bullet(text: 'Location: ${candidate.location}'),
          pw.SizedBox(height: 24),
          pw.Text(
            'DOCUMENT NOTE',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'This is a sample resume generated for the GHire demo. '
            'Replace it with the actual candidate resume from your API '
            'when the backend integration is implemented.',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      ),
    );

    return document.save();
  }
}
