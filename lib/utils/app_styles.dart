import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primary = const Color(0xFF2DB515);

class Styles {
  static Color primaryColor = primary;
  static Color bgColor = const Color(0xFFFFFFFF);
  static Color textColor = const Color(0xFF000000);
  static Color text2Color = const Color(0xffFF8718);
  static Color text3Color = const Color(0xff2DB515);
  static Color cardColor = const Color(0xFFf4f4f4);
  static Color cardColor2 = const Color(0xFF43D685);
  static Color buttonColor = const Color(0xFFffa600);
  static TextStyle heading = GoogleFonts.montserrat(
    fontSize: 36,
    color: text2Color,
    fontWeight: FontWeight.w900,
  );

  static TextStyle heading1 = GoogleFonts.montserrat(
    color: Colors.black,
    fontSize: 36,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading2 = GoogleFonts.montserrat(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle heading3 = GoogleFonts.montserrat(
    fontSize: 19,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle heading4 = GoogleFonts.montserrat(
    fontSize: 15,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal = GoogleFonts.montserrat(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  static TextStyle normal2 = GoogleFonts.montserrat(
    fontSize: 14,
    color: Colors.grey,
  );

  static TextStyle notification = GoogleFonts.robotoSlab(
    textStyle: TextStyle(
        fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
  );
  static DecorationImage imageDefault = DecorationImage(
    image: AssetImage('assets/images/logo3_1'),
    fit: BoxFit.cover,
  );
}