import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Features/exit.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/receipt_items_table.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';

class StorTransfer extends StatefulWidget {
  final StorModel stor;
  final int sectionTypeNo;
  const StorTransfer({
    Key? key,
    required this.stor,
    required this.sectionTypeNo,
  }) : super(key: key);

  @override
  State<StorTransfer> createState() => _StorTransferState();
}

class _StorTransferState extends State<StorTransfer> {
  final List<TextEditingController> controllers =
      List.generate(4, (i) => TextEditingController(text: 0.0.toString()));
  TextEditingController searchController = TextEditingController();
  final ReceiptsController receiptsController = Get.find<ReceiptsController>();
  late Map data = {};
  final storage = GetStorage();
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.stor.name,
      "credit_before": widget.stor.curBalance,
      "cst_tax": widget.stor.taxFileNo,
      "employ_id": context.read<UserState>().user.defEmployAccId,
      "basic_acc_id": widget.stor.accId,
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        receiptsController.startReceipt(
          context: context,
          entity: widget.stor,
          sectionTypeNo: widget.sectionTypeNo,
          selectedStorId: widget.stor.id,
          resetReceipt: true,
        );
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Exit().commit(
          context: context,
          warnExit: receiptsController.receiptItems.value.isNotEmpty,
          data: data,
        );
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
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        OptionsButton(
                          color: Colors.red,
                          iconData: Icons.arrow_back_ios,
                          width: 40,
                          height: 40,
                          bottomMargin: 0,
                          onPressed: () {
                            if (receiptsController
                                .receiptItems.value.isNotEmpty) {
                              generalDialog(
                                context: context,
                                message: 'receipt_still_inprogress'.tr,
                                onCancelText: 'exit'.tr,
                                onOkText: 'stay'.tr,
                                onCancel: () {
                                  if (GetStorage().read("request_visit") ??
                                      false) {
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
                            } else {
                              if ((GetStorage().read("request_visit") ??
                                  false)) {
                                exitDialog(
                                  context: context,
                                  data: data,
                                );
                              } else {
                                Get.back();
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: whiteHaze,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            child: Obx(
                              () {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
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
                                                      receiptsController
                                                          .currentReceipt
                                                          .value["stor_id"] ==
                                                      stor.id)
                                                  .name
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
                                        height: 40,
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
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
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
                                                      receiptsController
                                                              .currentReceipt
                                                              .value[
                                                          "in_stor_id"] ==
                                                      stor.id)
                                                  .name
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
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OptionsButton(
                            width: 50,
                            color: Colors.purple,
                            bottomMargin: 0,
                            onPressed: () {
                              Get.find<ReceiptsController>()
                                  .scanBarcode(context: context);
                            },
                            iconData: Icons.qr_code,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              height: 35,
                              decoration: const BoxDecoration(
                                color: smaltBlue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                          receiptsController.addSearchedItem(
                                              keyword: value ?? "",
                                              context: context);
                                          searchController.clear();
                                        } catch (e) {
                                          searchController.clear();
                                          if (e == 420) {
                                            receiptsController.removeLastItem();
                                            showErrorDialog(
                                              context: context,
                                              description:
                                                  'price_less_than_selling_price'
                                                      .tr,
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
                                      child: Obx(
                                        () => AutoSizeText.rich(
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
                                                text: receiptsController
                                                    .currentReceipt
                                                    .value["items_count"]
                                                    .toString(),
                                                style: GoogleFonts.cairo(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "total_free_qty".tr,
                                            style: GoogleFonts.cairo(
                                                color: atlantis),
                                          ),
                                          TextSpan(
                                            text: ": ",
                                            style: GoogleFonts.cairo(
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: receiptsController
                                                .currentReceipt
                                                .value["free_items_count"]
                                                .toString(),
                                            style: GoogleFonts.cairo(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      fillColor: Colors.white,
                                      activated: true,
                                      hintText: "notes".tr,
                                      onChanged: (value) {
                                        receiptsController
                                            .addNotes(value.toString());
                                      },
                                      name: 'notes',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: ReceiptItemsTable(
                        data: data,
                        receiptsController: receiptsController,
                        isEditing: false,
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
