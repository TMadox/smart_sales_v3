import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';

class OperationsController extends GetxController {
  Map currentReceipt = {"totalProducts": 0};
  List selectedItems = [];
  final Rx<List<Map>> operations = Rx<List<Map>>([]);
  List<Map> receiptItems = [];

  void loadOperations() {
    operations.value = ReadData().readOperations();
  }

  Map loadLastOperations() {
    return Map.from(json.decode(GetStorage().read("lastOperations") ?? "{}"));
  }
}
