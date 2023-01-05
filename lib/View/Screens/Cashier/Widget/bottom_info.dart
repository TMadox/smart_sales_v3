import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class BottomInfo extends StatefulWidget {
  final CashierController controller;

  const BottomInfo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<BottomInfo> createState() => _BottomInfoState();
}

class _BottomInfoState extends State<BottomInfo> {
  final TextEditingController discountController =
      TextEditingController(text: "0.0");
  final TextEditingController taxController =
      TextEditingController(text: "0.0");
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          child: DataTable(
            columnSpacing: 10,
            headingRowHeight: 30,
            dataRowHeight: 30,
            border: TableBorder.all(
              width: 0.5,
              style: BorderStyle.none,
              borderRadius: BorderRadius.circular(15),
            ),
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return smaltBlue;
            }),
            columns: [
              "receipt_value".tr,
              "discount".tr,
              "addition".tr,
              "tax".tr,
              "receipt_total".tr,
            ]
                .map(
                  (e) => DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          e,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Center(
                      child: Text(
                        ValuesManager.numToString(widget
                                .controller.currentReceipt.value['oper_value'])
                            .toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: TextFormField(
                        controller: discountController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                          FilteringTextInputFormatter.deny("")
                        ],
                        onTap: () {
                          discountController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  discountController.value.text.length);
                        },
                        onChanged: (value) {
                          final currentValue = widget.controller.currentReceipt
                              .value["oper_disc_value"];
                          try {
                            if (value != "" && value != ".") {
                              widget.controller.changeReceiptValue(
                                input: {"oper_disc_value": double.parse(value)},
                              );
                            } else {
                              discountController.text = "0.0";
                              discountController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      discountController.value.text.length);
                              widget.controller.changeReceiptValue(
                                input: {
                                  "oper_disc_value": double.parse("0"),
                                },
                              );
                            }
                          } catch (e) {
                            discountController.text =
                                ValuesManager.numToString(currentValue);
                            widget.controller.changeReceiptValue(
                              input: {
                                "oper_disc_value": currentValue,
                              },
                            );
                            showErrorDialog(
                              context: context,
                              description: 'price_less_than_least'.tr,
                              title: 'error'.tr,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: TextFormField(
                        controller: taxController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                          FilteringTextInputFormatter.deny("")
                        ],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(),
                        onTap: () {
                          taxController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: taxController.value.text.length);
                        },
                        onChanged: (value) {
                          final currentValue = widget.controller.currentReceipt
                              .value["oper_add_value"];
                          try {
                            if (value != "" && value != ".") {
                              widget.controller.changeReceiptValue(input: {
                                "oper_add_value": double.parse(value)
                              });
                            } else {
                              taxController.text = "0.0";
                              taxController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: taxController.value.text.length,
                              );
                              widget.controller.changeReceiptValue(
                                input: {
                                  "oper_add_value": 0.0,
                                },
                              );
                            }
                          } catch (e) {
                            taxController.text = currentValue.toString();
                            widget.controller.changeReceiptValue(
                              input: {
                                "oper_add_value": currentValue,
                              },
                            );
                            showErrorDialog(
                              context: context,
                              description:
                                  'ليس لديك صلاحيات لتقليل السعر الي اقل من الحد الادني',
                              title: "error".tr,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        ValuesManager.numToString(widget
                            .controller.currentReceipt.value['tax_value']),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        ValuesManager.numToString(widget.controller
                            .currentReceipt.value['oper_net_value_with_tax']),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
