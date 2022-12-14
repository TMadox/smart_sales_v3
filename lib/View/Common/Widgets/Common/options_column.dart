import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/View/Common/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/save_dialog.dart';
import 'package:smart_sales/View/Screens/Items/items_view.dart';
import 'package:smart_sales/View/Screens/Operations/operations_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class OptionsColumn extends StatelessWidget {
  final Map data;
  final ReceiptsController controller;
  final bool isEditing;
  const OptionsColumn({
    Key? key,
    required this.data,
    required this.controller,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isEditing)
          Expanded(
            flex: 2,
            child: OptionsButton(
              color: Colors.blue,
              onPressed: () {
                Get.to(() => const ItemsView(canTap: true));
              },
              iconData: Icons.add,
            ),
          ),
        Expanded(
          flex: 2,
          child: OptionsButton(
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
        ),
        if (!isEditing) ...[
          Expanded(
            child: OptionsButton(
              height: 50,
              bottomMargin: 0,
              color: Colors.pink,
              onPressed: () {
                Get.to(
                  () => const OperationsView(
                    selecting: true,
                  ),
                );
              },
              iconData: Icons.copy_rounded,
            ),
          ),
          const SizedBox(height: 5)
        ],
        if (!isEditing)
          Expanded(
            child: OptionsButton(
              height: 50,
              bottomMargin: 0,
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
          ),
      ],
    );
  }
}
