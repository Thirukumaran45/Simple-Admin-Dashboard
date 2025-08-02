import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:pdf/widgets.dart' as pw;

final DateTime todayDateTime = DateTime.now();

Future<pw.Font> fontBold() async {
  final fontData = await rootBundle.load('assets/fonts/Bitter-Bold.ttf');
  final buffer = fontData.buffer;
  final byteData = ByteData.view(buffer);
  return pw.Font.ttf(byteData);
}

Future<pw.Font> fontMedium() async {
  final fontData = await rootBundle.load('assets/fonts/Bitter-Medium.ttf');
  final buffer = fontData.buffer;
  final byteData = ByteData.view(buffer);
  return pw.Font.ttf(byteData);
}




