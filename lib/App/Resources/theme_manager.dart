import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManger {
  static ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyText1: GoogleFonts.cairo(),
      bodyText2: GoogleFonts.cairo(),
      headline2: GoogleFonts.cairo(),
      headline3: GoogleFonts.cairo(),
      headline4: GoogleFonts.cairo(),
      headline5: GoogleFonts.cairo(),
      headline6: GoogleFonts.cairo(),
      headline1: GoogleFonts.cairo(),
      subtitle1: GoogleFonts.cairo(),
      subtitle2: GoogleFonts.cairo(),
      caption: GoogleFonts.cairo(),
      button: GoogleFonts.cairo(),
      overline: GoogleFonts.cairo(),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
    ),
  );
}
