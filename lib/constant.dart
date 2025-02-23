import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

const schoolName = " Nag Vidhyashram CBSE School , Poonamalle , Chennai - 600056 ";

Future<pw.Font> fontBold() async {
    final fontData = await rootBundle.load("fonts/Bitter-Bold.ttf");
    return pw.Font.ttf(fontData);
  }
  Future<pw.Font> fontMedium() async {
    final fontData = await rootBundle.load("fonts/Bitter-Medium.ttf");
    return pw.Font.ttf(fontData);
  }