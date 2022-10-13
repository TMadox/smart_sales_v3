import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Dialogs/edit_price_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class CustomCell extends StatelessWidget {
  final bool isEditable;
  final String keyValue;
  final Map item;
  final double width;
  final GeneralState generalState;
  final double height;
  final TextEditingController? controller;
  const CustomCell({
    Key? key,
    this.isEditable = false,
    required this.keyValue,
    required this.item,
    required this.width,
    required this.generalState,
    required this.height,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width * 0.118,
        child: Builder(
          builder: (context) {
            final ReceiptViewmodel baseViewmodel =
                context.read<ReceiptViewmodel>();
            String unit = double.parse(item["unit_convert"].toString()) > 1.0
                ? item["unit_name"].toString() +
                    " " +
                    item["unit_convert"].toString()
                : item["unit_name"].toString();
            if (isEditable && keyValue != "original_price") {
              final currentValue = item[keyValue];
              return TextFormField(
                controller: controller,
                readOnly: !isEditable,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  FilteringTextInputFormatter.deny("")
                ],
                onTap: () {
                  controller!.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: controller!.value.text.length,
                  );
                },
                onChanged: (value) {
                  try {
                    baseViewmodel.changeValue(
                      controller: controller!,
                      item: item,
                      value: value.toString(),
                      key: keyValue,
                      generalState: generalState,
                    );
                  } catch (e) {
                    controller!.text = currentValue.toString();
                    baseViewmodel.changeValue(
                      controller: controller!,
                      item: item,
                      value: currentValue.toString(),
                      key: keyValue,
                      generalState: generalState,
                    );
                    showErrorDialog(
                      context: context,
                      description: e.toString(),
                      title: 'error'.tr,
                    );
                  }
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: GoogleFonts.cairo(),
              );
            } else if (isEditable && keyValue == "original_price") {
              return InkWell(
                onTap: () {
                  showEditPriceDialog(
                    context: context,
                    leastSellingPrice:
                        item["least_selling_price_with_tax"].toString(),
                    itemPrice: item["original_price"].toString(),
                    item: item,
                    originalPrice: item["original_price"].toString(),
                  );
                },
                child: AutoSizeText(
                  item[keyValue].toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              );
            } else {
              return AutoSizeText(
                keyValue == "unit_convert" ? unit : item[keyValue].toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.cairo(),
              );
            }
          },
        ),
      ),
    );
  }
}
