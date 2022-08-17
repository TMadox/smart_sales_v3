import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:provider/provider.dart';

class RequestAllowanceRepo {
  Dio dio = Dio();
  Future requestAllowance(BuildContext context) async {
    UserModel currentUser = context.read<UserState>().user;
    String ipPassword = currentUser.ipPassword;
    String ipAddress = currentUser.ipAddress;
    String encoded = base64.encode(utf8.encode(ipPassword));
    await dio.post(
        "http://$ipAddress/api_new_period_add_new_talab_by_refrence_id",
        queryParameters: {"refrence_id": locator.get<DeviceParam>().deviceId},
        options: Options(
            headers: {"Authorization": 'Basic ' + encoded},
            receiveTimeout: 15000,
            sendTimeout: 15000));
  }
}
