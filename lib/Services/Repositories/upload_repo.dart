import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';

class UploadReceipts {
  Dio dio = Dio();
  requestUploadReceipts({required BuildContext context}) async {
    var now = DateTime.now();
    UserModel currentUser = context.read<UserState>().user;
    String ipPassword = currentUser.ipPassword;
    String ipAddress = currentUser.ipAddress;
    String encoded = base64.encode(utf8.encode(ipPassword));
    List<Map> receipts = context.read<GeneralState>().receiptsList;
    bool foundError = false;
    for (Map receipt in receipts.where(
      (element) =>
          (element["is_sender_complete_status"] == 0) &&
          (element["upload_code"] != -19),
    )) {
      final List products = json.decode(
        receipt["products"] ?? "[]",
      );
      final response = await dio
          .post(
            "http://$ipAddress/update_fat_head_data",
            data: [
              [receipt],
              products,
              null
            ],
            options: Options(
              headers: {"Authorization": 'Basic ' + encoded},
              receiveTimeout: 15000,
              sendTimeout: 15000,
            ),
          )
          .timeout(
            const Duration(seconds: 15),
          );
      if (response.data == "[]" ||
          response.data == -1 ||
          response.data == -19 ||
          response.data == -30) {
        foundError = true;
        if (response.data == -19) {
          context.read<GeneralState>().setReceiptsUploadStatus(
                index:
                    context.read<GeneralState>().receiptsList.indexOf(receipt),
                completeStatus: 0,
                code: response.data,
              );
        }
      } else {
        context.read<GeneralState>().setReceiptsUploadStatus(
              index: context.read<GeneralState>().receiptsList.indexOf(receipt),
              completeStatus: 1,
              code: response.data,
            );
        context.read<UserState>().setLastUploadDate(
              date: now.toString(),
            );
      }
    }
    if (foundError) throw "حدث خطا في رفع كل او بعض الفواتير";
  }
}
