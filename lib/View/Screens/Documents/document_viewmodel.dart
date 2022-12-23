import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/View/Screens/Base/base_controller.dart';

class DocumentsViewmodel extends ChangeNotifier with BaseController {
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

  
}
