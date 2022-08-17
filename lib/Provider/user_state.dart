import 'package:flutter/foundation.dart';
import 'package:smart_sales/Data/Models/user_model.dart';

class UserState extends ChangeNotifier {
  UserModel user = UserModel(ipPassword: "1");
  Map loginInfo = {"ip_password": "1", "ip_address": "164.68.105.110"};
  void setLoggedUser({required UserModel input}) => user = input;
  void setLastUploadDate({required String date}) {
    user.uploadDate = date;
  }

  void setLoginInfo({required Map input}) {
    loginInfo.addAll(input);
    notifyListeners();
  }
}
