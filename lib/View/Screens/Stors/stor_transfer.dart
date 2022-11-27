import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/receipt_items_table.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';

class StorTransfer extends StatefulWidget {
  const StorTransfer({
    Key? key,
  }) : super(key: key);

  @override
  State<StorTransfer> createState() => _StorTransferState();
}

class _StorTransferState extends State<StorTransfer> {
  final List<TextEditingController> controllers =
      List.generate(4, (i) => TextEditingController(text: 0.0.toString()));
  TextEditingController searchController = TextEditingController();
  late Map data = {};
  final storage = GetStorage();
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": context.read<GeneralState>().currentReceipt["user_name"],
      "credit_before":
          context.read<GeneralState>().currentReceipt["credit_before"] ?? 0.0,
      "cst_tax":
          context.read<GeneralState>().currentReceipt["cst_tax"] ?? ".....",
      "employ_id": context.read<GeneralState>().currentReceipt["employ_id"],
      "basic_acc_id":
          context.read<GeneralState>().currentReceipt["basic_acc_id"],
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
          generalDialog(
            title: "warning".tr,
            context: context,
            message: 'receipt_still_inprogress'.tr,
            onCancelText: 'exit'.tr,
            onOkText: 'stay'.tr,
            onCancel: () {
              if ((GetStorage().read("request_visit") ?? false)) {
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
          if ((storage.read("request_visit") ?? false)) {
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
                      child: Consumer<GeneralState>(
                          builder: (context, state, widget) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: height * 0.09,
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.storsRoute,
                                        arguments: const StorsView(
                                          canTap: true,
                                          choosingSourceStor: true,
                                          canPushReplace: true,
                                        ),
                                      );
                                    },
                                    child: AutoSizeText(
                                      context
                                          .read<StoreState>()
                                          .stors
                                          .firstWhere((stor) =>
                                              state.currentReceipt["stor_id"] ==
                                              stor.storId)
                                          .storName
                                          .toString(),
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
                                child: const Text(
                                  "تحويل الي",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: atlantis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * 0.09,
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.storsRoute,
                                        arguments: const StorsView(
                                          canTap: true,
                                          choosingSourceStor: false,
                                          canPushReplace: true,
                                        ),
                                      );
                                    },
                                    child: AutoSizeText(
                                      context
                                          .read<StoreState>()
                                          .stors
                                          .firstWhere((stor) =>
                                              state.currentReceipt[
                                                  "in_stor_id"] ==
                                              stor.storId)
                                          .storName
                                          .toString(),
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                                FilteringTextInputFormatter.deny("")
                              ],
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
                                  double temp = element["free_qty"];
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
