import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_controller.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class ThirdRow extends StatelessWidget {
  final int sectionNo;
  final DocumentsController documentsController;
  const ThirdRow(
      {Key? key, required this.sectionNo, required this.documentsController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentsViewmodel>(
      builder: (BuildContext context, state, Widget? child) {
        return Row(
          children: [
            AutoSizeText(
              (state.paymentMethod == PaymentMethod.bank
                      ? "bank_name".tr
                      : "box_name".tr) +
                  ": ",
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                (state.paymentMethod == PaymentMethod.bank
                        ? context.read<UserState>().user.defSarafAccId
                        : context.read<UserState>().user.defBoxAccId)
                    .toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "doc_number".tr,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: CustomTextField(
                activated: false,
                hintText: "",
                name: "op_number",
                initialValue:
                    documentsController.document.value["oper_id"].toString(),
              ),
            ),
          ],
        );
      },
    );
  }
}
