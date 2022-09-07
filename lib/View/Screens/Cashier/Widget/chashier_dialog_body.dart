import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

class ChashierDialogBody extends StatefulWidget {
  final GeneralState generalState;
  const ChashierDialogBody({
    Key? key,
    required this.generalState,
  }) : super(key: key);

  @override
  State<ChashierDialogBody> createState() => _ChashierDialogBodyState();
}

class _ChashierDialogBodyState extends State<ChashierDialogBody> {
  final TextEditingController masrafiController = TextEditingController();

  late final TextEditingController cashController;
  @override
  void initState() {
    cashController = TextEditingController(
        text: widget.generalState.currentReceipt["oper_net_value_with_tax"]
            .toString());
    cashController.addListener(() {
      String value = cashController.text;
      if (value != "" && value != ".") {
        context.read<GeneralState>().changeReceiptValue(
            input: {"cash_value": double.parse(value.toString())});
      } else {
        cashController.text = "0.0";
        cashController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: cashController.value.text.length,
        );
        context.read<GeneralState>().changeReceiptValue(
          input: {
            "cash_value": 0.0,
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      "total".tr,
                    ),
                    trailing: Text(
                      widget.generalState
                          .currentReceipt["oper_net_value_with_tax"]
                          .toString(),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<GeneralState>(builder: (
                    context,
                    state,
                    widget,
                  ) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        "remaining".tr,
                      ),
                      trailing: Text(
                        state.currentReceipt["reside_value"].toString(),
                      ),
                    );
                  }),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "cash".tr,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            masrafiController.text = "0.0";
                            cashController.text = widget.generalState
                                .currentReceipt["oper_net_value_with_tax"]
                                .toString();
                          },
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: screenWidth(context) * 0.2,
                      child: CustomTextField(
                        editingController: cashController,
                        activated: true,
                        isDense: true,
                        hintText: "cash".tr,
                        inputType: TextInputType.number,
                        onTap: () {
                          cashController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: cashController.value.text.length,
                          );
                        },
                        onChanged: (value) {
                          context.read<GeneralState>().changeReceiptValue(
                            input: {
                              "cash_value":
                                  ValuesManager.numberValidator(value ?? ""),
                            },
                          );
                        },
                        name: "cash_value",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      "credit_before".tr,
                    ),
                    trailing: Text(
                      widget.generalState.currentReceipt["credit_before"]
                          .toString(),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "banking".tr,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cashController.text = "0.0";
                            masrafiController.text = widget.generalState
                                .currentReceipt["oper_net_value_with_tax"]
                                .toString();
                          },
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: screenWidth(context) * 0.2,
                      child: CustomTextField(
                        isDense: true,
                        activated: true,
                        inputType: TextInputType.number,
                        editingController: masrafiController,
                        hintText: "banking".tr,
                        name: "saraf_cash_value",
                        onChanged: (value) {
                          widget.generalState.changeReceiptValue(
                            input: {
                              "saraf_cash_value":
                                  ValuesManager.numberValidator(value ?? ""),
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<GeneralState>(builder: (
                    context,
                    state,
                    widget,
                  ) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        "credit_after".tr,
                      ),
                      trailing: Text(
                        state.currentReceipt["credit_after"].toString(),
                      ),
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
