import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

class UploadReceipts {
  Dio dio = Dio();
  requestUploadReceipts({required BuildContext context}) async {
    String error = "حدث خطا في رفع كل او بعض الفواتير";
    var now = DateTime.now();
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
      final response = await DioRepository.to.post(
        path: "/update_fat_head_data",
        data: [
          [receipt],
          products,
          null
        ],
      );
      if (response == "[]" ||
          response == -1 ||
          response == -19 ||
          response == -30) {
        foundError = true;
        switch (response) {
          case -1:
            {
              error = "خطأ عام";
              break;
            }
          case -19:
            {
              error = "بعض الفواتير مكررة";
              break;
            }
          case -30:
            {
              error = "السرفر مشغول";
              break;
            }
          default:
        }
        context.read<GeneralState>().setReceiptsUploadStatus(
              index: context.read<GeneralState>().receiptsList.indexOf(receipt),
              completeStatus: 0,
              code: response,
            );
      } else {
        context.read<GeneralState>().setReceiptsUploadStatus(
              index: context.read<GeneralState>().receiptsList.indexOf(receipt),
              completeStatus: 1,
              code: response,
            );
        context.read<UserState>().setLastUploadDate(
              date: now.toString(),
            );
      }
    }
    if (foundError) throw error;
  }
}
