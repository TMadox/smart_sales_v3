import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Provider/general_state.dart';
import "package:provider/provider.dart";
import 'package:smart_sales/Provider/user_state.dart';

class DeleteRepo {
  Dio dio = Dio();
  Future<bool> requestDeleteRepo({required BuildContext context}) async {
    UserModel currentUser = context.read<UserState>().user;
    String ipPassword = currentUser.ipPassword;
    String ipAddress = currentUser.ipAddress;
    String encoded = base64.encode(utf8.encode(ipPassword));
    List<Map> receipts = List.from(context.read<GeneralState>().receiptsList);
    bool foundError = false;
    int priorIndex = receipts.length;
    for (var element in receipts
        .where((element) => element["is_sender_complete_status"] == 1)) {
      log(element["upload_code"].toString());
      final response = await dio.post(
        "http://$ipAddress/api_delete_saved_operation_by_oper_id_and_refrence_id",
        queryParameters: {
          "oper_id": element["upload_code"],
          "refrence_id": locator.get<DeviceParam>().deviceId
        },
        options: Options(
          headers: {"Authorization": 'Basic ' + encoded},
          receiveTimeout: 15000,
          sendTimeout: 15000,
        ),
      );
      if (response.data == "not ok" || response.data == "not found") {
        foundError = true;
      } else {
        context.read<GeneralState>().deleteReceipt(receipt: element);
      }
    }
    if (context.read<GeneralState>().receiptsList.length != priorIndex) {
      await locator.get<SaveData>().saveReceiptsData(
          input: context.read<GeneralState>().receiptsList, context: context);
    }
    return foundError;
  }
}
