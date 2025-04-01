import 'dart:typed_data';
import 'package:admin_pannel/contant/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfApi {
  

  static Future<Uint8List> generateParagraph(
    bool val,{
    required String dob,
    required String fileName,
    required String studentName,
    required String studentClass,
    required String academicYear,
    required String parentName,
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
                "Bonafide Certificate",
                style: pw.TextStyle(
                  font: font1,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Paragraph(
            text:  '''This is to certify that $studentName, son/daughter of $parentName, is a bonafide student of $schoolName, in Tamil Nadu. He/She is ${val?'currently studying in' :'successfully completed'} Class $studentClass, for the academic year $academicYear. As per our school records, his/her date of birth is $dob. During his/her tenure at our School, he/she has maintained good academic and disciplinary records. He/She is pursuing the curriculum as per the guidelines of the Government. This certificate is issued as proof of his/her enrollment and academic record. We extend our best wishes to $studentName for his/her future endeavors.''',
            style: pw.TextStyle(font: font2, fontSize: 12.5, lineSpacing: 8, letterSpacing: 0.5,),
          ),
        ],
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Date: ____________", style: pw.TextStyle(font: font2, fontSize: 12)),
                pw.SizedBox(height: 4),
                pw.Text("Place: ____________", style: pw.TextStyle(font: font2, fontSize: 12)),
              ],
            ),
            pw.Text("School Seal Stamp", style: pw.TextStyle(font: font1, fontSize: 12)),
            pw.Text("Principal Signature", style: pw.TextStyle(font: font1, fontSize: 12)),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static Future<void> openPdf({
    required String academicType,
    required String dob,
    required String fileName,
    required String studentName,
    required String studentClass,
    required String academicYear,
    required String parentName,
  }) async {
    bool isCurrentAcademic = academicType=="Current Academic"?true:false;
    final pdfData = await generateParagraph(
      isCurrentAcademic,
      fileName: fileName,
      studentName: studentName,
      studentClass: studentClass,
      academicYear: academicYear,
      parentName: parentName,
      dob: dob,
    );
    await Printing.sharePdf(bytes: pdfData, filename: "$fileName.pdf");
  }
}
