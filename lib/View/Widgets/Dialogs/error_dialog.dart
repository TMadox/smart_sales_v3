import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialog({
  required BuildContext context,
  required String title,
  required String description,
  onOk,
}) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    animType: AnimType.BOTTOMSLIDE,
    title: title,
    desc: description,
    btnOkText: "ok".tr,
    btnOkOnPress: onOk ?? () {},
  ).show();
}
