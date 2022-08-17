import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/info_model.dart';

class InfoRepo {
  Dio dio = Dio();
  Future<InfoModel> requestInfo({
    required String ip,
    required String ipPassword,
  }) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.get("http://$ip/get_data_header",
        options: Options(
          headers: {"Authorization": 'Basic ' + encoded},
          receiveTimeout: 15000,
          sendTimeout: 15000,
        ));

    if (response.data == "[]") {
      throw "خطا في استحضار معلومات الشركة";
    }
    List serializedList = json.decode(response.data);
    return InfoModel.fromMap(serializedList[0]);
  }
}
