import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/View/Common/Widgets/Common/common_button.dart';
import 'package:universal_io/io.dart';

cashierSaveDialog({
  required BuildContext context,
  required Widget body,
  void Function()? onShare,
  void Function()? onSave,
  void Function()? onPrint,
  void Function()? onCancel,
}) =>
    AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        animType: AnimType.BOTTOMSLIDE,
        body: body,
        btnOk: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CommonButton(
              title: "save_dialog_first_common_button".tr,
              icon: const Icon(Icons.save),
              color: Colors.orange,
              onPressed: onSave,
            ),
            if (!kIsWeb && !Platform.isWindows)
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
