import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfTotalFeesScript {
  
  static Future<Uint8List> generateFeesTransactionSheet({
    required String fileName,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          pw.Center(
            child:pw.Header(
              child:  pw.Center(child: pw.Text(
              "Fees Transaction Histry",
              style: pw.TextStyle(font: font1, fontSize: 24),
            ),)
            )
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
            headerStyle: pw.TextStyle(font: font1, fontSize: 12),
            cellStyle: pw.TextStyle(font: font2, fontSize: 11),
            columnWidths: {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
            },
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static Future<void> openPdf({
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
