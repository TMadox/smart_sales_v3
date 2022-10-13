import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/bottom_info.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/chashier_dialog_body.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/details_table.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/groups_column.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/offers_column.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/products_box.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/search_bar.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/types_column.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/cashier_save_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';

class CashierView extends StatefulWidget {
  final ClientsModel client;
  const CashierView({Key? key, required this.client}) : super(key: key);

  @override
  State<CashierView> createState() => _CashierViewState();
}

class _CashierViewState extends State<CashierView> {
  final CashierController cashierController = Get.find<CashierController>();
  KindsModel? selectedModel;
  Map data = {};
  final SharedPreferences storage = locator.get<SharedStorage>().prefs;
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.client.amName,
      "credit_before": widget.client.curBalance ?? 0.0,
      "cst_tax": widget.client.taxFileNo ?? ".....",
      "employ_id": widget.client.employAccId,
      "basic_acc_id": widget.client.accId,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generalState = context.read<GeneralState>();
    final double height = screenHeight(context);
    return WillPopScope(
      onWillPop: () async {
        if (generalState.receiptItems.isNotEmpty) {
          generalDialog(
            context: context,
            message: 'receipt_still_inprogress'.tr,
            onCancelIcon: const Icon(Icons.exit_to_app),
            onCancelText: 'exit'.tr,
            onOkText: 'stay'.tr,
            onCancel: () {
              if ((locator
                      .get<SharedStorage>()
                      .prefs
                      .getBool("request_visit") ??
                  false)) {
                exitDialog(
                  context: context,
                  data: data,
                );
                return false;
              } else {
                Get.back();
              }
            },
            title: 'warning'.tr,
          );
          return false;
        } else {
          if ((locator.get<SharedStorage>().prefs.getBool("request_visit") ??
              false)) {
            exitDialog(
              context: context,
              data: data,
            );
            return false;
          } else {
            return true;
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  StatefulBuilder(
                    builder: (context, state) {
                      return Expanded(
                        child: Column(
                          children: [
                            SearchBar(
                              data: data,
                              onChanged: (value) {
                                cashierController.setSearchWord(value ?? "");
                              },
                              generalState: generalState,
                              storage: storage,
                              onTap: () async {
                                await storage.setBool(
                                  "show_cashier_details",
                                  !(storage.getBool('show_cashier_details') ??
                                      true),
                                );
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Obx(
                                () {
                                  cashierController.selectedKindId.value;
                                  return Row(
                                    children: [
                                      if (!(storage.getBool(
                                              "show_cashier_details") ??
                                          true))
                                        Expanded(
                                          child: GroupsColumn(
                                            cashierController:
                                                cashierController,
                                          ),
                                        ),
                                      SizedBox(
                                        width: screenWidth(context) * 0.005,
                                      ),
                                      Expanded(
                                        child: TypesColumn(
                                          cashierController: cashierController,
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth(context) * 0.005,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: ProductsBox(
                                          cashierController: cashierController,
                                        ),
                                      ),
                                      if (!(storage.getBool(
                                              "show_cashier_details") ??
                                          true)) ...[
                                        SizedBox(
                                          width: screenWidth(context) * 0.005,
                                        ),
                                        Expanded(
                                          child: OffersColumn(
                                            cashierController:
                                                cashierController,
                                          ),
                                        )
                                      ]
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.01,
                            ),
                            Row(
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    if (context
                                        .read<GeneralState>()
                                        .receiptItems
                                        .isEmpty) {
                                      showAlertSnackbar(
                                        context: context,
                                        text: "no_items".tr,
                                      );
                                    } else {
                                      generalState.changeReceiptValue(
                                        input: {
                                          "cash_value":
                                              generalState.currentReceipt[
                                                  "oper_net_value_with_tax"],
                                        },
                                      );
                                      generalState.changeReceiptValue(
                                        input: {
                                          "saraf_cash_value": 0.0,
                                        },
                                      );
                                      cashierSaveDialog(
                                        context: context,
                                        body: ChashierDialogBody(
                                          generalState: generalState,
                                        ),
                                        onSave: () async {
                                          Get.back();
                                          EasyLoading.show();
                                          await cashierController
                                              .onFinishOperation(
                                            context: context,
                                            doShare: false,
                                          );
                                          EasyLoading.dismiss();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            Routes.homeRoute,
                                            (route) => false,
                                          );
                                        },
                                        onCancel: () {
                                          Get.back();
                                        },
                                        onPrint: () async {
                                          Get.back();
                                          EasyLoading.show();
                                          await cashierController
                                              .onFinishOperation(
                                            context: context,
                                            doPrint: true,
                                          );
                                          EasyLoading.dismiss();

                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            Routes.homeRoute,
                                            (route) => false,
                                          );
                                        },
                                        onShare: () async {
                                          Get.back();
                                          EasyLoading.show();
                                          await cashierController
                                              .onFinishOperation(
                                            context: context,
                                            doShare: true,
                                            doPrint: true,
                                          );
                                          EasyLoading.dismiss();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            Routes.homeRoute,
                                            (route) => false,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.save),
                                  backgroundColor: Colors.green,
                                  mini: true,
                                ),
                                (storage.getBool("show_cashier_details") ??
                                            true) ==
                                        false
                                    ? Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: BottomInfo(
                                                width: screenWidth(context),
                                                height: screenHeight(context),
                                                generalState: generalState),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                screenHeight(context) * 0.01,
                                            vertical:
                                                screenWidth(context) * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            "Description: this is a test description",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                  SizedBox(
                    width: screenWidth(context) * 0.01,
                  ),
                  Visibility(
                    visible: storage.getBool("show_cashier_details") ?? true,
                    child: Expanded(
                      child: Consumer<GeneralState>(
                        builder: (context, generalState, child) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: DetailsTable(
                                      generalState: generalState,
                                      height: height,
                                      width: constraints.maxWidth,
                                    ),
                                  ),
                                  BottomInfo(
                                    width: constraints.maxWidth,
                                    height: height,
                                    generalState: generalState,
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
