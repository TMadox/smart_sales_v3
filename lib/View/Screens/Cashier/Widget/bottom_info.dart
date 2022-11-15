import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class BottomInfo extends StatefulWidget {
  final double width;
  final double height;
  final GeneralState generalState;
  const BottomInfo({
    Key? key,
    required this.width,
    required this.height,
    required this.generalState,
  }) : super(key: key);

  @override
  State<BottomInfo> createState() => _BottomInfoState();
}

class _BottomInfoState extends State<BottomInfo> {
  final TextEditingController discountController =
      TextEditingController(text: 0.0.toString());
  final TextEditingController taxController =
      TextEditingController(text: 0.0.toString());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashierController>(
      builder: (state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: widget.width * 0.05,
              headingRowHeight: widget.height * 0.07,
              horizontalMargin: widget.width * 0.03,
              dataRowHeight: widget.height * 0.07,
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
                      SizedBox(
                        width: widget.width * 0.14,
                        child: Center(
                          child: Text(
                            ValuesManager.doubleToString(widget
                                    .generalState.currentReceipt['oper_value'])
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: widget.width * 0.14,
                        child: Center(
                          child: TextFormField(
                            controller: discountController,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                              FilteringTextInputFormatter.deny("")
                            ],
                            onTap: () {
                              discountController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      discountController.value.text.length);
                            },
                            onChanged: (value) {
                              log(value);
                              final currentValue = widget.generalState
                                  .currentReceipt["oper_disc_value"];
                              try {
                                if (value != "" && value != ".") {
                                  widget.generalState.changeReceiptValue(
                                      input: {
                                        "oper_disc_value": double.parse(value)
                                      });
                                } else {
                                  discountController.text = "0.0";
                                  discountController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          discountController.value.text.length);
                                  widget.generalState.changeReceiptValue(
                                      input: {
                                        "oper_disc_value": double.parse("0")
                                      });
                                }
                              } catch (e) {
                                discountController.text =
                                    ValuesManager.doubleToString(currentValue);
                                widget.generalState.changeReceiptValue(
                                    input: {"oper_disc_value": currentValue});
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
                    ),
                    DataCell(
                      SizedBox(
                        width: widget.width * 0.14,
                        child: Center(
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
                                  extentOffset:
                                      taxController.value.text.length);
                            },
                            onChanged: (value) {
                              log(value);
                              final currentValue = widget.generalState
                                  .currentReceipt["oper_add_value"];
                              try {
                                if (value != "" && value != ".") {
                                  widget.generalState.changeReceiptValue(
                                      input: {
                                        "oper_add_value": double.parse(value)
                                      });
                                } else {
                                  taxController.text = "0.0";
                                  taxController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          taxController.value.text.length);
                                  widget.generalState.changeReceiptValue(
                                      input: {"oper_add_value": 0.0});
                                }
                              } catch (e) {
                                taxController.text = currentValue.toString();
                                widget.generalState.changeReceiptValue(
                                    input: {"oper_add_value": currentValue});
                                showErrorDialog(
                                    context: context,
                                    description:
                                        'ليس لديك صلاحيات لتقليل السعر الي اقل من الحد الادني',
                                    title: "error".tr);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: widget.width * 0.14,
                        child: Text(
                          ValuesManager.doubleToString(
                              widget.generalState.currentReceipt['tax_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: widget.width * 0.14,
                        child: Text(
                          ValuesManager.doubleToString(widget.generalState
                              .currentReceipt['oper_net_value_with_tax']),
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
          ),
        );
      },
    );
  }
}
