import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class ReadData {
  final storage = GetStorage();
  // String? readItemsData() {
  //   if (box.hasData("items")) {
  //     String data = box.read("items").toString();
  //     return data;
  //   }
  //   return null;
  // }

  String? readCustomersData() {
    if (storage.hasData("customers")) {
      String data = storage.read("customers").toString();
      return data;
    }
    return null;
  }

  String? readReceiptsData() {
    if (storage.hasData("receipts")) {
      String data = storage.read("receipts").toString();
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
    if (storage.hasData("lastReceipt")) {
      Map data = json.decode(storage.read("lastReceipt").toString());
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
