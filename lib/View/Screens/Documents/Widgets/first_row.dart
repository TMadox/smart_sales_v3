import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/View/Screens/Documents/document_controller.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class FirstRow extends StatelessWidget {
  final int sectionNo;
  final Entity entity;
  final GlobalKey<FormBuilderState> formKey;
  final DocumentsController documentsController;
  final List<Entity> entites;
  const FirstRow({
    Key? key,
    required this.sectionNo,
    required this.entity,
    required this.formKey,
    required this.entites,
    required this.documentsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          documentsController.title(sectionNo),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 2,
          child: FormBuilderField(
            builder: (field) {
              return DropdownSearch<Entity>(
                validator: FormBuilderValidators.required(context),
                popupProps: PopupProps.modalBottomSheet(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.accId.toString()),
                    );
                  },
                ),
                dropdownBuilder: (context, selectedItem) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      selectedItem == null ? "" : selectedItem.name.toString(),
                    ),
                  );
                },
                selectedItem: entity,
                items: entites,
                itemAsString: (item) => item.name,
                filterFn: (instance, filter) {
                  if (instance.name.contains(filter.toString())) {
                    return true;
                  } else {
                    return false;
                  }
                },
                onChanged: (entity) {
                  field.didChange(entity!.accId);
                  formKey.currentState!.fields.values.elementAt(2).reset();
                  documentsController.editDocument(
                    input: {
                      "cst_tax": entity.taxFileNo,
                      "user_name": entity.name,
                      "credit_before": entity.curBalance,
                      "basic_acc_id": entity.accId,
                      "cash_value": 0.0,
                    },
                  );
                },
              );
            },
            name: "basic_acc_id",
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        AutoSizeText(
          sectionNo == 101 ? "seizure_method".tr : "payment_method".tr,
        ),
        const SizedBox(
          width: 5,
        ),
        Consumer<DocumentsViewmodel>(
          builder:
              (BuildContext context, DocumentsViewmodel state, Widget? child) {
            if (sectionNo == 101 && state.paymentMethod == PaymentMethod.cash) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  state.switchPaymentMethod();
                },
                child: AutoSizeText(
                  "cash".tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            } else if (sectionNo == 101 &&
                state.paymentMethod == PaymentMethod.bank) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  state.switchPaymentMethod();
                },
                child: AutoSizeText(
                  "bank_transfer".tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Expanded(
                child: CustomTextField(
                  hintText: "date".tr,
                  name: "payment_method",
                  initialValue: "cash".tr,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
