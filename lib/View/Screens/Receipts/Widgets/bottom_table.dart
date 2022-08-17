import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class BottomTable extends StatefulWidget {
  final ClientModel customer;
  final double height;
  final double width;
  final List<TextEditingController> controllers;

  const BottomTable({
    Key? key,
    required this.customer,
    required this.height,
    required this.width,
    required this.controllers,
  }) : super(key: key);

  @override
  _BottomTableState createState() => _BottomTableState();
}

class _BottomTableState extends State<BottomTable> {
  @override
  Widget build(BuildContext context) {
    double height = widget.height;
    double width = widget.width;
    List<TextEditingController> controllers = widget.controllers;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<GeneralState>(
        builder: (context, state, w) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return smaltBlue;
              }),
              headingRowHeight: height * 0.06,
              dataRowHeight: height * 0.1,
              columnSpacing: 5,
              columns: [
                "previous_credit".tr,
                "receipt_value".tr,
                "discount".tr,
                "addition".tr,
                "tax".tr,
                "receipt_total".tr,
                "cash".tr,
                "remaining".tr,
                "current_credit".tr,
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
                      Container(
                        width: width * 0.1,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.customer.curBalance.toString(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Center(
                          child: Text(
                            ValuesManager.doubleToString(
                                    state.currentReceipt['oper_value'])
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Center(
                          child: CustomTextField(
                            activated: true,
                            errorFontSize: 0,
                            editingController: controllers[0],
                            name: "disc_value",
                            textAlign: TextAlign.center,
                            inputType: TextInputType.number,
                            validationMode: AutovalidateMode.onUserInteraction,
                            validators: FormBuilderValidators.numeric(
                              context,
                              errorText: "",
                            ),
                            onChanged: (value) {
                              final currentValue = context
                                  .read<GeneralState>()
                                  .currentReceipt["oper_disc_value"];
                              try {
                                if (value != "" && value != ".") {
                                  context
                                      .read<GeneralState>()
                                      .changeReceiptValue(input: {
                                    "oper_disc_value":
                                        double.parse(value ?? "0.0")
                                  });
                                } else {
                                  controllers[0].text = "0.0";
                                  controllers[0].selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          controllers[0].value.text.length);
                                  context
                                      .read<GeneralState>()
                                      .changeReceiptValue(input: {
                                    "oper_disc_value": double.parse("0")
                                  });
                                }
                              } catch (e) {
                                controllers[0].text =
                                    ValuesManager.doubleToString(currentValue);

                                context.read<GeneralState>().changeReceiptValue(
                                    input: {"oper_disc_value": currentValue});
                                showErrorDialog(
                                  context: context,
                                  description: 'price_less_than_least'.tr,
                                  title: 'error'.tr,
                                );
                              }
                            },
                            onTap: () {
                              controllers[0].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controllers[0].text.length,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Center(
                            child: CustomTextField(
                          activated: true,
                          errorFontSize: 0,
                          editingController: controllers[1],
                          name: "add_value",
                          textAlign: TextAlign.center,
                          inputType: TextInputType.number,
                          validationMode: AutovalidateMode.onUserInteraction,
                          validators: FormBuilderValidators.numeric(
                            context,
                            errorText: "",
                          ),
                          onChanged: (value) {
                            final currentValue = context
                                .read<GeneralState>()
                                .currentReceipt["oper_add_value"];
                            try {
                              if (value != "" && value != ".") {
                                context.read<GeneralState>().changeReceiptValue(
                                    input: {
                                      "oper_add_value":
                                          double.parse(value.toString())
                                    });
                              } else {
                                controllers[1].text = "0.0";
                                controllers[1].selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        controllers[1].value.text.length);
                                context.read<GeneralState>().changeReceiptValue(
                                  input: {
                                    "oper_add_value": 0.0,
                                  },
                                );
                              }
                            } catch (e) {
                              controllers[1].text = currentValue.toString();
                              context.read<GeneralState>().changeReceiptValue(
                                input: {
                                  "oper_add_value": currentValue,
                                },
                              );
                              showErrorDialog(
                                  context: context,
                                  description:
                                      'ليس لديك صلاحيات لتقليل السعر الي اقل من الحد الادني',
                                  title: "error".tr);
                            }
                          },
                          onTap: () {
                            controllers[1].selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: controllers[1].text.length,
                            );
                          },
                        )),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Text(
                          ValuesManager.doubleToString(
                              state.currentReceipt['tax_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ValuesManager.doubleToString(
                              state.currentReceipt['oper_net_value_with_tax']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Center(
                            child: CustomTextField(
                          activated: true,
                          errorFontSize: 0,
                          editingController: controllers[3],
                          name: "cash_value",
                          textAlign: TextAlign.center,
                          inputType: TextInputType.number,
                          validationMode: AutovalidateMode.onUserInteraction,
                          validators: FormBuilderValidators.numeric(
                            context,
                            errorText: "",
                          ),
                          onTap: () {
                            controllers[3].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: controllers[3].value.text.length);
                          },
                          onChanged: (value) {
                            final currentValue = context
                                .read<GeneralState>()
                                .currentReceipt["cash_value"];
                            try {
                              if (value != "" && value != ".") {
                                context
                                    .read<GeneralState>()
                                    .changeReceiptValue(input: {
                                  "cash_value": double.parse(value.toString())
                                });
                              } else {
                                controllers[3].text = "0.0";
                                controllers[3].selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        controllers[3].value.text.length);
                                context.read<GeneralState>().changeReceiptValue(
                                  input: {
                                    "cash_value": 0.0,
                                  },
                                );
                              }
                            } catch (e) {
                              controllers[3].text = currentValue.toString();
                              context.read<GeneralState>().changeReceiptValue(
                                input: {
                                  "cash_value": currentValue,
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
                        )
                            //  CustomTextField(
                            //     controller: controllers[3],
                            //     keyboardType: TextInputType.number,
                            //     decoration: InputDecoration(
                            //         contentPadding:
                            //             EdgeInsets.only(bottom: height * 0.03)),
                            //     textAlign: TextAlign.center,
                            //     style: GoogleFonts.cairo(),
                            // onTap: () {
                            //   controllers[3].selection = TextSelection(
                            //       baseOffset: 0,
                            //       extentOffset:
                            //           controllers[3].value.text.length);
                            // },
                            //     onChanged: (value) {
                            //       if (value != "" && value != ".") {
                            //         context.read<GeneralState>().changeReceiptValue(
                            //           input: {
                            //             "cash_value": double.parse(value),
                            //           },
                            //         );
                            //       } else {
                            //         controllers[3].text = "0.0";
                            //         controllers[3].selection = TextSelection(
                            //           baseOffset: 0,
                            //           extentOffset:
                            //               controllers[3].value.text.length,
                            //         );
                            //         context.read<GeneralState>().changeReceiptValue(
                            //           input: {"cash_value": 0.0},
                            //         );
                            //       }
                            //     },
                            //   ),
                            ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: width * 0.1,
                        child: Text(
                          ValuesManager.doubleToString(
                              state.currentReceipt['reside_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: width * 0.1,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          creditAfter(
                              context: context,
                              reside: state.currentReceipt['reside_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
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
      ),
    );
  }

  creditAfter({required BuildContext context, required double? reside}) {
    if (context.read<GeneralState>().currentReceipt["section_type_no"] == 1) {
      return ((widget.customer.curBalance ?? 0.0) + (reside ?? 0.0))
          .toStringAsFixed(3);
    } else {
      return ((widget.customer.curBalance ?? 0.0) - (reside ?? 0.0))
          .toStringAsFixed(3);
    }
  }
}
