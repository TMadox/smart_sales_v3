import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class SecondBar extends StatelessWidget {
  final ReceiptsController receiptsController;
  final TextEditingController searchController;
  final bool isEditing;
  const SecondBar({
    super.key,
    required this.receiptsController,
    required this.searchController,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isEditing)
            OptionsButton(
              width: 50,
              color: Colors.purple,
              bottomMargin: 0,
              onPressed: () {
                Get.find<ReceiptsController>().scanBarcode(context: context);
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!isEditing)
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
                              context: context,
                            );
                            searchController.clear();
                          } catch (e) {
                            searchController.clear();
                            if (e == 420) {
                              receiptsController.removeLastItem();
                              showErrorDialog(
                                context: context,
                                description: 'price_less_than_selling_price'.tr,
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
                        () {
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
                                  text: receiptsController
                                      .currentReceipt.value["items_count"]
                                      .toString(),
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
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        return AutoSizeText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "total_free_qty".tr,
                                style: GoogleFonts.cairo(color: atlantis),
                              ),
                              TextSpan(
                                text: ": " +
                                    (receiptsController.currentReceipt
                                                .value["free_items_count"] ??
                                            0)
                                        .toString(),
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
                        receiptsController.addNotes(value.toString());
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
    );
  }
}
