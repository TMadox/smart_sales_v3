import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/bottom_info.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/details_table.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/search_bar.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_viewmodel.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/alert_snackbar.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/cashier_save_dialog.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';

class CashierView extends StatefulWidget {
  final ClientModel customer;
  const CashierView({Key? key, required this.customer}) : super(key: key);

  @override
  State<CashierView> createState() => _CashierViewState();
}

class _CashierViewState extends State<CashierView> {
  final CashierViewmodel _cashierViewmodel = CashierViewmodel();

  KindsModel? selectedModel;
  Map data = {};
  String searchWord = "";
  final SharedPreferences storage = locator.get<SharedStorage>().prefs;
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.customer.amName,
      "credit_before": widget.customer.curBalance ?? 0.0,
      "cst_tax": widget.customer.taxFileNo ?? ".....",
      "employ_id": widget.customer.employAccId,
      "basic_acc_id": widget.customer.accId,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generalState = context.read<GeneralState>();
    final double width = screenWidth(context);
    final double height = screenHeight(context);
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              if (generalState.receiptItems.isNotEmpty) {
                warningDialog(
                  context: context,
                  warningText: 'receipt_still_inprogress'.tr,
                  btnCancelText: 'exit'.tr,
                  btnOkText: 'stay'.tr,
                  onCancel: () {
                    if ((locator
                            .get<SharedStorage>()
                            .prefs
                            .getBool("request_visit") ??
                        true)) {
                      exitDialog(
                        context: context,
                        data: data,
                      );
                      return false;
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
                return false;
              } else {
                if ((locator
                        .get<SharedStorage>()
                        .prefs
                        .getBool("request_visit") ??
                    true)) {
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
                            List<ItemsModel> filteredItems =
                                _cashierViewmodel.filterItems(
                                    input: context.read<ItemsViewmodel>().items,
                                    kindsModel: selectedModel,
                                    searchWord: searchWord);
                            return Expanded(
                              child: Column(
                                children: [
                                  SearchBar(
                                    data: data,
                                    onChanged: (value) {
                                      state(() {
                                        searchWord = value ?? "";
                                      });
                                    },
                                    generalState: generalState,
                                    storage: storage,
                                    onTap: () async {
                                      await storage.setBool(
                                        "show_cashier_details",
                                        !(storage.getBool(
                                                'show_cashier_details') ??
                                            true),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: ListView.builder(
                                              itemCount: context
                                                  .read<KindsState>()
                                                  .kinds
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final KindsModel kindsModel =
                                                    context
                                                        .read<KindsState>()
                                                        .kinds[index];
                                                return InkWell(
                                                  onTap: () {
                                                    state(() {
                                                      selectedModel =
                                                          kindsModel;
                                                    });
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      side: BorderSide(
                                                        color: kindsModel ==
                                                                selectedModel
                                                            ? Colors.green
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: screenWidth(
                                                                  context) *
                                                              0.05),
                                                      child: Center(
                                                        child: AutoSizeText(
                                                          kindsModel.kindName,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenHeight(context) * 0.01,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3),
                                              itemCount: filteredItems.length,
                                              itemBuilder: (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                final ItemsModel item =
                                                    filteredItems[index];
                                                return InkWell(
                                                  onTap: () {
                                                    _cashierViewmodel
                                                        .addOrIncrementItem(
                                                      context: context,
                                                      item: item,
                                                      generalState:
                                                          generalState,
                                                    );
                                                    state(
                                                      () {},
                                                    );
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      side: BorderSide(
                                                        color: context
                                                                .read<
                                                                    GeneralState>()
                                                                .receiptItems
                                                                .where((element) =>
                                                                    element[
                                                                        "unit_id"] ==
                                                                    item.unitId)
                                                                .isNotEmpty
                                                            ? Colors.green
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        item.itemName
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
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
                                            cashierSaveDialog(
                                              context: context,
                                              body: ListTile(
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
                                                                generalState
                                                                    .currentReceipt[
                                                                        "oper_net_value_with_tax"]
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Consumer<
                                                                    GeneralState>(
                                                                builder: (
                                                              context,
                                                              state,
                                                              widget,
                                                            ) {
                                                              return ListTile(
                                                                dense: true,
                                                                title: Text(
                                                                  "remaining"
                                                                      .tr,
                                                                ),
                                                                trailing: Text(
                                                                  state
                                                                      .currentReceipt[
                                                                          "reside_value"]
                                                                      .toString(),
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
                                                              title: Text(
                                                                "cash".tr,
                                                              ),
                                                              trailing:
                                                                  SizedBox(
                                                                width: screenWidth(
                                                                        context) *
                                                                    0.2,
                                                                child:
                                                                    CustomTextField(
                                                                  activated:
                                                                      true,
                                                                  isDense: true,
                                                                  hintText:
                                                                      "cash".tr,
                                                                  inputType:
                                                                      TextInputType
                                                                          .number,
                                                                  initialValue: context
                                                                      .read<
                                                                          GeneralState>()
                                                                      .currentReceipt[
                                                                          "oper_net_value_with_tax"]
                                                                      .toString(),
                                                                  onChanged:
                                                                      (value) {
                                                                    context
                                                                        .read<
                                                                            GeneralState>()
                                                                        .changeReceiptValue(
                                                                      input: {
                                                                        "cash_value":
                                                                            ValuesManager.numberValidator(value ??
                                                                                ""),
                                                                      },
                                                                    );
                                                                  },
                                                                  name: "cash",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: ListTile(
                                                              dense: true,
                                                              title: const Text(
                                                                "الرصيد قبل",
                                                              ),
                                                              trailing: Text(
                                                                generalState
                                                                    .currentReceipt[
                                                                        "credit_before"]
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
                                                              title: Text(
                                                                "مصرفي".tr,
                                                              ),
                                                              trailing:
                                                                  SizedBox(
                                                                width: screenWidth(
                                                                        context) *
                                                                    0.15,
                                                                child:
                                                                    CustomTextField(
                                                                  isDense: true,
                                                                  hintText:
                                                                      "مصرفي"
                                                                          .tr,
                                                                  name: "cash",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Consumer<
                                                                    GeneralState>(
                                                                builder: (
                                                              context,
                                                              state,
                                                              widget,
                                                            ) {
                                                              return ListTile(
                                                                dense: true,
                                                                title: Text(
                                                                  "credit_after"
                                                                      .tr,
                                                                ),
                                                                trailing: Text(
                                                                  state
                                                                      .currentReceipt[
                                                                          "credit_after"]
                                                                      .toString(),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onSave: () async {
                                                Navigator.pop(context);
                                                ProgressHUD.of(context)!.show();
                                                await _cashierViewmodel
                                                    .onFinishOperation(
                                                  context: context,
                                                  doShare: false,
                                                );
                                                ProgressHUD.of(context)!
                                                    .dismiss();
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        Routes.homeRoute,
                                                        (route) => false);
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                              onPrint: () async {
                                                Navigator.pop(context);
                                                ProgressHUD.of(context)!.show();
                                                await _cashierViewmodel
                                                    .onFinishOperation(
                                                  context: context,
                                                  doPrint: true,
                                                );
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                  Routes.homeRoute,
                                                  (route) => false,
                                                );
                                              },
                                              onShare: () async {
                                                Navigator.pop(context);
                                                ProgressHUD.of(context)!.show();
                                                await _cashierViewmodel
                                                    .onFinishOperation(
                                                  context: context,
                                                  doShare: true,
                                                  doPrint: true,
                                                );
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
                                      (storage.getBool(
                                                      "show_cashier_details") ??
                                                  true) ==
                                              false
                                          ? Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: BottomInfo(
                                                      width:
                                                          screenWidth(context),
                                                      height:
                                                          screenHeight(context),
                                                      generalState:
                                                          generalState),
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenHeight(context) *
                                                          0.01,
                                                  vertical:
                                                      screenWidth(context) *
                                                          0.01,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green),
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
                          visible:
                              storage.getBool("show_cashier_details") ?? true,
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
        },
      ),
    );
  }
}
