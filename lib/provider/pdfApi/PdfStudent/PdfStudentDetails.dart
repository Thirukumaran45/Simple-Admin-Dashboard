import 'dart:developer' show log;
import 'dart:typed_data';
import 'package:admin_pannel/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class PdfStudentDetails {
 static Future<Uint8List> generateStudentDetailsSheet({
  required String fileName,
  required String nameController,
  required String classController,
  required String sectionController,
  required String fatherNameController,
  required String fatherPhoneController,
  required String motherNameController,
  required String motherPhoneController,
  required String dateOfBirthController,
  required String emailController,
  required String homeAddressController,
  required String totalFeesController,
  required String pendingFeesController,
  Uint8List? photo, // Ensure it's Uint8List
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
            child: pw.Center(
              child: pw.Text(nameController, style: pw.TextStyle(font: font1, fontSize: 24)),
            ),
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
                    detailText("Class & Section", "$classController $sectionController", font1, font2),
                    detailText("Father Name", fatherNameController, font1, font2),
                    detailText("Father Phone.No", fatherPhoneController, font1, font2),
                    detailText("Mother Name", motherNameController, font1, font2),
                    detailText("Mother Phone.No", motherPhoneController, font1, font2),
                    detailText("Date of Birth", dateOfBirthController, font1, font2),
                    detailText("Email Address", emailController, font1, font2),
                    detailText("Home Address", homeAddressController, font1, font2),
                    detailText("Total Fees", totalFeesController, font1, font2),
                    detailText("Pending Fees", pendingFeesController, font1, font2),
                  ],
                ),
              ),
              // Student Photo (Right-aligned)
              pw.Container(
                width: 180,
                height: 180,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: photo != null
                    ? pw.Image(pw.MemoryImage(photo)) // Load image if available
                    : pw.Center(child: pw.Text("No Image")), // Fallback text if no image
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
  required TextEditingController classController,
  required TextEditingController sectionController,
  required TextEditingController fatherNameController,
  required TextEditingController fatherPhoneController,
  required TextEditingController motherNameController,
  required TextEditingController motherPhoneController,
  required TextEditingController dateOfBirthController,
  required TextEditingController emailController,
  required TextEditingController homeAddressController,
  required TextEditingController totalFeesController,
  required TextEditingController pendingFeesController,
  required String? assetImage, // Now it's a String (URL)
}) async {
  Uint8List? imageBytes;

  if (assetImage != null && assetImage.isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(assetImage));
      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes;
      }
    } catch (e) {
      log("Error loading image: $e");
    }
  }

  final pdfData = await generateStudentDetailsSheet(
    fileName: fileName,
    nameController: nameController.text,
    classController: classController.text,
    sectionController: sectionController.text,
    fatherNameController: fatherNameController.text,
    fatherPhoneController: fatherPhoneController.text,
    motherNameController: motherNameController.text,
    motherPhoneController: motherPhoneController.text,
    dateOfBirthController: dateOfBirthController.text,
    emailController: emailController.text,
    homeAddressController: homeAddressController.text,
    totalFeesController: totalFeesController.text,
    pendingFeesController: pendingFeesController.text,
    photo: imageBytes, // Pass image bytes instead of URL
  );

  await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
}
}