import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void warningDialog({
  required BuildContext context,
  onOk,
  onCancel,
  required String btnOkText,
  required String btnCancelText,
  required String warningText,
}) =>
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'warning'.tr,
      desc: warningText,
      btnOkText: btnOkText,
      btnCancelText: btnCancelText,
      btnOkOnPress: onOk ?? () {},
      btnCancelOnPress: onCancel ?? () {},
    )..show();
