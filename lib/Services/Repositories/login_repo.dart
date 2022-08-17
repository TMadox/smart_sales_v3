import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:smart_sales/Data/Models/user_model.dart';

class LoginRepo {
  Dio dio = Dio();
  Future<UserModel> requestLogin({
    required String ipAddress,
    required String ipPassword,
    required String username,
    required String password,
    required String ref,
    required int userId,
  }) async {
    String encoded = base64.encode(utf8.encode(ipPassword));
    final response = await dio.get(
      "http://$ipAddress/get_data_users_by_user_id",
      queryParameters: {
        "user_id": userId,
        "refrence_id": ref,
      },
      options: Options(
        headers: {
          "Authorization": 'Basic ' + encoded,
        },
        receiveTimeout: 15000,
        sendTimeout: 15000,
      ),
    );
    if (response.data == "[]") {
      throw "خطا في مدخلات الرابط او كلمة السر الخاصة بالرابط";
    }
    if (response.data == "-11") {
      throw "هذا الجهاز غير مسجل";
    }
    log(response.data);
    List serializedList = json.decode(response.data);
    Map temp = {};
    temp.addAll(serializedList[0]);
    temp.addAll({"ip_address": ipAddress, "ip_password": ipPassword});
    if (temp["user_name"] != username || temp["pass_word"] != password) {
      throw "أسم مستخدم او كلمة سر خاطئة";
    }
    return UserModel.fromMap(temp);
  }
}
