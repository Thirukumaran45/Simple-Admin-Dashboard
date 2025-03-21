import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class PdfStaffDetails {
  static Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required String nameController,
    required String phoneNumber,
    required String emailController,
    required String homeAddressController,
    Uint8List? photo,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
           pw.Header(
            child:  pw.Center(
              child: pw.Text(nameController, style: pw.TextStyle(font: font1, fontSize: 24)),
            )
           ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Student Details (Left-aligned)
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      detailText("Name", nameController, font1, font2),
                      detailText("Phone Number",phoneNumber, font1, font2),
                      detailText("Email Address", emailController, font1, font2),
                      detailText("Home Address", homeAddressController, font1, font2),
                    ],
                  ),
                ),
                // Student Photo (Right-aligned)
                pw.Container(
                  width: 100,
                  height: 100,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: photo != null
                      ? pw.Image(pw.MemoryImage(photo))
                      : pw.Center(child: pw.Text("No Image")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  static pw.Widget detailText(String label, String value, pw.Font font1, pw.Font font2) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 120,
            child: pw.Text("$label:", style: pw.TextStyle(font: font1, fontSize: 12)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(font: font2, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  static Future<void> openPdf({
    required String fileName,
    required TextEditingController nameController,
    required TextEditingController phoneNumberController,
    required TextEditingController emailController,
    required TextEditingController homeAddressController,
    Uint8List? photo,
  }) async {
    final pdfData = await generateStudentDetailsSheet(
      fileName: fileName,
      nameController: nameController.text,
      emailController: emailController.text,
      homeAddressController: homeAddressController.text,
      phoneNumber: phoneNumberController.text,
      photo: photo,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
