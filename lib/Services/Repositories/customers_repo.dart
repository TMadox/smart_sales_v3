import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/client_model.dart';

class CustomersRepo {
  Dio dio = Dio();
  Future<List<ClientsModel>> requestCustomers({
    required String ipAddress,
    required int employerId,
    required String ipPassword,
  }) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.get(
        "http://$ipAddress/get_data_am_by_employ_acc_id",
        queryParameters: {"employ_acc_id": employerId},
        options: Options(
            headers: {"Authorization": 'Basic ' + encoded},
            receiveTimeout: 15000,
            sendTimeout: 15000));
    if (response.data == "[]") {
      throw "خطا في استحضار العملاء ";
    }
    List serializedList = json.decode(response.data);
    return serializedList
        .map<ClientsModel>((e) => ClientsModel.fromMap(e))
        .toList();
  }
}
