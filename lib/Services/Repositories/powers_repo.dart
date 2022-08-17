import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/power_model.dart';

class PowersRepo {
  Dio dio = Dio();
  Future<List<PowersModel>> requestPowers(
      {required String ip,
      required String ipPassword,
      required int userId}) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.get("http://$ip/get_user_powers_by_user_id",
        queryParameters: {"user_id": userId},
        options: Options(
            headers: {"Authorization": 'Basic ' + encoded},
            receiveTimeout: 15000,
            sendTimeout: 15000));
    if (response.data == "[]") {
      throw "خطا في استحضار الصلاحيات";
    }
    List serializedList = json.decode(response.data);
    return serializedList
        .map<PowersModel>((e) => PowersModel.fromMap(e))
        .toList();
  }
}
