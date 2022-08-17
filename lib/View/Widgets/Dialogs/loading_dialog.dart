import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Colors.green,
        ),
        Text(
          "جاري المعالجة",
          style: GoogleFonts.cairo(),
        )
      ],
    ),
  );
  showAnimatedDialog(                                              
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.fastOutSlowIn,
  );
}
