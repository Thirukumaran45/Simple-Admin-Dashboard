import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfSinglescript {
  static Future<Uint8List> generateParagraph({
    required String studentName,
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
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
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
                  pw.Text("School Seal Stamp to Verify", style: pw.TextStyle(font: font1, fontSize: 14)),
                
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<void> openPdf({
    required String studentName,
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
