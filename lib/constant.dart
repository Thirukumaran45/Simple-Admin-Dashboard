import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

const schoolName = " Nag Vidhyashram CBSE School , Poonamalle , Chennai - 600056 ";
final DateTime todayDateTime = todayDateTime;

Future<pw.Font> fontBold() async {
    final fontData = await rootBundle.load("fonts/Bitter-Bold.ttf");
    return pw.Font.ttf(fontData);
  }
  Future<pw.Font> fontMedium() async {
    final fontData = await rootBundle.load("fonts/Bitter-Medium.ttf");
    return pw.Font.ttf(fontData);
  }

Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> customSnackbar({required BuildContext context,required String text })async{
     
           return  ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(text
                                  )));
}
