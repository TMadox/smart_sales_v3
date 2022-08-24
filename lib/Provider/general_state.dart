import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:smart_sales/Data/Models/location_model.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/get_location.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/Provider/customers_state.dart';


class GeneralState extends ChangeNotifier {
  Map currentReceipt = {"totalProducts": 0};
  List<Map> receiptItems = [];
  List<Map> receiptsList = [];
  Map finalReceipts = {};
  bool editReceipt = false;
  bool isUploading = false;

  set uploading(bool input) {
    isUploading = input;
  }

  void setEditReceipt(bool input) {
    editReceipt = input;
    notifyListeners();
  }

  void setFirstOperId({required String key, required int id}) {
    finalReceipts[key] = {"oper_id": id};
  }

  void setfinalReceipts(Map input) {
    finalReceipts = input;
  }

  void setCurrentReceipt({required Map input}) {
    currentReceipt = Map.from(input);
    receiptItems.clear();
    notifyListeners();
  }

  void setRemainingQty() {
    Map parent = {};
    if (currentReceipt["section_type_no"] == 2) {
      parent = receiptsList.firstWhere(
        (element) => (element["oper_code"] == currentReceipt["parent_id"] &&
            (element["section_type_no"] == 1)),
      );
    } else {
      parent = receiptsList.firstWhere(
        (element) => (element["oper_code"] == currentReceipt["parent_id"] &&
            (element["section_type_no"] == 3)),
      );
    }
    List products = json.decode(parent["products"]);
    for (var element in products) {
      element["qty_remain"] = element["qty_remain"] -
          receiptItems[products.indexOf(element)]["fat_qty"];
      element["free_qty_remain"] = element["free_qty_remain"] -
          receiptItems[products.indexOf(element)]["free_qty"];
    }
    parent["products"] = json.encode(products);
  }

  void addToReceipts() {
    receiptsList.add(currentReceipt);
  }

  Future<void> computeReceipt({required BuildContext context}) async {
    LocationModel locationData = await getLocationData();
    if (currentReceipt["section_type_no"] == 9999) {
      currentReceipt.addAll(
        {
          "products": json.encode(receiptItems),
          "location_code": locationData.locationCode,
          "location_name": locationData.locationName,
          "credit_after": 0.0,
          "saved": 1,
        },
      );
    } else if (currentReceipt["section_type_no"] == 101 ||
        currentReceipt["section_type_no"] == 102 ||
        currentReceipt["section_type_no"] == 108 ||
        currentReceipt["section_type_no"] == 107 ||
        currentReceipt["section_type_no"] == 103 ||
        currentReceipt["section_type_no"] == 104) {
      currentReceipt["oper_value"] = currentReceipt["cash_value"];
      currentReceipt["reside_value"] = currentReceipt["cash_value"];
      currentReceipt["oper_net_value"] = currentReceipt["cash_value"];
      num creditAfter = await editCustomers(context: context);
      currentReceipt.addAll({
        "products": json.encode(receiptItems),
        "location_code": locationData.locationCode,
        "location_name": locationData.locationName,
        "credit_after": creditAfter,
        "extend_time_2": DateTime.now().toString(),
        "saved": 1,
      });
    } else if (currentReceipt["section_type_no"] == 98) {
      for (var element in receiptItems) {
        element.remove("fat_qty_controller");
        element.remove("fat_disc_value_controller");
        element.remove("free_qty_controller");
        element.remove("fat_price_controller");
        context.read<ItemsViewmodel>().editItemQty(
              id: element["unit_id"],
              qty: element["fat_qty"],
              unitMulti: element["unit_convert"],
              sectionTypeNo: currentReceipt["section_type_no"],
            );
      }
      currentReceipt.addAll({
        "products": json.encode(receiptItems),
        "location_code": locationData.locationCode,
        "location_name": locationData.locationName,
        "credit_after": 0.0,
        "extend_time_2": DateTime.now().toString(),
        "saved": 1,
      });
    } else {
      for (var element in receiptItems) {
        element.remove("fat_qty_controller");
        element.remove("fat_disc_value_controller");
        element.remove("free_qty_controller");
        element.remove("fat_price_controller");
        if (currentReceipt["saved"] == 0) {
          element["qty_remain"] = element["fat_qty"];
          element["free_qty_remain"] = element["free_qty"];
        }
        context.read<ItemsViewmodel>().editItemQty(
              id: element["unit_id"],
              qty: element["fat_qty"],
              unitMulti: element["unit_convert"],
              sectionTypeNo: currentReceipt["section_type_no"],
            );
        element["original_fat_value"] = element["fat_value"];
        if (currentReceipt["use_tax_system"] == 1 &&
            currentReceipt["use_price_with_tax"] == 1) {
          element["fat_value"] =
              element["fat_value"] / (1 + (element["tax_per"] / 100));
          element["fat_disc_value"] = element["fat_disc_value_with_tax"] /
              (1 + (element["tax_per"] / 100));
          element["fat_price_with_tax"] = element["original_price"];
          element["fat_price"] =
              element["fat_price_with_tax"] / (1 + (element["tax_per"] / 100));
        } else {
          element["fat_disc_value"] = element["fat_disc_value_with_tax"];
          element["fat_price"] = element["original_price"];
          element["fat_price_with_tax"] =
              element["fat_price"] * (1 + (element["tax_per"] / 100));
        }

        element["fat_value_with_tax"] =
            element["fat_value"] + element["fat_add_value"];
        element["fat_net_value"] = ValuesManager.checkNum(
            element["fat_net_value"] / (1 + (element["tax_per"] / 100)));
        element["fat_disc_per"] = ValuesManager.checkNum(
            (element["fat_disc_value"] /
                    (element["fat_disc_value"] + element["fat_value"])) /
                (1 + (element["tax_per"] / 100)));
      }
      currentReceipt["oper_add_value_with_tax"] =
          currentReceipt["oper_add_value"];
      currentReceipt["oper_disc_value_with_tax"] =
          currentReceipt["oper_disc_value"];
      currentReceipt["original_oper_value"] = currentReceipt["oper_value"];
      if (currentReceipt["use_tax_system"] == 1 &&
          currentReceipt["use_price_with_tax"] == 1) {
        final num ratio = ValuesManager.checkNum((currentReceipt["oper_value"] /
            (currentReceipt["oper_value"] + currentReceipt["total_tax"])));
        currentReceipt["oper_add_value"] =
            currentReceipt["oper_add_value_with_tax"] * ratio;
        currentReceipt["oper_disc_value"] =
            currentReceipt["oper_disc_value_with_tax"] * ratio;
      }
      if (currentReceipt["use_tax_system"] == 1 &&
          currentReceipt["use_price_with_tax"] == 1) {
        currentReceipt["oper_net_value"] =
            currentReceipt["oper_net_value_with_tax"] -
                currentReceipt["tax_value"];
        currentReceipt["oper_value"] = ValuesManager.checkNum(
            currentReceipt["oper_net_value_with_tax"] -
                currentReceipt["tax_value"] +
                (currentReceipt["oper_disc_value"] /
                    (1 + (currentReceipt["tax_per"] / 100))) -
                (currentReceipt["oper_add_value"] /
                    (1 + (currentReceipt["tax_per"] / 100))));
      }
      currentReceipt.addAll({
        "products": json.encode(receiptItems),
        "location_code": locationData.locationCode,
        "location_name": locationData.locationName,
        "credit_after": await editCustomers(context: context),
        "extend_time_2": DateTime.now().toString(),
        "saved": 1,
      });
    }
    if (currentReceipt["oper_id"] >= 999999) {
      finalReceipts[currentReceipt["section_type_no"].toString()] = null;
    } else {
      finalReceipts[currentReceipt["section_type_no"].toString()] =
          Map.from(currentReceipt);
    }
    addToReceipts();
    await locator.get<SaveData>().saveReceiptsData(
          input: receiptsList,
          context: context,
        );
    receiptItems = [];
    currentReceipt = {};
    notifyListeners();
  }

  void fillReceiptsList({required List<Map> input}) {
    receiptsList = List.from(input);
  }

  void addNotes(String input) {
    currentReceipt.addAll({"notes": input});
  }

  void fillReceiptWithItems(
      {required List<Map> input, bool addController = true}) {
    receiptItems.addAll(input);
    for (var i = 0; i < receiptItems.length; i++) {
      if (addController) {
        receiptItems[i]["fat_qty_controller"] =
            TextEditingController(text: receiptItems[i]["fat_qty"].toString());
        receiptItems[i]["fat_disc_value_controller"] = TextEditingController(
            text: receiptItems[i]["fat_disc_value"].toString());
        receiptItems[i]["free_qty_controller"] =
            TextEditingController(text: receiptItems[i]["free_qty"].toString());
        receiptItems[i]["fat_price_controller"] = TextEditingController(
            text: receiptItems[i]["original_price"].toString());
      } else {
        receiptItems[i]["fat_qty_controller"] =
            TextEditingController(text: 0.toString());
        receiptItems[i]["free_qty_controller"] =
            TextEditingController(text: 0.toString());
      }
      calculateItemPrices(item: receiptItems[i]);
    }
    calculateReceiptNetValues();
    notifyListeners();
  }

  addItem({required Map item}) {
    receiptItems.add(item);
    calculateItemPrices(item: item);
    calculateReceiptNetValues();
    notifyListeners();
  }

  void removeFromListReceiptItems({required List inputs}) {
    for (var element in inputs) {
      receiptItems.remove(element);
    }
    calculateReceiptNetValues();
    notifyListeners();
  }

  void changeItemValue({
    required Map item,
    required Map input,
  }) {
    receiptItems[receiptItems.indexOf(item)]
        .update(input.keys.first, (value) => input.values.first);
    calculateItemPrices(item: item);
    calculateReceiptNetValues();
    notifyListeners();
  }

  void calculateItemPrices({required Map item}) {
    double itemTotal = (item["original_price"] * item["fat_qty"]) -
        item["fat_disc_value_with_tax"];
    if (currentReceipt["saved"] == 1) {
      if ((item["qty_remain"] < item["fat_qty"]) ||
          (item["free_qty_remain"] < item["free_qty"])) {
        throw "لا يمكن تقليل الكمية الي اقل من الكمية المتاحة";
      }
    }

    if (currentReceipt["allow_sell_qty_less_zero"] == false &&
        currentReceipt["section_type_no"] != 98) {
      bool test = (double.parse(
                item["original_qty"].toString(),
              ) -
              double.parse(
                item["fat_qty"].toString(),
              )) <
          0;
      if (test) {
        throw "لأ يمكن الاتمام لان الكمية اقل من صفر";
      }
    }
    item["original_qty_after"] = item["original_qty"] - item["fat_qty"];
    double total = 0;
    for (var element in receiptItems) {
      total = total +
          ((element["original_price"] * element["fat_qty"]) -
              element["fat_disc_value"]);
    }
    if (shouldCheckLeastPrice(element: item)) {
      if (currentReceipt["use_tax_system"] == 1 &&
          currentReceipt["use_price_with_tax"] == 1) {
        if ((getNetPrice(
                  item: item,
                  itemTotal: itemTotal,
                  total: total,
                ) *
                (1 + (item["tax_per"] / 100))) <
            item["least_selling_price_with_tax"]) {
          if (item["fat_qty"] != 0) {
            throw "السعر اقل من السعر المسموح";
          }
        }
      }
    }
    item["fat_net_price"] = getNetPrice(
      item: item,
      itemTotal: itemTotal,
      total: total,
    );
    item["fat_value"] = itemTotal;
    item["fat_net_value"] = ValuesManager.checkNum(itemTotal *
        ((total +
                currentReceipt["oper_add_value"] -
                currentReceipt["oper_disc_value"]) /
            total));
    if (item["tax_per"] != 0.0) {
      if (currentReceipt["use_tax_system"] == 1 &&
          currentReceipt["use_price_with_tax"] == 0) {
        item["fat_add_value"] = ValuesManager.checkNum(
            item["fat_net_value"] * (item["tax_per"] / 100));
      } else if (currentReceipt["use_tax_system"] == 1 &&
          currentReceipt["use_price_with_tax"] == 1) {
        item["fat_add_value"] = ValuesManager.checkNum(
            (item["fat_net_value"] * item["tax_per"]) /
                (item["tax_per"] + 100));
      }
    }
    if (item["fat_disc_value"] != 0) {
      item["fat_disc_per"] = ValuesManager.checkNum(
          100.0 * (item["fat_disc_value"] / item["fat_value"]));
    }
    if (currentReceipt["use_price_with_tax"] == 1) {
      item["fat_price_with_tax"] =
          ValuesManager.checkNum(item["fat_add_value"] / item["fat_qty"]);
    }
  }

  changeReceiptValue({
    required Map input,
  }) {
    currentReceipt.addAll(input);
    calculateReceiptNetValues();
    notifyListeners();
  }

  void calculateReceiptNetValues() {
    double total = receiptItems.fold<double>(
      0,
      (double sum, item) => (sum + item["fat_value"]),
    );
    for (var element in receiptItems) {
      if (shouldCheckLeastPrice(element: element)) {
        final double sellingPrice = getNetPrice(
              item: element,
              itemTotal: element["fat_value"],
              total: total,
            ) *
            (1 + (element["tax_per"] / 100));
        if ((sellingPrice < element["least_selling_price_with_tax"])) {
          if (element["fat_qty"] != 0) {
            throw "لا يمكن تقليل السعر الي اقل من السعر المسموح";
          }
        }
      }
      element["fat_net_price"] = getNetPrice(
        item: element,
        itemTotal: element["fat_value"],
        total: total,
      );
      element["fat_net_value"] = ValuesManager.checkNum(element["fat_value"] *
          ((total +
                  currentReceipt["oper_add_value"] -
                  currentReceipt["oper_disc_value"]) /
              total));
    }
    currentReceipt["items_count"] = receiptItems.fold<double>(
        0, (double sum, item) => (sum + item["fat_qty"]));
    currentReceipt["oper_value"] = total;
    currentReceipt["oper_net_value"] = total -
        currentReceipt["oper_disc_value"] +
        currentReceipt["oper_add_value"];
    //calculate discount percentage
    if (currentReceipt["oper_disc_value"] != 0) {
      currentReceipt["oper_disc_per"] = ValuesManager.checkNum(100.0 *
          (currentReceipt["oper_disc_value"] / currentReceipt["oper_value"]));
    }
    //calculate add percentage
    if (currentReceipt["oper_add_value"] != 0) {
      currentReceipt["oper_add_per"] = ValuesManager.checkNum(100.0 *
          (currentReceipt["oper_add_value"] / currentReceipt["oper_value"]));
    }
    if (currentReceipt["use_tax_system"] == 1 &&
        currentReceipt["use_price_with_tax"] == 0) {
      //first we get taxestotal out of all the products
      double taxesTotal = receiptItems.fold<double>(
          0, (double sum, item) => (sum + item["fat_add_value"]));
      currentReceipt["total_tax"] = taxesTotal;
      // we run calculations to set the tax value of the whole receipt
      currentReceipt["tax_value"] = ValuesManager.checkNum(taxesTotal *
          (currentReceipt["oper_net_value"] / currentReceipt["oper_value"]));
      //then we set the total value of the receipt
      currentReceipt["oper_net_value_with_tax"] =
          currentReceipt["oper_net_value"] + currentReceipt["tax_value"];
      //if the tax value is not 0, we calculate tax percentage.
      if (currentReceipt["tax_value"] != 0) {
        currentReceipt["tax_per"] =
            100 * (currentReceipt["tax_value"] / currentReceipt["oper_value"]);
        if (currentReceipt["tax_per"] == double.infinity) {
          currentReceipt["tax_per"] = 0.0;
        }
      }
    } else if (currentReceipt["use_tax_system"] == 1 &&
        currentReceipt["use_price_with_tax"] == 1) {
      //first we get taxestotal out of all the products
      double taxesTotal = receiptItems.fold<double>(
          0, (double sum, item) => (sum + item["fat_add_value"]));
      currentReceipt["total_tax"] = taxesTotal;
      // we run calculations to set the tax value of the whole receipt
      currentReceipt["tax_value"] = ValuesManager.checkNum(taxesTotal *
          (currentReceipt["oper_net_value"] / currentReceipt["oper_value"]));
      //then we set the total value of the receipt
      currentReceipt["oper_net_value_with_tax"] =
          currentReceipt["oper_net_value"];
      //if the tax value is not 0, we calculate tax percentage.
      if (currentReceipt["tax_value"] != 0) {
        currentReceipt["tax_per"] = ValuesManager.checkNum(100.0 *
            (currentReceipt["tax_value"] / currentReceipt["oper_value"]));
      }
    } else {
      currentReceipt["oper_net_value_with_tax"] =
          currentReceipt["oper_net_value"];
    }

    if (currentReceipt["section_type_no"] == 101 ||
        currentReceipt["section_type_no"] == 102 ||
        currentReceipt["section_type_no"] == 108 ||
        currentReceipt["section_type_no"] == 107 ||
        currentReceipt["section_type_no"] == 103 ||
        currentReceipt["section_type_no"] == 104) {
      currentReceipt["reside_value"] = currentReceipt["cash_value"];
    } else {
      currentReceipt["reside_value"] =
          currentReceipt["oper_net_value_with_tax"] -
              currentReceipt["cash_value"];
    }

    currentReceipt["credit_after"] = calculateCreditAfter();
  }

  setReceiptsUploaded({required int index, required int code}) {
    Map receipt = receiptsList[index];
    receipt["is_sender_complete_status"] = 1;
    receipt["upload_code"] = code;
    receiptsList[index] = receipt;
    notifyListeners();
  }

  deleteReceipt({required Map receipt}) {
    receiptsList.remove(receipt);
  }

  removeLastItem() {
    receiptItems.removeLast();
    notifyListeners();
  }

  getNetPrice(
      {required Map item, required double itemTotal, required double total}) {
    if (currentReceipt["use_tax_system"] == 1 &&
        currentReceipt["use_price_with_tax"] == 1) {
      return ValuesManager.checkNum(((itemTotal *
                      ((total +
                              currentReceipt["oper_add_value"] -
                              currentReceipt["oper_disc_value"]) /
                          total)) /
                  item["fat_qty"] +
              item["free_qty"]) /
          (1 + (item["tax_per"] * 0.01)));
    } else {
      return ValuesManager.checkNum((itemTotal *
                  ((total +
                          currentReceipt["oper_add_value"] -
                          currentReceipt["oper_disc_value"]) /
                      total)) /
              item["fat_qty"] +
          item["free_qty"]);
    }
  }

  num calculateCreditAfter() {
    num creditBefore = currentReceipt["credit_before"];
    num resideValue = currentReceipt["reside_value"];
    int sectionNo = currentReceipt["section_type_no"];
    switch (sectionNo) {
      case 2:
      case 3:
      case 104:
      case 101:
      case 108:
      case 17:
      case 18:
        return creditBefore - resideValue;
      case 1:
      case 4:
      case 103:
      case 102:
      case 51:
      case 107:
        return creditBefore + resideValue;
      default:
        return creditBefore;
    }
  }

  bool shouldCheckLeastPrice({required Map element}) {
    return element["can_sell_with_lower_price"] == false &&
        currentReceipt["section_type_no"] != 98 &&
        (currentReceipt["section_type_no"] != 3 &&
            currentReceipt["section_type_no"] != 4);
  }

  Future<num> editCustomers({
    required BuildContext context,
  }) async {
    double creditAfter = 0;
    if (currentReceipt["section_type_no"] == 3 ||
        currentReceipt["section_type_no"] == 4 ||
        currentReceipt["section_type_no"] == 103 ||
        currentReceipt["section_type_no"] == 104) {
      creditAfter = await context.read<MowState>().editMows(
            id: currentReceipt["basic_acc_id"],
            amount: currentReceipt["reside_value"] ?? 0.0,
            sectionType: currentReceipt["section_type_no"],
          );
    } else if (currentReceipt["section_type_no"] == 108 ||
        currentReceipt["section_type_no"] == 107) {
      creditAfter = await context.read<ExpenseState>().editExpenses(
            id: currentReceipt["basic_acc_id"],
            amount: currentReceipt["reside_value"] ?? 0.0,
            sectionType: currentReceipt["section_type_no"],
          );
    } else if (currentReceipt["section_type_no"] == 17 ||
        currentReceipt["section_type_no"] == 18) {
      creditAfter = currentReceipt["credit_before"] -
          currentReceipt["oper_net_value_with_tax"];
    } else if (currentReceipt["section_type_no"] == 2 ||
        currentReceipt["section_type_no"] == 1 ||
        currentReceipt["section_type_no"] == 101 ||
        currentReceipt["section_type_no"] == 102 ||
        currentReceipt["section_type_no"] == 51) {
      creditAfter = await context.read<CustomersState>().editCustomer(
            id: currentReceipt["basic_acc_id"],
            amount: currentReceipt["reside_value"],
            sectionType: currentReceipt["section_type_no"],
          );
    }
    return ValuesManager.checkNum(creditAfter);
  }
}
