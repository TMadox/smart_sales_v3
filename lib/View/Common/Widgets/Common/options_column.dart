import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Common/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/save_dialog.dart';
import 'package:smart_sales/View/Screens/Items/items_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class OptionsColumn extends StatelessWidget {
  final Map data;
  final ReceiptsController controller;
  const OptionsColumn({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          OptionsButton(
            height: 30,
            color: Colors.blue,
            onPressed: () {
              Get.to(() => const ItemsView(canTap: true));
            },
            iconData: Icons.add,
          ),
          const SizedBox(
            height: 5,
          ),
          OptionsButton(
            height: 30,
            color: Colors.purple,
            onPressed: () {
              Get.find<ReceiptsController>().scanBarcode(context: context);
            },
            iconData: Icons.qr_code,
          ),
          const SizedBox(
            height: 5,
          ),
          OptionsButton(
            height: 30,
            color: Colors.pink,
            onPressed: () {
              // showSelectReceiptsDialog(context: context);
            },
            iconData: Icons.copy_rounded,
          ),
          const SizedBox(
            height: 5,
          ),
          OptionsButton(
            height: 40,
            color: Colors.orange,
            onPressed: () {
              if (controller.receiptItems.value.isEmpty) {
                showAlertSnackbar(
                  context: context,
                  text: "no_items".tr,
                );
              } else {
                saveDialog(
                  context: context,
                  onSave: () async {
                    Get.back();
                    EasyLoading.show();
                    await controller.onFinishOperation(
                      context: context,
                    );
                    EasyLoading.dismiss();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.homeRoute, (route) => false);
                  },
                  onCancel: () {
                    Get.back();
                  },
                  onPrint: () async {
                    Get.back();
                    EasyLoading.show();
                    await controller.onFinishOperation(
                      context: context,
                      doShare: false,
                      doPrint: true,
                    );
                    EasyLoading.dismiss();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.homeRoute,
                      (route) => false,
                    );
                  },
                  onShare: () async {
                    Get.back();
                    EasyLoading.show();
                    await controller.onFinishOperation(
                      context: context,
                      doShare: true,
                      doPrint: true,
                    );
                    EasyLoading.dismiss();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.homeRoute,
                      (route) => false,
                    );
                  },
                  sectionTypeNo: 0,
                  operation: controller.currentReceipt.value,
                );
              }
            },
            iconData: Icons.save,
          ),
          const SizedBox(
            height: 5,
          ),
          OptionsButton(
            height: 30,
            color: Colors.indigo,
            onPressed: () {
              if (controller.selectedItems.value.isNotEmpty) {
                generalDialog(
                  title: "warning".tr,
                  context: context,
                  onCancel: () {
                    controller.deleteItems(context: context);
                  },
                  onOkText: "back".tr,
                  onCancelText: "confirm".tr,
                  message: "discard_confirm".tr,
                );
              } else {
                showAlertSnackbar(
                  context: context,
                  text: "not_items_to_discard".tr,
                );
              }
            },
            iconData: Icons.delete,
          ),
          const SizedBox(
            height: 5,
          ),
          OptionsButton(
            height: 30,
            color: Colors.red,
            onPressed: () {
              if (controller.receiptItems.value.isNotEmpty) {
                generalDialog(
                  context: context,
                  message: 'receipt_still_inprogress'.tr,
                  onCancelText: 'exit'.tr,
                  onOkText: 'stay'.tr,
                  onCancel: () {
                    if (GetStorage().read("request_visit") ?? false) {
                      exitDialog(
                        context: context,
                        data: data,
                      );
                      return false;
                    } else {
                      Get.back();
                    }
                  },
                  title: 'warning'.tr,
                );
              } else {
                if ((GetStorage().read("request_visit") ?? false)) {
                  exitDialog(
                    context: context,
                    data: data,
                  );
                } else {
                  Get.back();
                }
              }
            },
            iconData: Icons.arrow_back_ios,
          ),
        ],
      ),
    );
  }
}
