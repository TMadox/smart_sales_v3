import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Widgets/Dialogs/save_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';
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
                warningDialog(
                  context: context,
                  onCancel: () {
                    receiptCreationState.onDelete(context);
                    context.read<ReceiptViewmodel>().clearSelected();
                  },
                  btnOkText: "back".tr,
                  btnCancelText: "confirm".tr,
                  warningText: "discard_confirm".tr,
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
                warningDialog(
                  context: context,
                  warningText: 'receipt_still_inprogress'.tr,
                  btnCancelText: 'exit'.tr,
                  btnOkText: 'stay'.tr,
                  onCancel: () {
                    if ((locator
                            .get<SharedStorage>()
                            .prefs
                            .getBool("request_visit") ??
                        true)) {
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
              } else {
                if ((locator
                        .get<SharedStorage>()
                        .prefs
                        .getBool("request_visit") ??
                    true)) {
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
