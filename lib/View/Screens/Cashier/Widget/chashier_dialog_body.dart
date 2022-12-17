import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class ChashierDialogBody extends StatefulWidget {
  final CashierController cashierController;
  const ChashierDialogBody({
    Key? key,
    required this.cashierController,
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
        text: widget
            .cashierController.currentReceipt.value["oper_net_value_with_tax"]
            .toString());
    cashController.addListener(
      () {
        String value = cashController.text;
        if (value != "" && value != ".") {
          widget.cashierController.changeReceiptValue(
              input: {"cash_value": double.parse(value.toString())});
        } else {
          cashController.text = "0.0";
          cashController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: cashController.value.text.length,
          );
          widget.cashierController.changeReceiptValue(
            input: {
              "cash_value": 0.0,
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Neumorphic(
              style: const NeumorphicStyle(
                color: Colors.white,
                shape: NeumorphicShape.concave,
                shadowDarkColor: Colors.black,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          title: Text(
                            "customer".tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: Text(
                            widget.cashierController.selectedEntity!.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          dense: true,
                          title: Text(
                            "phone".tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: const Text(
                            "",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          dense: true,
                          title: Text(
                            "address".tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: const Text(
                            "",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Neumorphic(
              style: const NeumorphicStyle(
                color: Colors.white,
                shape: NeumorphicShape.concave,
                shadowDarkColor: Colors.black,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          title: Text(
                            "total".tr,
                          ),
                          trailing: Text(
                            widget.cashierController.currentReceipt
                                .value["oper_net_value_with_tax"]
                                .toString(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -3),
                            title: Text(
                              "remaining".tr,
                            ),
                            trailing: Text(
                              widget.cashierController.currentReceipt
                                  .value["reside_value"]
                                  .toString(),
                            ),
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
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
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
                                  cashController.text = widget
                                      .cashierController
                                      .currentReceipt
                                      .value["oper_net_value_with_tax"]
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                                FilteringTextInputFormatter.deny("")
                              ],
                              onTap: () {
                                cashController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      cashController.value.text.length,
                                );
                              },
                              onChanged: (value) {
                                widget.cashierController.changeReceiptValue(
                                  input: {
                                    "cash_value": ValuesManager.numberValidator(
                                        value ?? ""),
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
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          title: Text(
                            "credit_before".tr,
                          ),
                          trailing: Text(
                            widget.cashierController.currentReceipt
                                .value["credit_before"]
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
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
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
                                  masrafiController.text = widget
                                      .cashierController
                                      .currentReceipt
                                      .value["oper_net_value_with_tax"]
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                                FilteringTextInputFormatter.deny("")
                              ],
                              editingController: masrafiController,
                              hintText: "banking".tr,
                              name: "saraf_cash_value",
                              onChanged: (value) {
                                widget.cashierController.changeReceiptValue(
                                  input: {
                                    "saraf_cash_value":
                                        ValuesManager.numberValidator(
                                            value ?? ""),
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -3),
                            title: Text(
                              "credit_after".tr,
                            ),
                            trailing: Text(
                              widget.cashierController.currentReceipt
                                  .value["credit_after"]
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
