import 'dart:typed_data';
import '../constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get, Inst;

class PdfAttendance {
  SchooldetailsController controller = Get.find<SchooldetailsController>();
  

   Future<Uint8List> generateAttendanceSheet({
    required String date,
    required String studentClass,
    required String section,
    required String teacherName,
    required int presentCount,
    required int absentCount,
    required List<Map<String, dynamic>> students,
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
                      child: pw.Image(
                        watermarkImage,
                        width: 300,
                        height: 300,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              pw.Center(
                child: pw.Header(
                  child: pw.Text(
                    "Attendance Sheet - $date",
                    style: pw.TextStyle(font: font1, fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Container(
            width: double.infinity,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Class & Section: ", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.Text("$studentClass - $section", style: pw.TextStyle(font: font2, fontSize: 12)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Teacher: ", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.Text(" $teacherName", style: pw.TextStyle(font: font2, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 30),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text("Number of Present: ", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.Text(" $presentCount", style: pw.TextStyle(font: font2, fontSize: 12)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text("Number of Absent: ", style: pw.TextStyle(font: font1, fontSize: 12)),
                          pw.Text(" $absentCount", style: pw.TextStyle(font: font2, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(),
            headers: ["S.No", "Student Name", "Attendance %", "Status"],
            data: students.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final student = entry.value;
              return [
                index.toString(),
                student['name'],
                "${student['percentage']}%",
                student['attendanceStatus'],
              ];
            }).toList(),
            headerStyle: pw.TextStyle(font: font1, fontSize: 12),
            cellStyle: pw.TextStyle(font: font2, fontSize: 11),
            columnWidths: {
              0: const pw.FixedColumnWidth(40),
              1: const pw.FixedColumnWidth(150),
              2: const pw.FixedColumnWidth(80),
              3: const pw.FixedColumnWidth(80),
            },
          ),
        ],
      ),
    );
    return pdf.save();
  }

   Future<void> openPdf({
    required String date,
    required String studentClass,
    required String section,
    required String teacherName,
    required int presentCount,
    required int absentCount,
    required List<Map<String, dynamic>> students,
  }) async {
    final pdfData = await generateAttendanceSheet(
      date: date,
      studentClass: studentClass,
      section: section,
      teacherName: teacherName,
      presentCount: presentCount,
      absentCount: absentCount,
      students: students,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$studentClass - $section ( $date ).pdf");
  }
}
