import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

doneDialog({
  required BuildContext context,
  onOk,
}) =>
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'done_dialog_title'.tr,
      desc: 'تمت العملية بنجاح'.tr,
      btnOkText: "done_dialog_btn".tr,
      btnOkOnPress: onOk ?? () {},
    )..show();
