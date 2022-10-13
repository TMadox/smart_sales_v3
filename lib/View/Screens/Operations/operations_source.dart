import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Screens/Operations/operations_viewmodel.dart';

class OperationsSource extends DataTableSource {
  final List receipts;
  final BuildContext context;
  OperationsSource({
    required this.receipts,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    Map receipt = receipts[index];
    final cell = [
      receipt["oper_id"],
      receipt["user_name"],
      ValuesManager.doubleToString(receipt["oper_net_value_with_tax"]),
      receipt["oper_date"],
      receipt["oper_time"],
      receipt["cash_value"],
      OperationsViewmodel().receiptType(type: receipt["section_type_no"]),
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
              index != 1
                  ? SizedBox(
                      width: screenWidth(context) * 0.15,
                      child: Center(
                        child: AutoSizeText(
                          ValuesManager.doubleToString(e),
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        ValuesManager.doubleToString(e),
                      ),
                    ),
              onTap: () {
                log(receipt.toString());
                if (receipt["section_type_no"] != 9999) {
                  Navigator.of(context).pushNamed(
                    "receiptDetails",
                    arguments: receipt,
                  );
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
