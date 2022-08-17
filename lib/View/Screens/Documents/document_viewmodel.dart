import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/View/Widgets/Dialogs/done_dialog.dart';

class DocumentsViewmodel extends ChangeNotifier with BaseViewmodel {
  ClientModel selectedCustomer = ClientModel();
  PaymentMethod paymentMethod = PaymentMethod.cash;
  double newCredit = 0.0;
  void switchPaymentMethod() {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        paymentMethod = PaymentMethod.bank;
        break;
      case PaymentMethod.bank:
        paymentMethod = PaymentMethod.cash;
        break;
      default:
    }
    notifyListeners();
  }

  void setSelectedCustomer({
    required ClientModel input,
    bool rebuild = true,
  }) {
    selectedCustomer = input;
    newCredit = selectedCustomer.curBalance ?? 0.0;
    if (rebuild) notifyListeners();
  }

  String amountTitle({required int sectionTypeNo}) {
    switch (sectionTypeNo) {
      case 102:
        return "doc_paid_amount".tr;
      case 101:
        return "doc_received_amount".tr;
      case 108:
        return "paid_expenses".tr;
      default:
        return "doc_paid_amount".tr;
    }
  }

  onFinishDocument({
    required Map inputs,
    required int sectionNo,
    required BuildContext context,
    bool share = false,
    bool savePdf = false,
  }) async {
    try {
      Navigator.of(context).pop();
      EasyLoading.show();
      inputs.remove("basic_acc_id");
      inputs.addAll({
        "cash_value": double.parse(inputs["cash_value"]),
        "oper_value": double.parse(inputs["cash_value"]),
        "section_type_no": sectionNo,
        "oper_net_value": double.parse(inputs["cash_value"]),
        "oper_net_value_with_tax": double.parse(inputs["cash_value"]),
      });
      context.read<GeneralState>().changeReceiptValue(input: inputs);
      await context.read<GeneralState>().computeReceipt(
            context: context,
          );
      if (savePdf && !share) {
        await createPDF(
          bContext: context,
          receipt: context.read<GeneralState>().receiptsList.last,
        );
      } else if (!savePdf && share) {
        await createPDF(
          bContext: context,
          receipt: context.read<GeneralState>().receiptsList.last,
          share: true,
        );
      }
      EasyLoading.dismiss();
      doneDialog(
        context: context,
        onOk: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      Navigator.pop(context);
      EasyLoading.showError("error".tr);
    }
  }
}
