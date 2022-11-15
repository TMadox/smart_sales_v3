import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class SettingsViewmodel extends ChangeNotifier {
  bool isLoading = false;
  final GetStorage storage = GetStorage();
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
    headers = storage.read("headers") ??
        [
          "number",
          "date",
          "employee",
          "customer",
          "tax",
        ];
    cells = storage.read("cells") ??
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
    await storage.write("headers", headers);
    await storage.write("cells", cells);
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
