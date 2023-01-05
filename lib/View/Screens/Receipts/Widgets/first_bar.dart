import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/View/Common/Features/receipt_type.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Mow/mow_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class FirstBar extends StatelessWidget {
  final ReceiptsController receiptsController;
  final bool isEditing;
  final Map data;
  const FirstBar({
    super.key,
    required this.receiptsController,
    required this.isEditing,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OptionsButton(
          color: Colors.red,
          iconData: Icons.arrow_back_ios,
          width: 40,
          height: 40,
          bottomMargin: 0,
          onPressed: () {
            if (receiptsController.receiptItems.value.isNotEmpty) {
              generalDialog(
                context: context,
                message: 'receipt_still_inprogress'.tr,
                onCancelText: 'exit'.tr,
                onOkText: 'stay'.tr,
                onCancel: () {
                  if (GetStorage().read("request_visit") ?? false) {
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
              if ((GetStorage().read("request_visit") ?? false)) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            receiptsController.selectedEntity?.name ??
                                "unknown".tr,
                            maxLines: 1,
                            style: GoogleFonts.cairo(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isEditing)
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (receiptsController.currentReceipt
                                          .value["section_type_no"] ==
                                      3 ||
                                  receiptsController.currentReceipt
                                          .value["section_type_no"] ==
                                      4) {
                                Get.to(
                                  () => const MowView(
                                    canTap: true,
                                    sectionTypeNo: 3,
                                    canPushReplace: true,
                                  ),
                                );
                              } else {
                                Get.to(
                                  () => ClientsScreen(
                                    canPushReplace: true,
                                    sectionType: receiptsController
                                            .currentReceipt
                                            .value["section_type_no"] ??
                                        1,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "date".tr + " ",
                                style: GoogleFonts.cairo(color: atlantis),
                              ),
                              TextSpan(
                                text: ": " +
                                    CurrentDate.getCurrentDate().toString(),
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
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
                                    CurrentDate.getCurrentTime().toString(),
                                style: GoogleFonts.cairo(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        AutoSizeText(
                          ReceiptType().get(
                                  type: receiptsController.currentReceipt
                                          .value["section_type_no"] ??
                                      0) +
                              " " +
                              "number".tr +
                              ":" +
                              receiptsController.currentReceipt.value["oper_id"]
                                  .toString(),
                          style: GoogleFonts.cairo(
                            color: atlantis,
                          ),
                        ),
                        if (!isEditing)
                          Obx(
                            () {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: FloatingActionButton(
                                  backgroundColor: (receiptsController
                                              .currentReceipt
                                              .value["force_cash"] ??
                                          false)
                                      ? Colors.grey
                                      : receiptsController.currentReceipt
                                                  .value["pay_by_cash_only"] ==
                                              1
                                          ? Colors.orange
                                          : Colors.blue,
                                  onPressed: (receiptsController.currentReceipt
                                              .value["force_cash"] ??
                                          false)
                                      ? null
                                      : () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (receiptsController.currentReceipt
                                                  .value["pay_by_cash_only"] ==
                                              1) {
                                            receiptsController
                                                .changeReceiptValue(
                                              input: {
                                                "pay_by_cash_only": 0,
                                                "cash_value": 0.0,
                                              },
                                            );
                                          } else {
                                            receiptsController
                                                .changeReceiptValue(
                                              input: {
                                                "pay_by_cash_only": 1,
                                              },
                                            );
                                          }
                                        },
                                  child: Text(
                                    receiptsController.currentReceipt
                                                .value["pay_by_cash_only"] ==
                                            1
                                        ? "cash".tr
                                        : "instant".tr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
