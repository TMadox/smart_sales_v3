import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/delete_repo.dart';
import 'package:smart_sales/Services/Repositories/request_allowance_repo.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_snackbar.dart';

class HomeController extends GetxController {
  Future<void> newRequest(BuildContext context) async {
    final List<Map> operations = ReadData().readOperations();
    try {
      if (operations.isNotEmpty &&
          operations
              .where((element) => element["is_sender_complete_status"] == 0)
              .isNotEmpty) {
        showErrorDialog(
          context: context,
          title: "error".tr,
          description: "operations_not_uploaded_yet".tr,
        );
      } else {
        if (await locator
            .get<DeleteRepo>()
            .requestDeleteRepo(context: context)) {
          throw "operations_not_exported_yet".tr;
        }
        await locator.get<RequestAllowanceRepo>().requestAllowance(context);
        responseSnackbar(
          context,
          "operations_removed_request_made".tr,
        );
      }
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
    }
  }
}
