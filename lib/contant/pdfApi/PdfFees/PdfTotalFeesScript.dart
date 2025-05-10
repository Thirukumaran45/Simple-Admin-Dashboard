import 'dart:typed_data';
import 'package:admin_pannel/contant/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:admin_pannel/controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get, Inst;

class PdfTotalFeesScript {
  
  SchooldetailsController controller = Get.find<SchooldetailsController>();
   Future<Uint8List> generateFeesTransactionSheet({
    required String fileName,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    String? watermarkImageUrl = await controller.getSchoolPhotoUrl();
    final watermarkImage = watermarkImageUrl != null ? await networkImage(watermarkImageUrl) : null;
    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          pw.Stack(
            children: [
              if (watermarkImage != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.2,
                      child: pw.Image(watermarkImage,
                        width: 300,
                        height: 300,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              pw.Column(
                children: [
                  pw.Center(
                    child: pw.Header(
                      child: pw.Center(
                        child: pw.Text(
                          "Fees Transaction Histry",
                          style: pw.TextStyle(font: font1, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.TableHelper.fromTextArray(
                    border: pw.TableBorder.all(),
                    headers: ["Name", "Class & Section", "Total Amount", "Paid Amount", "Balance Amount", "Payment Date"],
                    data: transactions.map((transaction) {
                      return [
                        transaction['studentName'],
                        "${transaction['class']} ${transaction['section']}",
                        transaction['totalAmount'].toString(),
                        transaction['paidAmount'].toString(),
                        transaction['balanceAmount'].toString(),
                        transaction['paymentDate'],
                      ];
                    }).toList(),
                    headerStyle: pw.TextStyle(font: font1, fontSize: 11),
                    cellStyle: pw.TextStyle(font: font2, fontSize: 10),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(2),
                      4: const pw.FlexColumnWidth(2),
                      5: const pw.FlexColumnWidth(2),
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    return pdf.save();
  }

   Future<void> openPdf({
    required String fileName,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final pdfData = await generateFeesTransactionSheet(
      fileName: fileName,
      transactions: transactions,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
