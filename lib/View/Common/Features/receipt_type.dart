import 'package:get/get.dart';

class ReceiptType {
  String get({required int type}) {
    switch (type) {
      case 9999:
        return "visit".tr;
      case 0:
        return "total".tr;
      case 1:
        return "sales".tr;
      case 2:
        return "return".tr;
      case 3:
        return "purchase".tr;
      case 4:
        return "purchase_return".tr;
      case 5:
        return "stor_transfer".tr;
      case 17:
        return "selling_order".tr;
      case 18:
        return "purchase_order".tr;
      case 31:
        return "cashier_receipt".tr;
      case 98:
        return "inventory".tr;
      case 101:
        return "seizure_document".tr;
      case 102:
        return "payment_document".tr;
      case 103:
        return "mow_seizure_document".tr;
      case 104:
        return "mow_payment_document".tr;
      case 107:
        return "expenses_seizure_document".tr;
      case 108:
        return "expenses_document".tr;
      case 105:
        return "employee seizure document".tr;
      case 106:
        return "employee payment document".tr;

      default:
        return "sales".tr;
    }
  }
}
