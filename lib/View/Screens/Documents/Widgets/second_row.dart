import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/View/Screens/Documents/document_controller.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class SecondRow extends StatelessWidget {
  final int sectionNo;
  final TextEditingController textController;
  final DocumentsController documentsController;
  const SecondRow({
    Key? key,
    required this.sectionNo,
    required this.textController,
    required this.documentsController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AutoSizeText(
          context.read<DocumentsViewmodel>().amountTitle(
                sectionTypeNo: sectionNo,
              ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Consumer<DocumentsViewmodel>(
            builder: (BuildContext context, state, Widget? child) =>
                CustomTextField(
              hintText: "enter_amount".tr,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                FilteringTextInputFormatter.deny("")
              ],
              editingController: textController,
              validationMode: AutovalidateMode.onUserInteraction,
              validators: FormBuilderValidators.numeric(context),
              name: "cash_value",
              onTap: () {
                textController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: textController.value.text.length,
                );
              },
              onChanged: (value) {
                log(value.toString());
                documentsController.editDocument(
                  input: {
                    "cash_value": ValuesManager.numberValidator(value ?? "")
                  },
                );
              },
              // activated: (state.selectedCustomer.name != null ||
              //     sectionNo == 108 ||
              //     sectionNo == 107),
              activated: true,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text("doc_history".tr),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: CustomTextField(
          hintText: "date".tr,
          name: "oper_date",
          initialValue: CurrentDate.getCurrentDate(),
        )),
      ],
    );
  }
}
