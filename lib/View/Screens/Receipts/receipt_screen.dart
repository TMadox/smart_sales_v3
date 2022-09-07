import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/bottom_table.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/receipt_items_table.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/warning_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class ReceiptScreen extends StatefulWidget {
  final ClientsModel customer;
  const ReceiptScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final List<TextEditingController> controllers =
      List.generate(4, (i) => TextEditingController(text: 0.0.toString()));
  TextEditingController searchController = TextEditingController();
  late Map data = {};
  final storage = locator.get<SharedStorage>().prefs;
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
    double width = screenWidth(context);
    double height = screenHeight(context);
    final generalState = context.read<GeneralState>();
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
                Get.back();
              }
            },
          );
          return false;
        } else {
          if ((storage.getBool("request_visit") ?? true)) {
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
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: width * 0.98,
                child: ListView(
                  primary: true,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: whiteHaze,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: height * 0.09,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      widget.customer.amName.toString(),
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (generalState.currentReceipt[
                                                  "section_type_no"] ==
                                              3 ||
                                          generalState.currentReceipt[
                                                  "section_type_no"] ==
                                              4) {
                                        Get.to(
                                          () => const MowView(
                                            canTap: true,
                                            sectionTypeNo: 3,
                                            canPushReplace: true,
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).pushNamed(
                                          "clients",
                                          arguments: ClientsScreen(
                                            canPushReplace: true,
                                            sectionType:
                                                generalState.currentReceipt[
                                                    "section_type_no"],
                                            canTap: true,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.search,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: height * 0.09,
                              decoration: const BoxDecoration(
                                color: smaltBlue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    15,
                                  ),
                                  topRight: Radius.circular(
                                    15,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: "date".tr + " ",
                                        style:
                                            GoogleFonts.cairo(color: atlantis),
                                      ),
                                      TextSpan(
                                        text: ": " +
                                            CurrentDate.getCurrentDate()
                                                .toString(),
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                        ),
                                      )
                                    ]),
                                  ),
                                  AutoSizeText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "time".tr + " ",
                                          style: GoogleFonts.cairo(
                                            color: atlantis,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": " +
                                              CurrentDate.getCurrentTime()
                                                  .toString(),
                                          style: GoogleFonts.cairo(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  AutoSizeText(
                                    context
                                            .read<ReceiptViewmodel>()
                                            .operationName(
                                              generalState.currentReceipt[
                                                      "section_type_no"] ??
                                                  0,
                                            ) +
                                        " " +
                                        "number".tr +
                                        ":" +
                                        generalState.currentReceipt["oper_id"]
                                            .toString(),
                                    style: GoogleFonts.cairo(
                                      color: atlantis,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      setState(
                                        () {
                                          if (generalState.currentReceipt[
                                                  "cash_value"] ==
                                              generalState.currentReceipt[
                                                  "oper_net_value_with_tax"]) {
                                            generalState.changeReceiptValue(
                                                input: {"cash_value": 0.0});
                                            controllers[3].text =
                                                0.0.toString();
                                          } else {
                                            generalState
                                                .changeReceiptValue(input: {
                                              "cash_value":
                                                  generalState.currentReceipt[
                                                      "oper_net_value_with_tax"]
                                            });
                                            controllers[3].text = generalState
                                                .currentReceipt[
                                                    "oper_net_value_with_tax"]
                                                .toString();
                                          }
                                        },
                                      );
                                    },
                                    child: Text(
                                      generalState.currentReceipt[
                                                  "cash_value"] ==
                                              generalState.currentReceipt[
                                                  "oper_net_value_with_tax"]
                                          ? "cash".tr
                                          : "instant".tr,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.01,
                        vertical: height * 0.008,
                      ),
                      height: height * 0.09,
                      decoration: const BoxDecoration(
                        color: smaltBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              inputType: TextInputType.number,
                              onSubmitted: (value) {
                                try {
                                  ItemsModel item = context
                                      .read<ItemsViewmodel>()
                                      .items
                                      .firstWhere(
                                        (element) =>
                                            element.unitBarcode ==
                                            value.toString(),
                                      );
                                  context.read<ReceiptViewmodel>().addNewItem(
                                        context: context,
                                        item: item,
                                      );
                                  searchController.clear();
                                } catch (e) {
                                  searchController.clear();
                                  if (e == 420) {
                                    generalState.removeLastItem();
                                    showErrorDialog(
                                      context: context,
                                      description:
                                          'price_less_than_selling_price'.tr,
                                      title: 'error'.tr,
                                    );
                                  } else {
                                    showErrorDialog(
                                      context: context,
                                      description: 'bad_barcode'.tr,
                                      title: 'error'.tr,
                                    );
                                  }
                                }
                              },
                              fillColor: Colors.white,
                              activated: true,
                              hintText: "search_barcode".tr,
                              editingController: searchController,
                              name: 'search',
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Selector<GeneralState, dynamic>(
                                builder: (context, state, widget) {
                                  return AutoSizeText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "total_quantity".tr,
                                          style: GoogleFonts.cairo(
                                            color: atlantis,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ",
                                          style: GoogleFonts.cairo(
                                            color: atlantis,
                                          ),
                                        ),
                                        TextSpan(
                                          text: state.toString(),
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                selector: (context, state) =>
                                    state.currentReceipt["items_count"],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Consumer<GeneralState>(
                              builder: (context, state, widget) {
                                double quantity = 0;
                                for (var element in state.receiptItems) {
                                  num temp = element["free_qty"];
                                  quantity += temp;
                                }
                                return AutoSizeText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "total_free_qty".tr,
                                        style:
                                            GoogleFonts.cairo(color: atlantis),
                                      ),
                                      TextSpan(
                                        text: ": " + quantity.toString(),
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomTextField(
                              fillColor: Colors.white,
                              activated: true,
                              hintText: "notes".tr,
                              onChanged: (value) {
                                context
                                    .read<GeneralState>()
                                    .addNotes(value.toString());
                              },
                              name: 'notes',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.54,
                      child: ReceiptItemsTable(
                        width: width,
                        height: height,
                        context: context,
                        data: data,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Visibility(
                      visible: context
                              .read<GeneralState>()
                              .currentReceipt["section_type_no"] !=
                          5,
                      child: SizedBox(
                        width: width * 0.98,
                        child: BottomTable(
                          controllers: controllers,
                          customer: widget.customer,
                          height: height,
                          width: width,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
