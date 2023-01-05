// ignore_for_file: implementation_imports
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Common/Features/receipt_type.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Screens/Recycle/recycle_controller.dart';

class RecycleView extends StatefulWidget {
  const RecycleView({
    Key? key,
  }) : super(key: key);

  @override
  State<RecycleView> createState() => _RecycleViewState();
}

class _RecycleViewState extends State<RecycleView> {
  bool isLoading = false;
  String searchWord = "";
  int filterSectionType = 0;
  @override
  void initState() {
    Get.find<RecycleController>().loadOperations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.green),
          title: Text(
            "recycle bin".tr,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.green, width: 4),
            ),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            child: GetBuilder<RecycleController>(builder: (controller) {
              return DataTable(
                headingRowHeight: 30,
                dataRowHeight: 30,
                horizontalMargin: 0,
                columnSpacing: 0,
                columns: [
                  "number",
                  "customer_name",
                  "receipt_total",
                  "date",
                  "time",
                  "paid_amount",
                  "operation_type",
                  "uploaded",
                ]
                    .map(
                      (title) => DataColumn(
                        label: Expanded(
                          child: Container(
                            color: Colors.green,
                            child: Center(
                              child: Text(
                                title.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: filterList(
                  input: searchWord,
                  receiptsList: controller.recycledOperations.value,
                ).map(
                  (operation) {
                    final cell = [
                      operation["oper_id"],
                      operation["user_name"],
                      ValuesManager.numToString(
                          operation["oper_net_value_with_tax"]),
                      operation["oper_date"],
                      operation["oper_time"],
                      operation["cash_value"],
                      ReceiptType().get(type: operation["section_type_no"]),
                      operation["is_sender_complete_status"] == 0
                          ? "select_receipt_dialog_No".tr
                          : "select_receipt_dialog_yes".tr
                    ];
                    return DataRow(
                      onLongPress: () {
                        generalDialog(
                          context: context,
                          title: "confirm".tr,
                          message:
                              "do you really want to move this operation out of recycle pin"
                                  .tr,
                          dialogType: DialogType.QUESTION,
                          onOk: () async {
                            await controller.moveFromRecycleBin(
                              input: operation,
                              context: context,
                            );
                          },
                          onOkText: "confirm".tr,
                          onCancel: () {},
                        );
                      },
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
                            ),
                          )
                          .toList(),
                    );
                  },
                ).toList(),
              );
            }),
          ),
        ),
      ),
    );
  }

  List filterList({required String input, required List<Map> receiptsList}) {
    if (filterSectionType == 0) {
      if (input != "") {
        return receiptsList.where((element) {
          return (element["user_name"].contains(input));
        }).toList();
      } else {
        return receiptsList;
      }
    } else {
      if (input != "") {
        return receiptsList.where((element) {
          return (element["user_name"].contains(input) &&
              element["section_type_no"] == filterSectionType);
        }).toList();
      } else {
        return receiptsList
            .where((element) => element["section_type_no"] == filterSectionType)
            .toList();
      }
    }
  }
}
