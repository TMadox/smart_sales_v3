import 'package:flutter/material.dart';

showAlertSnackbar({required BuildContext context, required String text}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
