import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class BottomTableCell extends StatefulWidget {
  final TextEditingController? controller;
  final GeneralState state;
  final String keyName;
  final bool? readOnly;
  final Color? color;
  const BottomTableCell({
    Key? key,
    this.controller,
    required this.state,
    required this.keyName,
    this.readOnly,
    this.color,
  }) : super(key: key);

  @override
  State<BottomTableCell> createState() => _BottomTableCellState();
}

class _BottomTableCellState extends State<BottomTableCell> {
  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        final currentValue = widget.state.currentReceipt[widget.keyName];
        final value = widget.controller!.value.text;
        try {
          if (value != "" && value != ".") {
            widget.state.changeReceiptValue(
                input: {widget.keyName: double.parse(value.toString())});
          } else {
            widget.controller!.value = const TextEditingValue(text: "0.0");
            widget.controller!.selection = TextSelection(
              baseOffset: 0,
              extentOffset: widget.controller!.value.text.length,
            );
            widget.state.changeReceiptValue(
              input: {
                widget.keyName: 0.0,
              },
            );
          }
        } catch (e) {
          widget.controller!.text = currentValue.toString();
          widget.state.changeReceiptValue(
            input: {
              widget.keyName: currentValue,
            },
          );
          showErrorDialog(
            context: context,
            description: 'ليس لديك صلاحيات لتقليل السعر الي اقل من الحد الادني',
            title: "error".tr,
          );
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context) * 0.1,
      child: Center(
        child: Builder(
          builder: (context) {
            if ((widget.readOnly ?? false) == false) {
              return CustomTextField(
                activated: true,
                isDense: true,
                readOnly: widget.readOnly ?? false,
                errorFontSize: 0,
                editingController: widget.controller,
                name: widget.keyName,
                textAlign: TextAlign.center,
                 inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  FilteringTextInputFormatter.deny("")
                ],
                validationMode: AutovalidateMode.onUserInteraction,
                validators: FormBuilderValidators.numeric(
                  context,
                  errorText: "",
                ),
                onTap: () {
                  widget.controller!.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: widget.controller!.value.text.length,
                  );
                },
              );
            } else {
              return Container(
                width: screenWidth(context) * 0.1,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ValuesManager.doubleToString(
                    widget.state.currentReceipt[widget.keyName],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
