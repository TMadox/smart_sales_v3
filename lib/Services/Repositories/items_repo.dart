import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/item_model.dart';

class ItemRepo {
  Dio dio = Dio();
  Future<List<ItemsModel>> requestItems({
    required String ip,
    required String ipPassword,
    int? storeId,
  }) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = storeId == null
        ? await dio.get(
            "http://$ip/get_data_items",
            options: Options(
              headers: {"Authorization": 'Basic ' + encoded},
              receiveTimeout: 15000,
              sendTimeout: 15000,
            ),
          )
        : await dio.get(
            "http://$ip/get_data_items_with_stor_id",
            queryParameters: {"stor_id": storeId},
            options: Options(
              headers: {"Authorization": 'Basic ' + encoded},
              receiveTimeout: 15000,
              sendTimeout: 15000,
            ),
          );
    if (response.data == "[]") {
      throw "خطا في استحضار المنتجات";
    }
    List serializedList = json.decode(response.data);
    return serializedList
        .map<ItemsModel>((e) => ItemsModel.fromMap(e))
        .toList();
  }
}
