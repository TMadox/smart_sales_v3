import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/date.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class SecondRow extends StatelessWidget {
  final double width;
  final int sectionNo;
  final TextEditingController controller;
  const SecondRow({
    Key? key,
    required this.width,
    required this.sectionNo,
    required this.controller,
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
        SizedBox(
          width: width * 0.01,
        ),
        Expanded(
          child: Consumer<DocumentsViewmodel>(
            builder: (BuildContext context, state, Widget? child) =>
                CustomTextField(
              hintText: "enter_amount".tr,
              inputType: TextInputType.number,
              editingController: controller,
              validationMode: AutovalidateMode.onUserInteraction,
              validators: FormBuilderValidators.numeric(context),
              name: "cash_value",
              onTap: () {
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.value.text.length,
                );
              },
              onChanged: (value) {
                context.read<GeneralState>().changeReceiptValue(input: {
                  "cash_value": ValuesManager.numberValidator(value ?? "")
                });
              },
              activated: (state.selectedCustomer.amName != null ||
                  sectionNo == 108 ||
                  sectionNo == 107),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.01,
        ),
        Text("doc_history".tr),
        SizedBox(
          width: width * 0.01,
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
