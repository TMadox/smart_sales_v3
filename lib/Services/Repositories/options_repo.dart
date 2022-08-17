import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/options_model.dart';

class OptionsRepo {
  Dio dio = Dio();
  Future<List<OptionsModel>> requiredOptions({
    required String ip,
    required String ipPassword,
  }) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.get(
      "http://$ip/get_data_options",
      options: Options(
        headers: {"Authorization": 'Basic ' + encoded},
        receiveTimeout: 15000,
        sendTimeout: 15000,
      ),
    );
    if (response.data == "[]") {
      throw "خطا في استحضار الخيارات";
    }

    List serializedList = json.decode(response.data);
    return serializedList
        .map<OptionsModel>((e) => OptionsModel.fromMap(e))
        .toList();
  }
}
