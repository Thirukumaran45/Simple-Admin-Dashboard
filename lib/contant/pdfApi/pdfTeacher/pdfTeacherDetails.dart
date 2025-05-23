import 'dart:developer' show log;
import 'dart:typed_data';
import '../../constant.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' ;
import '../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get, Inst;

class PdfTeacherDetails {
  SchooldetailsController controller = Get.find<SchooldetailsController>();

   Future<Uint8List> generateStudentDetailsSheet({
    required String fileName,
    required context,
    required String nameController,
    required String graduateDegree,
    required String subjectHandling,
    required String yearofExperience,
    required String employmentDate,
    required String phoneNumber,
    required String emailController,
    required String homeAddressController,
    Uint8List? photo,
  }) async {
    final font1 = await fontBold();
    final font2 = await fontMedium();
    final pdf = pw.Document();
    
    // Get the watermark image URL from the controller
    String? watermarkImageUrl = await controller.getSchoolPhotoUrl(context);
    final watermarkImage = watermarkImageUrl != null ? await networkImage(watermarkImageUrl) : null;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Stack(
          children: [
            if (watermarkImage != null)
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.2, // Control watermark opacity here
                    child: pw.Image(watermarkImage, fit: pw.BoxFit.contain),
                  ),
                ),
              ),
            pw.Column(
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
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    // Teacher Details (Left-aligned)
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          detailText("Name", nameController, font1, font2),
                          detailText("Graduated Degree", graduateDegree, font1, font2),
                          detailText("Year of Experience", yearofExperience, font1, font2),
                          detailText("Employment Date", employmentDate, font1, font2),
                          detailText("Subject Handling ", subjectHandling, font1, font2),
                          detailText("Phone Number", phoneNumber, font1, font2),
                          detailText("Email Address", emailController, font1, font2),
                          detailText("Home Address", homeAddressController, font1, font2),
                        ],
                      ),
                    ),
                    // Teacher Photo (Right-aligned)
                    pw.Container(
                      width: 180,
                      height: 180,
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
          ],
        ),
      ),
    );
    return pdf.save();
  }

   pw.Widget detailText(String label, String value, pw.Font font1, pw.Font font2) {
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

   Future<void> openPdf({
    required String fileName,
    required TextEditingController nameController,
    required TextEditingController employmentDate,
    required TextEditingController degreeController,
    required TextEditingController phoneNumberController,
    required TextEditingController dateOfBirthController,
    required TextEditingController emailController,
    required TextEditingController homeAddressController,
    required TextEditingController yearofExperience,
    required TextEditingController subjectHandling,
    required context,
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
      fileName: fileName, context: context,
      nameController: nameController.text,
      emailController: emailController.text,
      homeAddressController: homeAddressController.text,
      employmentDate: employmentDate.text,
      graduateDegree: degreeController.text,
      phoneNumber: phoneNumberController.text,
      yearofExperience: yearofExperience.text,
      photo: imageBytes, 
      subjectHandling: subjectHandling.text,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
