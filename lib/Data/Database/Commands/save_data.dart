import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/power_model.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';

class SaveData {
  final GetStorage box = GetStorage();
  Future<void> saveItemsData({required List<ItemsModel> input}) async {
    await box.write("items", itemsJsonFromList(data: input).toString());
  }

  Future<void> saveCustomersData({required List<ClientsModel> input}) async {
    await box.write("customers", customersJsonFromList(data: input));
  }

  Future<void> saveReceiptsData(
      {required List<Map> input, required BuildContext context}) async {
    await box.write("receipts", json.encode(input));
    await box.write(
        "lastReceipt", json.encode(context.read<GeneralState>().finalReceipts));
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

  saveFinalReceipts(BuildContext context) async {
    await box.write(
        "lastReceipt", json.encode(context.read<GeneralState>().finalReceipts));
  }
}
