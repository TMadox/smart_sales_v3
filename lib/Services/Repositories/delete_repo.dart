import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/App/Util/locator.dart';
import "package:provider/provider.dart";
import 'package:smart_sales/Provider/user_state.dart';

class DeleteRepo {
  Dio dio = Dio();
  Future<bool> requestDeleteRepo({required BuildContext context}) async {
    UserModel currentUser = context.read<UserState>().user;
    String ipPassword = currentUser.ipPassword;
    String ipAddress = currentUser.ipAddress;
    String encoded = base64.encode(utf8.encode(ipPassword));
    final List<Map> operations = ReadData().readOperations();
    bool foundError = false;
    int priorIndex = operations.length;
    for (var element in operations
        .where((element) => (element["is_sender_complete_status"] == 1))) {
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
        log(response.data);
      } else {
        operations.remove(element);
      }
    }
    if (operations.length != priorIndex) {
      await locator.get<SaveData>().saveOperationsData(
        operations: operations,
        lastOperations: {},
      );
    }
    return foundError;
  }
}
