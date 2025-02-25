import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfTotalStaffDetails {
  static Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required List<Map<String, dynamic>> staff,
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
                  "Working Staff Details",
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
              "email",
              "Mobile Number",
              "Home Address"
            ],
            data: staff.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final staff = entry.value;
              return [
                index.toString(),
                staff['name'],
                staff['email'],
                staff['phone'],
                staff['address']
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
    required List<Map<String, dynamic>> staff,
  }) async {
    final pdfData = await generateStudentDetailsSheet(
      fileName: fileName,
      staff: staff,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
 