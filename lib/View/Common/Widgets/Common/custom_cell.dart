import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_sales/View/Common/Controllers/general_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/edit_price_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';

class CustomCell extends StatefulWidget {
  final bool isEditable;
  final String keyValue;
  final Map item;
  final GeneralController generalController;
  final TextEditingController? controller;
  final Color? textColor;
  final Color? borderColor;
  final Color? fillColor;
  final double? width;
  const CustomCell({
    Key? key,
    this.isEditable = false,
    this.fillColor,
    required this.keyValue,
    required this.item,
    required this.generalController,
    this.controller,
    this.width,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<CustomCell> createState() => _CustomCellState();
}

class _CustomCellState extends State<CustomCell> {
  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.addListener(
        () {
          final currentValue = widget.item[widget.keyValue];
          final value = widget.controller!.value.text;
          try {
            if (value != "" && value != ".") {
              widget.generalController.editItem(
                input: {widget.keyValue: double.parse(value.toString())},
                item: widget.item,
              );
            } else {
              widget.controller!.value = const TextEditingValue(text: "0.0");
              widget.controller!.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.controller!.value.text.length,
              );
              widget.generalController.editItem(
                input: {
                  widget.keyValue: 0.0,
                },
                item: widget.item,
              );
            }
          } catch (e) {
            widget.controller!.text = currentValue.toString();
            widget.generalController.editItem(
              input: {
                widget.keyValue: currentValue,
              },
              item: widget.item,
            );
            showErrorDialog(
              context: context,
              description: e.toString(),
              title: "error".tr,
            );
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width ?? 60,
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Builder(
          builder: (context) {
            String unit =
                double.parse(widget.item["unit_convert"].toString()) > 1.0
                    ? widget.item["unit_name"].toString() +
                        " " +
                        widget.item["unit_convert"].toString()
                    : widget.item["unit_name"].toString();
            if (widget.isEditable && widget.keyValue != "original_price") {
              return CustomTextField(
                activated: true,
                fillColor: widget.fillColor,
                borderColor: widget.borderColor,
                editingController: widget.controller,
                readOnly: !widget.isEditable,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  FilteringTextInputFormatter.deny("")
                ],
                onTap: () {
                  widget.controller!.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: widget.controller!.value.text.length,
                  );
                },
                textAlign: TextAlign.center,
                isDense: true,
                name: '',
              );
            } else if (widget.isEditable &&
                widget.keyValue == "original_price") {
              return InkWell(
                onTap: () {
                  showEditPriceDialog(
                    context: context,
                    leastSellingPrice:
                        widget.item["least_selling_price_with_tax"].toString(),
                    generalController: widget.generalController,
                    itemPrice: widget.item["original_price"].toString(),
                    item: widget.item,
                    originalPrice: widget.item["original_price"].toString(),
                  );
                },
                child: AutoSizeText(
                  widget.item[widget.keyValue].toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: widget.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            } else {
              return AutoSizeText(
                widget.keyValue == "unit_convert"
                    ? unit
                    : widget.item[widget.keyValue].toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(color: widget.textColor),
              );
            }
          },
        ),
      ),
    );
  }
}
