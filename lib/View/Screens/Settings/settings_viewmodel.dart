import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';

class SettingsViewmodel extends ChangeNotifier {
  bool isLoading = false;
  final SharedPreferences storage = locator.get<SharedStorage>().prefs;
  List<String> headers = [];
  List<String> cells = [];
  final List<String> favoritesOptions = [
    "sales_receipt",
    "return_receipt",
    "purchase_receipt",
    "purchase_return_receipt",
    "selling_order",
    "purchase_order",
    "seizure_document",
    "payment_document",
    "mow_seizure_document",
    "mow_payment_document",
    "expenses_seizure_document",
    "inventory",
    "cashier_receipt",
    "expenses_document",
    "items",
    "view_operations",
    "clients",
    "stors",
    "kinds",
    "expenses",
    "mows",
    "groups",
    "stor_transfer",
    "new_rec",
  ];
  void getStoredPrintingData() {
    headers = storage.getStringList("headers") ??
        [
          "number",
          "date",
          "employee",
          "customer",
          "tax",
        ];
    cells = storage.getStringList("cells") ??
        [
          "value",
          "price",
          "discount",
          "free_qty",
          "qty",
          "unit",
          "item",
          "number",
        ].reversed.toList();
  }

  Future<void> saveNewDate() async {
    await storage.setStringList("headers", headers);
    await storage.setStringList("cells", cells);
  }

  void switchHeaderPosition({
    required int oldIndex,
    required int newIndex,
  }) {
    final index = (newIndex > oldIndex) ? newIndex - 1 : newIndex;
    final header = headers.removeAt(oldIndex);
    headers.insert(index, header);
    notifyListeners();
  }

  void switchCellPosition({
    required int oldIndex,
    required int newIndex,
  }) {
    final index = (newIndex > oldIndex) ? newIndex - 1 : newIndex;
    final cell = cells.removeAt(oldIndex);
    cells.insert(index, cell);
    notifyListeners();
  }

  List<String> filterOptions({required List<String> input}) {
    final List<String> temp = List.from(favoritesOptions);
    return temp.where((element) => input.contains(element) == false).toList();
  }
}
