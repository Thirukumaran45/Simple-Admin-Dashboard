import 'dart:typed_data';
import '../../constant.dart';
import '../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfSinglescript {
  SchooldetailsController controller = Get.find<SchooldetailsController>();

  Future<Uint8List> generateParagraph({
    required String studentName,
    required String studentClass,
    required String section,
    required String studentId,
    required String paidAmount,
    required Map<String, dynamic> fees,
    required String balanceAmount,
    required String totalAllocatedAmount,
    required String paymentDate,
    required String paymentMonth,
    required String transactionId,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();
    String? watermarkImageUrl = await controller.getSchoolPhotoUrl();
    final watermarkImage = watermarkImageUrl != null ? await networkImage(watermarkImageUrl) : null;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Stack(
            children: [
              if (watermarkImage != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.2,
                      child: pw.Image(
                        watermarkImage,
                        width: 300,
                        height: 300,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              pw.Column(
                children: [
                  pw.Header(
                    child: pw.Center(
                      child: pw.Text(
                        "Fees Payment Receipt",
                        style: pw.TextStyle(
                          font: font1,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Student Name:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Class & Section:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Student ID:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Paid Amount:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          ...List.generate((fees['fee_amount'] as List).length, (index) {
                            return pw.Column(
                              children: [
                                pw.Text(
                                  "Subject of Payment Amount:",
                                  style: pw.TextStyle(font: font1, fontSize: 12),
                                ),
                                pw.SizedBox(height: 5),
                              ],
                            );
                          }),
                          pw.Text("Balance Amount:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Total Allocated Amount:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Payment Date:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Payment Month:", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("Transaction ID:", style: pw.TextStyle(font: font1, fontSize: 12)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(studentName, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text("$studentClass - $section", style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(studentId, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(paidAmount, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          if (fees['fee_amount'] != null &&
                              fees['feeAmount'] != null &&
                              fees['fee_amount'] is List &&
                              fees['feeAmount'] is List)
                            ...List.generate((fees['fee_amount'] as List).length, (index) {
                              final fee1 = (fees['fee_amount'] as List)[index];
                              final fee2 = index < (fees['feeAmount'] as List).length
                                  ? (fees['feeAmount'] as List)[index]
                                  : '';
                              return pw.Column(
                                children: [
                                  pw.Text("$fee1 - ₹$fee2", style: pw.TextStyle(font: font2, fontSize: 12)),
                                  pw.SizedBox(height: 5),
                                ],
                              );
                            })
                          else ...[
                            pw.Text('N/A', style: pw.TextStyle(font: font2, fontSize: 12)),
                            pw.SizedBox(height: 5),
                          ],
                          pw.Text(balanceAmount, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(totalAllocatedAmount, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(paymentDate, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(paymentMonth, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 5),
                          pw.Text(transactionId, style: pw.TextStyle(font: font2, fontSize: 12)),
                          pw.SizedBox(height: 180),
                          pw.Text("School Stamp to Verify", style: pw.TextStyle(font: font1, fontSize: 14)),
                        ],
                      ),
                    ],
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
    required String studentName,
    required Map<String, dynamic> fees,
    required String studentClass,
    required String section,
    required String studentId,
    required String paidAmount,
    required String balanceAmount,
    required String totalAllocatedAmount,
    required String paymentDate,
    required String paymentMonth,
    required String transactionId,
  }) async {
    final pdfData = await generateParagraph(
      studentName: studentName,
      studentClass: studentClass,
      section: section,
      fees: fees,
      studentId: studentId,
      paidAmount: paidAmount,
      balanceAmount: balanceAmount,
      totalAllocatedAmount: totalAllocatedAmount,
      paymentDate: paymentDate,
      paymentMonth: paymentMonth,
      transactionId: transactionId,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "Fees_Payment_Receipt.pdf");
  }
}
