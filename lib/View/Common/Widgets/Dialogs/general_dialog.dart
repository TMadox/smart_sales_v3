import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/View/Common/Widgets/Common/common_button.dart';

generalDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? onOkText,
  Color? backgroundColor,
  final bool? dismissable,
  Color onOkTextColor = Colors.white,
  Color onCanceTextColor = Colors.white,
  String? onCancelText,
  Color? onOkColor,
  Color? onCancelColor,
  Icon? onOkIcon,
  Icon? onCancelIcon,
  DialogType? dialogType,
  Function()? onOk,
  Function()? onCancel,
}) =>
    AwesomeDialog(
      dismissOnTouchOutside: dismissable ?? false,
      dismissOnBackKeyPress: true,
      barrierColor: backgroundColor ?? Colors.black45,
      context: context,
      dialogType: dialogType ?? DialogType.QUESTION,
      animType: AnimType.SCALE,
      title: title,
      desc: message,
      btnOk: CommonButton(
        title: onOkText ?? "ok".tr,
        icon: onOkIcon ?? const Icon(Icons.check_circle),
        color: onOkColor ?? Colors.green,
        onPressed: () {
          Navigator.pop(context);
          if (onOk != null) {
            onOk();
          }
        },
      ),
      btnCancel: onCancel == null
          ? null
          : CommonButton(
              title: onCancelText.toString(),
              icon: onCancelIcon??const Icon(Icons.cancel),
              color: onCancelColor,
              onPressed: () {
                Navigator.pop(context);
                onCancel();
              },
            ),
    ).show();
