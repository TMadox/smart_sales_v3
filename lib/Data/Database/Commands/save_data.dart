import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/power_model.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';

class SaveData {
  final SharedPreferences box = locator.get<SharedStorage>().prefs;
  Future<void> saveItemsData({required List<ItemsModel> input}) async {
    await box.setString("items", itemsJsonFromList(data: input).toString());
  }

  Future<void> saveCustomersData({required List<ClientsModel> input}) async {
    await box.setString("customers", customersJsonFromList(data: input));
  }

  Future<void> saveReceiptsData(
      {required List<Map> input, required BuildContext context}) async {
    await box.setString("receipts", json.encode(input));
    await box.setString(
        "lastReceipt", json.encode(context.read<GeneralState>().finalReceipts));
  }

  Future<void> saveOptionsData({required List<OptionsModel> input}) async {
    await box.setString("options", optionsJsonFromList(data: input));
  }

  Future<void> saveInfoData({required InfoModel info}) async {
    await box.setString("info", infoModelToMap(info));
  }

  Future<void> savePowersInfo({required List<PowersModel> powers}) async {
    await box.setString("user_powers", powersModelToMap(powers));
  }

  saveFinalReceipts(BuildContext context) async {
    await box.setString(
        "lastReceipt", json.encode(context.read<GeneralState>().finalReceipts));
  }
}
