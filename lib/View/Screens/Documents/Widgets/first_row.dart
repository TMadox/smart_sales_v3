import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

class FirstRow extends StatefulWidget {
  final int sectionNo;
  final double width;
  final double height;
  final TextEditingController controller;
  const FirstRow({
    Key? key,
    required this.sectionNo,
    required this.width,
    required this.height,
    required this.controller,
  }) : super(key: key);

  @override
  State<FirstRow> createState() => _FirstRowState();
}

class _FirstRowState extends State<FirstRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.sectionNo == 102 ? "paid_by".tr : "received_from".tr,
        ),
        SizedBox(
          width: widget.width * 0.01,
        ),
        Expanded(
          flex: 2,
          child: FormBuilderField(
              builder: (field) {
                return DropdownSearch<ClientsModel>(
                  validator: FormBuilderValidators.required(context),
                  popupProps: PopupProps.modalBottomSheet(
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item.amName!),
                        subtitle: Text(item.accId.toString()),
                      );
                    },
                  ),
                  dropdownBuilder: (context, selectedItem) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        selectedItem == null
                            ? ""
                            : selectedItem.amName.toString(),
                      ),
                    );
                  },
                  selectedItem:
                      context.read<DocumentsViewmodel>().selectedCustomer,
                  items: context.read<ClientsState>().clients,
                  itemAsString: (item) => item.amName!,
                  filterFn: (instance, filter) {
                    if (instance.amName!.contains(filter.toString())) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  onChanged: (customer) {
                    field.didChange(
                      customer!.accId,
                    );
                    widget.controller.text = "0.0";
                    context.read<GeneralState>().changeReceiptValue(input: {
                      "cst_tax": customer.taxFileNo,
                      "user_name": customer.amName,
                      "credit_before": customer.curBalance ?? 0.0,
                      "basic_acc_id": customer.accId,
                    });
                    context.read<DocumentsViewmodel>().setSelectedCustomer(
                          input: customer,
                        );
                  },
                );
              },
              name: "basic_acc_id"),
        ),
        SizedBox(
          width: widget.width * 0.02,
        ),
        AutoSizeText(
          widget.sectionNo == 101 ? "seizure_method".tr : "payment_method".tr,
        ),
        SizedBox(
          width: widget.width * 0.01,
        ),
        Consumer<DocumentsViewmodel>(
          builder:
              (BuildContext context, DocumentsViewmodel state, Widget? child) {
            if (widget.sectionNo == 101 &&
                state.paymentMethod == PaymentMethod.cash) {
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
            } else if (widget.sectionNo == 101 &&
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
