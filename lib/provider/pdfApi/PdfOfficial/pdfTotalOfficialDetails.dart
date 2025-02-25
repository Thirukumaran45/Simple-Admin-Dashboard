import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfTotalOfficialDetails {
  static Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required List<Map<String, dynamic>> officials,
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
                  "Higher Official Details",
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
              "Degree",
              "email",
              "Date of Birth",
              "Employment Date",
              "Mobile Number"
            ],
            data: officials.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final officials = entry.value;
              return [
                index.toString(),
                officials['name'],
                officials['degree'],
                officials['email'],
                "12-12-2002",
                '05-02-2025',
                officials['phone'],
              ];
            }).toList(),
            headerStyle: pw.TextStyle(font: font1, fontSize: 11),
            cellStyle: pw.TextStyle(font: font2, fontSize: 10),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
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
    required List<Map<String, dynamic>> officials,
  }) async {
    final pdfData = await generateStudentDetailsSheet(
      fileName: fileName,
      officials: officials,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
 