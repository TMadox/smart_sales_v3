import 'dart:convert';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';

class ReadData {
  final box = locator.get<SharedStorage>().prefs;
  String? readItemsData() {
    if (box.containsKey("items")) {
      String data = box.getString("items").toString();
      return data;
    }
    return null;
  }

  String? readCustomersData() {
    if (box.containsKey("customers")) {
      String data = box.getString("customers").toString();
      return data;
    }
    return null;
  }

  String? readReceiptsData() {
    if (box.containsKey("receipts")) {
      String data = box.getString("receipts").toString();
      return data;
    }
    return null;
  }

  String? readOptionsData() {
    if (box.containsKey("options")) {
      String data = box.getString("options").toString();
      return data;
    }
    return null;
  }

  Map loadLastId() {
    if (box.containsKey("lastReceipt")) {
      Map data = json.decode(box.getString("lastReceipt").toString());
      return data;
    } else {
      return {};
    }
  }

  String? readInfoData() {
    if (box.containsKey("info")) {
      String data = box.getString("info").toString();
      return data;
    }
    return null;
  }

}
