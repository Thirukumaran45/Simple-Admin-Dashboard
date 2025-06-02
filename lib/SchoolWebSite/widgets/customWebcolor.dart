
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  
Color primaryGreenColors = const Color.fromARGB(255, 38, 153, 42);
Color primaryGreenShadeColors = const Color.fromARGB(255, 149, 236, 146);
  static TextStyle aboutUsStyle = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: const Color.fromARGB(255, 38, 153, 42),
  );
   static TextStyle paragraph = GoogleFonts.ovo(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: Colors.black,
    
  );
   static TextStyle headers = GoogleFonts.crimsonText(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: Colors.black,
  );
     static TextStyle headers1 = GoogleFonts.crimsonText(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );
}
