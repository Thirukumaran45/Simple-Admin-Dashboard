import 'dart:typed_data';
import '../../constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get, Inst;

class PdfTotalStaffDetails {
  SchooldetailsController controller = Get.find<SchooldetailsController>();

   Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required context,
    required List<Map<String, dynamic>> staff,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    // Fetch watermark image URL
    String? watermarkImageUrl = await controller.getSchoolPhotoUrl(context);
    final watermarkImage = watermarkImageUrl != null ? await networkImage(watermarkImageUrl) : null;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          // Adding the watermark image centered on the page
          if (watermarkImage != null)
            pw.Stack(
              children: [
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.2, // Adjust opacity to make it subtle
                      child: pw.Image(watermarkImage, fit: pw.BoxFit.contain, width: 300, height: 300),
                    ),
                  ),
                ),
                pw.Column(
                  children: [
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
                        "Email",
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
                      },
                    ),
                  ],
                ),
              ],
            )
          else
            pw.Column(
              children: [
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
                    "Email",
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
                  },
                ),
              ],
            ),
        ],
      ),
    );
    return pdf.save();
  }

   Future<void> openPdf({
    required context,
    required String fileName,
    required List<Map<String, dynamic>> staff,
  }) async {
    final pdfData = await generateStudentDetailsSheet(context: context,
      fileName: fileName,
      staff: staff,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
