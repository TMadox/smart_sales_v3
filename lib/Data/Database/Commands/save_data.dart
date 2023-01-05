import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/power_model.dart';

class SaveData {
  final GetStorage box = GetStorage();
  Future<void> saveItemsData({required List<ItemsModel> input}) async {
    await box.write("items", itemsJsonFromList(data: input).toString());
  }

  Future<void> saveCustomersData({required List<Client> input}) async {
    await box.write("customers", customersJsonFromList(data: input));
  }

  Future<void> saveOperationsData({
    required List<Map> operations,
    Map? lastOperations,
  }) async {
    await box.write("operations", json.encode(operations));
    if (lastOperations != null) {
      await box.write("lastOperations", json.encode(lastOperations));
    }
  }

  Future<void> saveRecyclePin({
    required List<Map> recycledOperations,
  }) async {
    await box.write("recycle", json.encode(recycledOperations));
  }

  Future<void> saveOptionsData({required List<OptionsModel> input}) async {
    await box.write("options", optionsJsonFromList(data: input));
  }

  Future<void> saveInfoData({required InfoModel info}) async {
    await box.write("info", infoModelToMap(info));
  }

  Future<void> savePowersInfo({required List<PowersModel> powers}) async {
    await box.write("user_powers", powersModelToMap(powers));
  }
}
