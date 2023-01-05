import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class ReadData {
  final storage = GetStorage();

  List<Map> readOperations() {
    return List<Map>.from(json.decode(GetStorage().read("operations") ?? "[]"));
  }

  List<Map> readRecylePin() {
    return List<Map>.from(json.decode(GetStorage().read("recycle") ?? "[]"));
  }

  Map readLastOperations() {
    return json.decode(GetStorage().read("lastOperations") ?? "{}");
  }

  String? readCustomersData() {
    if (storage.hasData("customers")) {
      String data = storage.read("customers").toString();
      return data;
    }
    return null;
  }

  String? readReceiptsData() {
    if (storage.hasData("operations")) {
      String data = storage.read("operations").toString();
      return data;
    }
    return null;
  }

  String? readOptionsData() {
    if (storage.hasData("options")) {
      String data = storage.read("options").toString();
      return data;
    }
    return null;
  }

  Map loadLastId() {
    if (storage.hasData("lastOperations")) {
      Map data = json.decode(storage.read("lastOperations") ?? "");
      return data;
    } else {
      return {};
    }
  }

  String? readInfoData() {
    if (storage.hasData("info")) {
      String data = storage.read("info").toString();
      return data;
    }
    return null;
  }
}
