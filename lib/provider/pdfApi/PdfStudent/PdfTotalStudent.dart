import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfTotalStudentDetails {
  static Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required List<Map<String, dynamic>> students,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          pw.Center(
            child: pw.Header(
              child: pw.Center(
                child: pw.Text(
                  "Student Details",
                  style: pw.TextStyle(font: font1, fontSize: 24),
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 15),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(),
            headers: [
              "S.No",
              "Name",
              "Roll No",
              "Class & Section",
              "Date of Birth",
               "Total Fees",
              "Parent Name",
              "Parent Number"
            ],
            data: students.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final student = entry.value;
              return [
                index.toString(),
                student['name'],
                student['rollNumber'].toString(),
                "${student['class']} - ${student['section']}",
                student['dateOfBirth'],
                student['totalFees'].toString(),
                student['parentName'],
                student['parentMobile'],
              ];
            }).toList(),
            headerStyle: pw.TextStyle(font: font1, fontSize: 11),
            cellStyle: pw.TextStyle(font: font2, fontSize: 10),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(2),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(2),
            },
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static Future<void> openPdf({
    required String fileName,
    required List<Map<String, dynamic>> students,
  }) async {
    final pdfData = await generateStudentDetailsSheet(
      fileName: fileName,
      students: students,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
