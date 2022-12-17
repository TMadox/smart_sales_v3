import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';

class Exit {
  bool commit({
    required BuildContext context,
    required bool warnExit,
    required Map data,
  }) {
    if (warnExit) {
      generalDialog(
        title: "warning".tr,
        context: context,
        message: 'receipt_still_inprogress'.tr,
        onCancelText: 'exit'.tr,
        onCancelIcon: const Icon(Icons.exit_to_app),
        onOkText: 'stay'.tr,
        onCancel: () {
          if ((GetStorage().read("request_visit") ?? false)) {
            exitDialog(
              context: context,
              data: data,
            );
            return false;
          } else {
            Get.back();
          }
        },
      );
      return false;
    } else {
      if ((GetStorage().read("request_visit") ?? false)) {
        exitDialog(
          context: context,
          data: data,
        );
        return false;
      } else {
        return true;
      }
    }
  }
}
