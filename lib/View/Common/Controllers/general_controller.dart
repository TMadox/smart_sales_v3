import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/get_location.dart';
import 'package:smart_sales/App/Util/select_cst_class.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/location_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Features/init_receipt.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';

class GeneralController {
  Rx<Map> currentReceipt = Rx<Map>({"totalProducts": 0});
  Rx<List<Map>> receiptItems = Rx<List<Map>>([]);
  Rx<List<Map>> selectedItems = Rx<List<Map>>([]);
  Entity? selectedEntity;

  void startReceipt({
    required Entity entity,
    required BuildContext context,
    required int sectionTypeNo,
    required int? selectedStorId,
    required bool resetReceipt,
  }) {
    if (resetReceipt) {
      currentReceipt.update(
        (val) {
          val!.addAll(
            InitReceipt().build(
              entity: entity,
              context: context,
              sectionTypeNo: sectionTypeNo,
              selectedStorId: selectedStorId,
            ),
          );
        },
      );
      receiptItems.update((val) {
        val!.clear();
      });
    }
    selectedEntity = entity;
    selectedItems.update((val) {
      val!.clear();
    });
  }

  void setReceipt(Map input) {
    currentReceipt.update((val) {
      val!.addAll(input);
    });
  }

  void removeLastItem() {
    receiptItems.value.removeLast();
  }

  Future<void> deleteItems({required BuildContext context}) async {
    for (var item in selectedItems.value) {
      receiptItems.value.remove(item);
    }
    selectedItems.update((val) {
      val!.clear();
    });
    receiptItems.refresh();
    calculateReceiptNetValues();
  }

  Future<void> computeReceipt(BuildContext context) async {
    LocationModel locationData = await getLocationData();
    if (currentReceipt.value["section_type_no"] == 98) {
      for (var element in receiptItems.value) {
        element.remove("fat_qty_controller");
        element.remove("fat_disc_value_controller");
        element.remove("free_qty_controller");
        element.remove("fat_price_controller");
        context.read<ItemsViewmodel>().editItemQty(
              id: element["unit_id"],
              qty: element["fat_qty"],
              unitMulti: element["unit_convert"],
              storId: currentReceipt.value["selected_stor_id"] ??
                  context.read<UserState>().user.defStorId,
              sectionTypeNo: currentReceipt.value["section_type_no"],
            );
      }
      currentReceipt.value.addAll({
        "products": json.encode(receiptItems.value),
        "location_code": locationData.locationCode,
        "location_name": locationData.locationName,
        "credit_after": 0.0,
        "extend_time_2": DateTime.now().toString(),
        "saved": 1,
      });
    } else {
      for (var element in receiptItems.value) {
        element.remove("fat_qty_controller");
        element.remove("fat_disc_value_controller");
        element.remove("free_qty_controller");
        element.remove("fat_price_controller");
        if (currentReceipt.value["saved"] == 0) {
          element["qty_remain"] = element["fat_qty"];
          element["free_qty_remain"] = element["free_qty"];
        }
        context.read<ItemsViewmodel>().editItemQty(
              id: element["unit_id"],
              qty: element["fat_qty"],
              unitMulti: element["unit_convert"],
              inStorId: currentReceipt.value["in_stor_id"],
              sectionTypeNo: currentReceipt.value["section_type_no"],
              storId: currentReceipt.value["selected_stor_id"] ??
                  context.read<UserState>().user.defStorId,
            );
        element["original_fat_value"] = element["fat_value"];
        if (currentReceipt.value["use_tax_system"] == 1 &&
            currentReceipt.value["use_price_with_tax"] == 1) {
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
      currentReceipt.value["oper_add_value_with_tax"] =
          currentReceipt.value["oper_add_value"];
      currentReceipt.value["oper_disc_value_with_tax"] =
          currentReceipt.value["oper_disc_value"];
      currentReceipt.value["original_oper_value"] =
          currentReceipt.value["oper_value"];
      if (currentReceipt.value["use_tax_system"] == 1 &&
          currentReceipt.value["use_price_with_tax"] == 1) {
        final num ratio = ValuesManager.checkNum(
            (currentReceipt.value["oper_value"] /
                (currentReceipt.value["oper_value"] +
                    currentReceipt.value["total_tax"])));
        currentReceipt.value["oper_add_value"] =
            currentReceipt.value["oper_add_value_with_tax"] * ratio;
        currentReceipt.value["oper_disc_value"] =
            currentReceipt.value["oper_disc_value_with_tax"] * ratio;
      }
      if (currentReceipt.value["use_tax_system"] == 1 &&
          currentReceipt.value["use_price_with_tax"] == 1) {
        currentReceipt.value["oper_net_value"] =
            currentReceipt.value["oper_net_value_with_tax"] -
                currentReceipt.value["tax_value"];
        currentReceipt.value["oper_value"] = ValuesManager.checkNum(
            currentReceipt.value["oper_net_value_with_tax"] -
                currentReceipt.value["tax_value"] +
                (currentReceipt.value["oper_disc_value"] /
                    (1 + (currentReceipt.value["tax_per"] / 100))) -
                (currentReceipt.value["oper_add_value"] /
                    (1 + (currentReceipt.value["tax_per"] / 100))));
      }
      if (currentReceipt.value["section_type_no"] == 31) {
        currentReceipt.value["saraf_acc_id"] =
            context.read<UserState>().user.defSarafAccId;
        currentReceipt.value["saraf_cash_value"] =
            currentReceipt.value["saraf_cash_value"] ?? 0.0;
      }
      currentReceipt.value.remove("entity");
      currentReceipt.value.addAll(
        {
          "products": json.encode(receiptItems.value),
          "location_code": locationData.locationCode,
          "location_name": locationData.locationName,
          "credit_after": await editCustomers(context: context),
          "extend_time_2": DateTime.now().toString(),
          "saved": 1,
        },
      );
    }
    final List<Map> operations = ReadData().readOperations();
    final Map lastOperations = ReadData().readLastOperations();
    if (currentReceipt.value["section_type_no"] != 31 &&
        currentReceipt.value["parent_id"] != null) {
      setRemainingQty(operations);
    }
    operations.add(currentReceipt.value);
    if (currentReceipt.value["oper_id"] >= 999999) {
      lastOperations[currentReceipt.value["section_type_no"].toString()] = null;
    } else {
      lastOperations[currentReceipt.value["section_type_no"].toString()] =
          currentReceipt.value;
    }
    await SaveData().saveOperationsData(
      operations: operations,
      lastOperations: lastOperations,
    );
  }

  void fillReceiptWithItems(
      {required List<Map> input, bool addController = true}) {
    receiptItems.value.addAll(input);
    for (var i = 0; i < receiptItems.value.length; i++) {
      if (addController) {
        receiptItems.value[i]["fat_qty_controller"] = TextEditingController(
            text: receiptItems.value[i]["fat_qty"].toString());
        receiptItems.value[i]["fat_disc_value_controller"] =
            TextEditingController(
                text: receiptItems.value[i]["fat_disc_value"].toString());
        receiptItems.value[i]["free_qty_controller"] = TextEditingController(
            text: receiptItems.value[i]["free_qty"].toString());
        receiptItems.value[i]["fat_price_controller"] = TextEditingController(
            text: receiptItems.value[i]["original_price"].toString());
      } else {
        receiptItems.value[i]["fat_qty_controller"] =
            TextEditingController(text: 0.toString());
        receiptItems.value[i]["free_qty_controller"] =
            TextEditingController(text: 0.toString());
      }
      calculateItemPrices(item: receiptItems.value[i]);
    }
    calculateReceiptNetValues();
  }

  void editItem({
    required Map item,
    required Map input,
  }) {
    receiptItems.value[receiptItems.value.indexOf(item)]
        .update(input.keys.first, (value) => input.values.first);
    calculateItemPrices(item: item);
    calculateReceiptNetValues();
  }

  changeReceiptValue({
    required Map input,
  }) {
    currentReceipt.value.addAll(input);
    calculateReceiptNetValues();
  }

  void changeValue({
    item,
    required String key,
    required TextEditingController controller,
    value,
  }) {
    if (value != "" && value != ".") {
      editItem(
        item: item,
        input: {key: double.parse(value)},
      );
    } else {
      controller.text = (key == "fat_qty") ? 1.toString() : 0.0.toString();
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.value.text.length,
      );
      editItem(
        item: item,
        input: {key: (key == "fat_qty") ? 1 : 0.0},
      );
    }
  }

  num getNetPrice({
    required Map item,
    required double itemTotal,
    required double total,
  }) {
    if (currentReceipt.value["use_tax_system"] == 1 &&
        currentReceipt.value["use_price_with_tax"] == 1) {
      return ValuesManager.checkNum(((itemTotal *
                      ((total +
                              currentReceipt.value["oper_add_value"] -
                              currentReceipt.value["oper_disc_value"]) /
                          total)) /
                  item["fat_qty"] +
              item["free_qty"]) /
          (1 + (item["tax_per"] * 0.01)));
    } else {
      return ValuesManager.checkNum((itemTotal *
                  ((total +
                          currentReceipt.value["oper_add_value"] -
                          currentReceipt.value["oper_disc_value"]) /
                      total)) /
              item["fat_qty"] +
          item["free_qty"]);
    }
  }

  void calculateItemPrices({required Map item}) {
    double itemTotal = (item["original_price"] * item["fat_qty"]) -
        item["fat_disc_value_with_tax"];
    if (currentReceipt.value["saved"] == 1) {
      if ((item["qty_remain"] < item["fat_qty"]) ||
          (item["free_qty_remain"] < item["free_qty"])) {
        throw "this quantity is bigger than allowed".tr;
      }
    }

    if (currentReceipt.value["allow_sell_qty_less_zero"] == false &&
        currentReceipt.value["section_type_no"] != 98) {
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
    for (var element in receiptItems.value) {
      total = total +
          ((element["original_price"] * element["fat_qty"]) -
              element["fat_disc_value"]);
    }
    if (shouldCheckLeastPrice(element: item)) {
      if (currentReceipt.value["use_tax_system"] == 1 &&
          currentReceipt.value["use_price_with_tax"] == 1) {
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
                currentReceipt.value["oper_add_value"] -
                currentReceipt.value["oper_disc_value"]) /
            total));
    if (item["tax_per"] != 0.0) {
      if (currentReceipt.value["use_tax_system"] == 1 &&
          currentReceipt.value["use_price_with_tax"] == 0) {
        item["fat_add_value"] = ValuesManager.checkNum(
            item["fat_net_value"] * (item["tax_per"] / 100));
      } else if (currentReceipt.value["use_tax_system"] == 1 &&
          currentReceipt.value["use_price_with_tax"] == 1) {
        item["fat_add_value"] = ValuesManager.checkNum(
            (item["fat_net_value"] * item["tax_per"]) /
                (item["tax_per"] + 100));
      }
    }
    if (item["fat_disc_value"] != 0) {
      item["fat_disc_per"] = ValuesManager.checkNum(
          100.0 * (item["fat_disc_value"] / item["fat_value"]));
    }
    if (currentReceipt.value["use_price_with_tax"] == 1) {
      item["fat_price_with_tax"] =
          ValuesManager.checkNum(item["fat_add_value"] / item["fat_qty"]);
    }
  }

  bool shouldCheckLeastPrice({required Map element}) {
    return element["can_sell_with_lower_price"] == false &&
        currentReceipt.value["section_type_no"] != 98 &&
        (currentReceipt.value["section_type_no"] != 3 &&
            currentReceipt.value["section_type_no"] != 4);
  }

  void setRemainingQty(List<Map> operations) {
    Map parent = {};
    if (currentReceipt.value["section_type_no"] == 2) {
      parent = operations.firstWhere(
        (element) =>
            (element["oper_code"] == currentReceipt.value["parent_id"] &&
                (element["section_type_no"] == 1)),
      );
    } else {
      parent = operations.firstWhere(
        (element) =>
            (element["oper_code"] == currentReceipt.value["parent_id"] &&
                (element["section_type_no"] == 3)),
      );
    }
    List products = json.decode(parent["products"]);
    for (var element in products) {
      element["qty_remain"] = element["qty_remain"] -
          receiptItems.value[products.indexOf(element)]["fat_qty"];
      element["free_qty_remain"] = element["free_qty_remain"] -
          receiptItems.value[products.indexOf(element)]["free_qty"];
    }
    parent["products"] = json.encode(products);
  }

  Future<num> editCustomers({
    required BuildContext context,
  }) async {
    double creditAfter = 0;
    if (currentReceipt.value["section_type_no"] == 3 ||
        currentReceipt.value["section_type_no"] == 4) {
      creditAfter = await context.read<MowState>().editMows(
            id: currentReceipt.value["basic_acc_id"],
            amount: currentReceipt.value["reside_value"] ?? 0.0,
            sectionType: currentReceipt.value["section_type_no"],
          );
    } else if (currentReceipt.value["section_type_no"] == 17 ||
        currentReceipt.value["section_type_no"] == 18) {
      creditAfter = currentReceipt.value["credit_before"] -
          currentReceipt.value["oper_net_value_with_tax"];
    } else if (currentReceipt.value["section_type_no"] == 2 ||
        currentReceipt.value["section_type_no"] == 1 ||
        currentReceipt.value["section_type_no"] == 31 ||
        currentReceipt.value["section_type_no"] == 51) {
      creditAfter = await context.read<ClientsState>().editCustomer(
            id: currentReceipt.value["basic_acc_id"],
            amount: currentReceipt.value["reside_value"],
            sectionType: currentReceipt.value["section_type_no"],
          );
    }
    return ValuesManager.checkNum(creditAfter);
  }

  void addItem({
    required ItemsModel input,
    required BuildContext context,
    num? qty,
  }) {
    final Map item = {
      "fat_det_id": context.read<ItemsViewmodel>().items.indexOf(input),
      "oper_id": currentReceipt.value["oper_id"],
      "unit_convert": input.unitConvert,
      "unit_name": input.unitName,
      "barcode": input.unitBarcode,
      "fat_item_no": 1,
      "fat_qty": qty ?? 1.0,
      "original_qty": input.curQty,
      "original_qty_after": input.curQty,
      "fat_price": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId),
      "original_price": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId),
      "fat_qty_controller":
          TextEditingController(text: (qty ?? 1.0).toString()),
      "fat_disc_value_controller": TextEditingController(text: 0.0.toString()),
      "free_qty_controller": TextEditingController(text: 0.toString()),
      "fat_price_controller": TextEditingController(
        text: selectedEntity == null
            ? "0.0"
            : selectCstClass(
                context: context,
                item: input,
                customerClass: selectedEntity!.priceId,
              ).toString(),
      ),
      "fat_disc_per": 0.0,
      "fat_disc_value": 0.0,
      "fat_disc_value_with_tax": 0.0,
      "fat_disc_per2": 0.0,
      "fat_disc_value2": 0.0,
      "fat_disc_per3": 0.0,
      "fat_disc_value3": 0.0,
      "fat_add_per": input.taxPer,
      "fat_add_value": 0.0,
      "fat_add_price_value": 0.0,
      "fat_disc_price": 0.0,
      "fat_net_price": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId),
      "fat_value": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId),
      "fat_net_value": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId),
      "fat_profit": 1.0,
      "profit": 1.0,
      "free_qty": 0.0,
      "name": input.itemName,
      "unit_id": input.unitId.toInt(),
      "tax_per": input.taxPer,
      "fat_price_with_tax": selectedEntity == null
          ? 0.0
          : selectCstClass(
              context: context,
              item: input,
              customerClass: selectedEntity!.priceId,
            ),
      "notes": "",
      "can_sell_with_lower_price":
          context.read<PowersState>().canSellWithLowerPrice,
      "least_selling_price": selectedEntity == null
          ? 0.0
          : leastSellingPrice(context: context, item: input),
      "least_selling_price_with_tax": selectedEntity == null
          ? 0.0
          : leastSellingPriceWithoutTax(context: context, item: input)
    };
    receiptItems.update((val) {
      val!.add(item);
    });
    calculateItemPrices(item: item);
    calculateReceiptNetValues();
  }

  double leastSellingPrice({
    required BuildContext context,
    required ItemsModel item,
  }) {
    double per = selectCstPer(
      context: context,
      customerClass: selectedEntity!.priceId,
      item: item,
    );
    if (currentReceipt.value["use_price_with_tax"] == 1) {
      return (item.avPrice + (item.avPrice * (per / 100))) *
          ((item.taxPer / 100) + 1);
    } else {
      return (item.avPrice + (item.avPrice * (per / 100)));
    }
  }

  void calculateReceiptNetValues() {
    double total = receiptItems.value.fold<double>(
      0,
      (double sum, item) => (sum + item["fat_value"]),
    );
    for (var element in receiptItems.value) {
      if (shouldCheckLeastPrice(element: element)) {
        final num sellingPrice = getNetPrice(
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
                  currentReceipt.value["oper_add_value"] -
                  currentReceipt.value["oper_disc_value"]) /
              total));
    }
    currentReceipt.value["items_count"] = receiptItems.value
        .fold<double>(0, (double sum, item) => (sum + item["fat_qty"]));
    currentReceipt.value["free_items_count"] = receiptItems.value
        .fold<double>(0, (double sum, item) => (sum + item["free_qty"]));
    currentReceipt.value["oper_value"] = total;
    currentReceipt.value["oper_net_value"] = total -
        currentReceipt.value["oper_disc_value"] +
        currentReceipt.value["oper_add_value"];
    //calculate discount percentage
    if (currentReceipt.value["oper_disc_value"] != 0) {
      currentReceipt.value["oper_disc_per"] = ValuesManager.checkNum(100.0 *
          (currentReceipt.value["oper_disc_value"] /
              currentReceipt.value["oper_value"]));
    }
    //calculate add percentage
    if (currentReceipt.value["oper_add_value"] != 0) {
      currentReceipt.value["oper_add_per"] = ValuesManager.checkNum(100.0 *
          (currentReceipt.value["oper_add_value"] /
              currentReceipt.value["oper_value"]));
    }
    if (currentReceipt.value["use_tax_system"] == 1 &&
        currentReceipt.value["use_price_with_tax"] == 0) {
      //first we get taxestotal out of all the products
      double taxesTotal = receiptItems.value
          .fold<double>(0, (double sum, item) => (sum + item["fat_add_value"]));
      currentReceipt.value["total_tax"] = taxesTotal;
      // we run calculations to set the tax value of the whole receipt
      currentReceipt.value["tax_value"] = ValuesManager.checkNum(taxesTotal *
          (currentReceipt.value["oper_net_value"] /
              currentReceipt.value["oper_value"]));
      //then we set the total value of the receipt
      currentReceipt.value["oper_net_value_with_tax"] =
          currentReceipt.value["oper_net_value"] +
              currentReceipt.value["tax_value"];
      //if the tax value is not 0, we calculate tax percentage.
      if (currentReceipt.value["tax_value"] != 0) {
        currentReceipt.value["tax_per"] = 100 *
            (currentReceipt.value["tax_value"] /
                currentReceipt.value["oper_value"]);
        if (currentReceipt.value["tax_per"] == double.infinity) {
          currentReceipt.value["tax_per"] = 0.0;
        }
      }
    } else if (currentReceipt.value["use_tax_system"] == 1 &&
        currentReceipt.value["use_price_with_tax"] == 1) {
      //first we get taxestotal out of all the products
      double taxesTotal = receiptItems.value
          .fold<double>(0, (double sum, item) => (sum + item["fat_add_value"]));
      currentReceipt.value["total_tax"] = taxesTotal;
      // we run calculations to set the tax value of the whole receipt
      currentReceipt.value["tax_value"] = ValuesManager.checkNum(taxesTotal *
          (currentReceipt.value["oper_net_value"] /
              currentReceipt.value["oper_value"]));
      //then we set the total value of the receipt
      currentReceipt.value["oper_net_value_with_tax"] =
          currentReceipt.value["oper_net_value"];
      //if the tax value is not 0, we calculate tax percentage.
      if (currentReceipt.value["tax_value"] != 0) {
        currentReceipt.value["tax_per"] = ValuesManager.checkNum(100.0 *
            (currentReceipt.value["tax_value"] /
                currentReceipt.value["oper_value"]));
      }
    } else {
      currentReceipt.value["oper_net_value_with_tax"] =
          currentReceipt.value["oper_net_value"];
    }
    if (currentReceipt.value["section_type_no"] == 31) {
      currentReceipt.value["reside_value"] =
          currentReceipt.value["oper_net_value_with_tax"] -
              ((currentReceipt.value["cash_value"] ?? 0.0) +
                  (currentReceipt.value["saraf_cash_value"] ?? 0.0));
    } else {
      if (currentReceipt.value["pay_by_cash_only"] == 1) {
        currentReceipt.value["cash_value"] =
            currentReceipt.value["oper_net_value_with_tax"];
      }
      currentReceipt.value["reside_value"] =
          currentReceipt.value["oper_net_value_with_tax"] -
              currentReceipt.value["cash_value"];
    }
    currentReceipt.value["credit_after"] = calculateCreditAfter();
    log(currentReceipt.value["credit_after"].toString());
    log(currentReceipt.value["credit_before"].toString());
    currentReceipt.refresh();
  }

  double leastSellingPriceWithoutTax({
    required BuildContext context,
    required ItemsModel item,
  }) {
    double per = selectCstPer(
      context: context,
      customerClass: selectedEntity!.priceId,
      item: item,
    );
    return (item.avPrice + (item.avPrice * (per / 100)));
  }

  Future<void> onFinishOperation({
    required BuildContext context,
    bool? doShare,
    bool? doPrint,
    Function? doAfter,
  }) async {
    try {
      await computeReceipt(context);
      if (doPrint == true) {
        await createPDF(
          bContext: context,
          receipt: currentReceipt.value,
          share: doShare ?? false,
        );
      }
    } finally {
      doAfter;
    }
  }

  void addNRemoveItem({required Map item, required bool value}) {
    if (value) {
      selectedItems.update(
        (val) {
          val!.add(item);
        },
      );
    } else {
      selectedItems.update(
        (val) {
          val!.remove(item);
        },
      );
    }
  }

  void clearSelected() {
    selectedItems.value.clear();
  }

  num calculateCreditAfter() {
    num creditBefore = currentReceipt.value["credit_before"];
    num resideValue = currentReceipt.value["reside_value"];
    int sectionNo = currentReceipt.value["section_type_no"];
    switch (sectionNo) {
      case 2:
      case 3:
      case 17:
      case 18:
      case 32:
        return creditBefore - resideValue;
      case 1:
      case 31:
      case 4:
      case 51:
        return creditBefore + resideValue;
      default:
        return creditBefore;
    }
  }
}
