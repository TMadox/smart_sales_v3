import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

responseSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.cairo(),
      ),
    ),
  );
}
