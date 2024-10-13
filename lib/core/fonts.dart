import 'package:flutter/material.dart';

class AppFonts {
  static const String notoSans = 'Noto Sans';
  static const String poppins = 'Poppins';
  static const String abeezee = 'ABeeZee';
  static const String lexend = 'Lexend';

  // Example text styles
  static const TextStyle notoSansBold = TextStyle(
    fontFamily: notoSans,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle poppinsBold = TextStyle(
    fontFamily: poppins,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle abeezeeItalic = TextStyle(
    fontFamily: abeezee,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle lexendMedium = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle lexendExtraLight = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w200,
  );
}
