import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';

saveDialog({
  required BuildContext context,
  void Function()? onShare,
  void Function()? onSave,
  void Function()? onPrint,
  void Function()? onCancel,
}) =>
    AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        animType: AnimType.BOTTOMSLIDE,
        title: 'save_dialog_title'.tr,
        desc: 'save_dialog_desc'.tr,
        btnOk: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CommonButton(
              title: "save_dialog_first_common_button".tr,
              icon: const Icon(Icons.save),
              color: Colors.orange,
              onPressed: onSave,
            ),
            CommonButton(
              title: "save_dialog_second_common_button".tr,
              icon: const Icon(Icons.share),
              color: Colors.green,
              onPressed: onShare,
            ),
            CommonButton(
              title: "save_dialog_third_common_button".tr,
              icon: const Icon(Icons.print),
              color: Colors.purple,
              onPressed: onPrint,
            ),
            CommonButton(
              title: "save_dialog_fourth_common_button".tr,
              icon: const Icon(Icons.cancel),
              color: Colors.red,
              onPressed: onCancel,
            ),
          ],
        )).show();
