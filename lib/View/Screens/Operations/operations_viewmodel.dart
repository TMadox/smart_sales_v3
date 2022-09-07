import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/upload_repo.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';

class OperationsViewmodel {
  String receiptType({required int type}) {
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
      case 5:
        return "stor_transfer".tr;
      case 4:
        return "purchase_return".tr;
      case 101:
        return "seizure_document".tr;
      case 17:
        return "selling_order".tr;
      case 18:
        return "purchase_order".tr;
      case 98:
        return "inventory".tr;
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
      case 31:
        return "cashier_receipt".tr;
      default:
        return "sales".tr;
    }
  }

  Future<void> uploadReceipts(BuildContext context) async {
    try {
      EasyLoading.show();
      await locator
          .get<UploadReceipts>()
          .requestUploadReceipts(context: context);
      await locator.get<SaveData>().saveReceiptsData(
            input: context.read<GeneralState>().receiptsList,
            context: context,
          );
    } catch (e) {
      log(e.toString());
      if (e is DioError) {
        String message = DioExceptions.fromDioError(e).toString();
        showErrorDialog(
            context: context, description: message, title: "error".tr);
      } else {
        showErrorDialog(
            context: context, description: e.toString(), title: "error".tr);
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
