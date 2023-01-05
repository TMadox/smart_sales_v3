import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Common/Features/receipt_type.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/settings_dialog.dart';
import 'package:smart_sales/View/Screens/Operations/operations_controller.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class OperationsSource extends DataTableSource {
  final List receipts;
  final BuildContext context;
  final OperationsController controller;
  final bool isSelecting;
  OperationsSource({
    required this.receipts,
    required this.context,
    required this.controller,
    required this.isSelecting,
  });

  @override
  DataRow? getRow(int index) {
    Map receipt = receipts[index];
    final cell = [
      receipt["oper_id"],
      receipt["user_name"],
      ValuesManager.numToString(receipt["oper_net_value_with_tax"]),
      receipt["oper_date"],
      receipt["oper_time"],
      receipt["cash_value"],
      ReceiptType().get(type: receipt["section_type_no"]),
      receipt["is_sender_complete_status"] == 0
          ? "select_receipt_dialog_No".tr
          : "select_receipt_dialog_yes".tr
    ];
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if ((index % 2) == 0) {
          return Colors.grey[200];
        }
        return null;
      }),
      cells: cell
          .mapIndexed(
            (index, e) => DataCell(
              Center(
                child: SizedBox(
                  width: index == 1 ? 100 : 50,
                  child: AutoSizeText(
                    ValuesManager.numToString(e),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // onLongPress: () {
              //   generalDialog(
              //     context: context,
              //     title: "warning".tr,
              //     message:
              //         "do you really want to move this operation to recylce pin"
              //             .tr,
              //     dialogType: DialogType.WARNING,
              //     onOk: () async {
              //       await Get.find<OperationsController>()
              //           .moveToRecyclePin(input: receipt, context: context);
              //     },
              //     onOkText: "confirm".tr,
              //     onCancel: () {},
              //   );
              // },
              onLongPress: () {
                if (receipt["upload_code"] == -1 ||
                    receipt["upload_code"] == -19 ||
                    receipt["upload_code"] == -30 ||
                    receipt["upload_code"] == "[]") {
                  generalDialog(
                    context: context,
                    title: "warning".tr,
                    message:
                        "do you really want to move this operation to recylce pin"
                            .tr,
                    dialogType: DialogType.WARNING,
                    onOk: () async {
                      passwordDialog(
                        context: context,
                        title: 'settings'.tr,
                        onCheck: () async {
                          await Get.find<OperationsController>()
                              .moveToRecyclePin(
                                  input: receipt, context: context);
                        },
                      );
                    },
                    onOkText: "confirm".tr,
                    onCancel: () {},
                  );
                }
              },
              onTap: () {
                if (isSelecting) {
                  Get.find<ReceiptsController>().fillReceiptWithItems(
                    input: List.from(json.decode(receipt["products"])),
                  );
                  Get.back();
                } else {
                  if (receipt["section_type_no"] != 9999) {
                    Navigator.of(context).pushNamed(
                      "receiptDetails",
                      arguments: receipt,
                    );
                  }
                }
              },
            ),
          )
          .toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => receipts.length;

  @override
  int get selectedRowCount => 0;
}
