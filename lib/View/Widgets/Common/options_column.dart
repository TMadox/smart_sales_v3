import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/save_dialog.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Widgets/Dialogs/select_receipt_dialog.dart';

class OptionsColumn extends StatelessWidget {
  final double height;
  final Map data;
  const OptionsColumn({Key? key, required this.height, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receiptCreationState = context.read<ReceiptViewmodel>();
    return SingleChildScrollView(
      child: Column(
        children: [
          OptionsButton(
            height: height * 0.09,
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.itemsRoute, arguments: true);
            },
            iconData: Icons.add,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          OptionsButton(
            height: height * 0.06,
            color: Colors.purple,
            onPressed: () {
              context.read<ReceiptViewmodel>().scanBarcode(context: context);
            },
            iconData: Icons.qr_code,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          OptionsButton(
            height: height * 0.06,
            color: Colors.pink,
            onPressed: () {
              showSelectReceiptsDialog(context: context);
            },
            iconData: Icons.copy_rounded,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          OptionsButton(
            height: height * 0.11,
            color: Colors.orange,
            onPressed: () {
              if (context.read<GeneralState>().receiptItems.isEmpty) {
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
                    await receiptCreationState.onFinishOperation(
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
                    await receiptCreationState.onFinishOperation(
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
                    await receiptCreationState.onFinishOperation(
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
                );
              }
            },
            iconData: Icons.save,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          OptionsButton(
            height: height * 0.06,
            color: Colors.indigo,
            onPressed: () {
              if (receiptCreationState.selectedItems.isNotEmpty) {
                generalDialog(
                  title: "warning".tr,
                  context: context,
                  onCancel: () {
                    receiptCreationState.onDeleteItem(context);
                    context.read<ReceiptViewmodel>().clearSelected();
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
          SizedBox(
            height: height * 0.01,
          ),
          OptionsButton(
            height: height * 0.06,
            color: Colors.red,
            onPressed: () {
              if (context.read<GeneralState>().receiptItems.isNotEmpty) {
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
