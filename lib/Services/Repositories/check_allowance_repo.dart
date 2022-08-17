import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:provider/provider.dart';

class CheckAllowanceRepo {
  Dio dio = Dio();
  Future<int> requestCheckAllowance(BuildContext context) async {
    UserModel currentUser = context.read<UserState>().user;
    String ipPassword = currentUser.ipPassword;
    String ipAddress = currentUser.ipAddress;
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.post(
        "http://$ipAddress/api_chk_applity_to_bigin_new_period_refrence_id",
        queryParameters: {"refrence_id": locator.get<DeviceParam>().deviceId},
        options: Options(
            headers: {"Authorization": 'Basic ' + encoded},
            receiveTimeout: 15000,
            sendTimeout: 15000));
    return response.data;
  }
}
