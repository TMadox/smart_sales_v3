import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

void showSelectReceiptsDialog({
  required BuildContext context,
}) {
  showAnimatedDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return const Receipts();
    },
  );
}

class Receipts extends StatefulWidget {
  const Receipts({Key? key}) : super(key: key);

  @override
  State<Receipts> createState() => _GeneralState();
}

class _GeneralState extends State<Receipts> {
  String searchWord = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Row(
          children: [
            const BackButton(
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: CustomTextField(
                  name: "search",
                  onChanged: (p0) {
                    setState(() {
                      searchWord = p0!;
                    });
                  },
                  activated: true,
                  hintText: 'search'.tr,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return Center(
            child: SizedBox(
              width: width * 0.98,
              height: height * 0.95,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            return Colors.green;
                          }),
                          dividerThickness: 1,
                          headingRowHeight: height * 0.09,
                          dataRowHeight: height * 0.1,
                          horizontalMargin: width * 0.025,
                          border: TableBorder.all(
                              width: 0.5,
                              style: BorderStyle.none,
                              borderRadius: BorderRadius.circular(15)),
                          columns: [
                            "number".tr,
                            "customer_name".tr,
                            "receipt_total".tr,
                            "date".tr,
                            "time".tr,
                            "paid_amount".tr,
                            "operation_type".tr,
                            "uploaded".tr
                          ]
                              .map(
                                (e) => DataColumn(
                                  label: Text(
                                    e,
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          rows: filterList(context: context, input: searchWord)
                              .map((Map receipt) {
                            final cell = [
                              receipt["oper_id"],
                              receipt["user_name"],
                              receipt["oper_net_value_with_tax"],
                              receipt["created_date"],
                              receipt["oper_time"],
                              receipt["cash_value"],
                              receiptType(type: receipt["section_type_no"]),
                              receipt["is_sender_complete_status"] == 0
                                  ? "select_receipt_dialog_No".tr
                                  : "select_receipt_dialog_yes".tr,
                            ];
                            return DataRow(
                                cells: cell
                                    .map((e) => DataCell(
                                          Text(
                                            e.toString(),
                                          ),
                                          onTap: () {
                                            showAnimatedDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "warning".tr,
                                                    ),
                                                    content: Text(
                                                        "select_receipt_dialog_data_row_text"
                                                            .tr),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    GeneralState>()
                                                                .fillReceiptWithItems(
                                                                    input: List<
                                                                            Map>.from(
                                                                        json.decode(
                                                                            receipt["products"])));
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              primary:
                                                                  Colors.blue,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10))),
                                                          child: const Text(
                                                              "تاكيد")),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "cancel".tr,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ))
                                    .toList());
                          }).toList(),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map> filterList({required String input, required BuildContext context}) {
    final List<Map> defaultList = context
        .read<GeneralState>()
        .receiptsList
        .where((element) => (element["section_type_no"] == 1 ||
            element["section_type_no"] == 2 ||
            element["section_type_no"] == 17 ||
            element["section_type_no"] == 18))
        .toList();
    if (input != "") {
      return defaultList.where((element) {
        return (element["user_name"].contains(input));
      }).toList();
    } else {
      return defaultList;
    }
  }
}

String receiptType({required int type}) {
  switch (type) {
    case 9999:
      return "visit".tr;
    case 0:
      return "total".tr;
    case 1:
      return "sales".tr;
    case 2:
      return "return".tr;
    case 101:
      return "seizure_document".tr;
    case 17:
      return "selling_order".tr;
    case 18:
      return "purchase_order".tr;
    case 102:
      return "payment_document".tr;
    default:
      return "sales".tr;
  }
}
