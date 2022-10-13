// ignore: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/type_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';

class ItemsViewmodel extends ChangeNotifier {
  List<ItemsModel> items = [];
  List<ItemsModel> selectedItems = [];
  List<TypeModel> types = [];
  String lastFetchDate = "";
  int compareValue = 0;
  String searchWord = "";
  FilterType filterType = FilterType.more;

  Future<void> fetchTypes({required bool transAllStors}) async {
    if (transAllStors) {
      final response = await DioRepository.to.get(path: '/get_data_types_qtys');
      await SharedStorage.to.prefs.setString("types", response);
    } else {
      await SharedStorage.to.prefs.remove("types");
    }
  }

  Future<String> fetchItems({
    required bool transAllStors,
    required UserModel user,
  }) async {
    SharedStorage.to.prefs.setBool("loaded_items", false);
    final response = transAllStors == false
        ? await DioRepository.to.get(
            path: '/get_data_items_with_stor_id',
            data: {
              "stor_id": user.defStorId,
            },
          )
        : await DioRepository.to.get(
            path: '/get_data_items',
          );
    await SharedStorage.to.prefs.setString("items", response);
    return response;
  }

  Future<void> fetchAllData({
    required BuildContext context,
    required UserModel user,
  }) async {
    final OptionsModel transAllStors =
        (await context.read<OptionsState>().reloadOptions())
            .firstWhere((option) => option.optionId == 6);
    await context.read<PowersState>().reloadPowers(context);
    log("trans all store:" + transAllStors.optionValue.toString());
    await fetchTypes(transAllStors: transAllStors.optionValue == 1);
    await fetchItems(transAllStors: transAllStors.optionValue == 1, user: user);
  }

  Future<void> loadItems({
    required BuildContext context,
  }) async {
    final storage = SharedStorage.to.prefs;
    items = itemsListFromJson(input: storage.getString("items").toString());
    if (storage.getString("types") != null) {
      types = typeModelFromJson(storage.getString("types")!);
      if ((SharedStorage.to.prefs.getBool("loaded_items") ?? false) == false) {
        List<ItemsModel> tempItems = [];
        for (var stor in context.read<StoreState>().stors) {
          for (var currentItem in items) {
            TypeModel tempType = types.firstWhere(
                (type) => (type.typeId == currentItem.typeId &&
                    type.storId == stor.storId), orElse: () {
              return TypeModel(
                qtyId: 0,
                typeId: currentItem.typeId,
                itemId: 1,
                storId: stor.storId,
                curQty0: 0,
                noInQty: 0,
              );
            });
            tempItems.add(
              currentItem.copyWith(
                curQty0: (tempType.curQty0 / currentItem.unitConvert),
                curQty: (tempType.curQty0 / currentItem.unitConvert),
                storId: tempType.storId,
              ),
            );
          }
        }
        items = List.from(tempItems);
        SharedStorage.to.prefs.setBool("loaded_items", true);
        await locator.get<SaveData>().saveItemsData(
              input: items,
            );
      }
    }
  }

  Future<List<ItemsModel>> reloadItems({
    required BuildContext context,
    required UserModel user,
  }) async {
    await fetchAllData(
      context: context,
      user: user,
    );
    await loadItems(context: context);
    return items;
  }

  void addToSelectedItems({
    required ItemsModel input,
  }) {
    selectedItems.add(input);
    notifyListeners();
  }

  void muliAddToReceipt({required BuildContext context}) {
    for (var item in selectedItems) {
      context.read<ReceiptViewmodel>().addNewItem(
            item: item,
            context: context,
          );
    }
  }

  void removeFromSelectedItems({
    required ItemsModel input,
  }) {
    selectedItems.remove(input);
    notifyListeners();
  }

  void reset() {
    selectedItems.clear();
    compareValue = 0;
    searchWord = "";
  }

  Future<void> saveItems() async {
    await locator.get<SaveData>().saveItemsData(
          input: items,
        );
  }

  void setCompareValue(int input) {
    compareValue = input;
    notifyListeners();
  }

  void setFilterType(FilterType input) {
    filterType = input;
    notifyListeners();
  }

  void setSearchWord(String input) {
    searchWord = input;
    notifyListeners();
  }

  Future<void> editItemQty({
    required int id,
    required num qty,
    required double unitMulti,
    required int sectionTypeNo,
    int? inStorId,
    required num storId,
  }) async {
    ItemsModel currentItem = items.firstWhere(
      (element) => element.unitId == id && element.storId == storId,
    );
    num itemQty = currentItem.curQty;
    double totalReceiptQty = qty * currentItem.unitConvert;
    switch (sectionTypeNo) {
      case 3:
      case 2:
        {
          items
              .firstWhere(
                  (element) => element.unitId == id && element.storId == storId)
              .curQty = itemQty + qty;
          items
              .where((element) => (element.typeId == currentItem.typeId &&
                  element.unitId != currentItem.unitId &&
                  element.storId == storId))
              .forEach((element) {
            element.curQty =
                (element.curQty + (totalReceiptQty / element.unitConvert));
          });
          break;
        }
      case 1:
      case 4:
        {
          items
              .firstWhere(
                  (element) => element.unitId == id && element.storId == storId)
              .curQty = itemQty - qty;
          items
              .where(
            (element) => (element.typeId == currentItem.typeId &&
                element.unitId != currentItem.unitId &&
                element.storId == storId),
          )
              .forEach((element) {
            element.curQty =
                (element.curQty - (totalReceiptQty / element.unitConvert));
          });
          break;
        }
      case 5:
        {
          items
              .firstWhere(
                  (element) => element.unitId == id && element.storId == storId)
              .curQty = itemQty - qty;
          items
              .where(
            (element) => (element.typeId == currentItem.typeId &&
                element.unitId != currentItem.unitId &&
                element.storId == storId),
          )
              .forEach((element) {
            element.curQty =
                (element.curQty - (totalReceiptQty / element.unitConvert));
          });
///////////////
          currentItem = items.firstWhere(
            (element) => element.unitId == id && element.storId == inStorId,
          );
          itemQty = currentItem.curQty;
          totalReceiptQty = qty * currentItem.unitConvert;
          log(items
              .firstWhere((element) =>
                  element.unitId == id && element.storId == inStorId)
              .curQty
              .toString());
          items
              .firstWhere((element) =>
                  element.unitId == id && element.storId == inStorId)
              .curQty += qty;
          items
              .where(
            (element) => (element.typeId == currentItem.typeId &&
                element.unitId != currentItem.unitId &&
                element.storId == inStorId),
          )
              .forEach((element) {
            element.curQty =
                (element.curQty + (totalReceiptQty / element.unitConvert));
          });

          break;
        }
    }
    await locator.get<SaveData>().saveItemsData(
          input: items,
        );
  }

  List<ItemsModel> filterPower({required BuildContext context}) {
    if (context.read<PowersState>().allowMultiStorFat) {
      return items;
    } else {
      return items
          .where((element) =>
              element.storId == context.read<UserState>().user.defStorId)
          .toList();
    }
  }

  List<ItemsModel> filterItems({required BuildContext context}) {
    final List<ItemsModel> powerFilteredList = filterPower(context: context);
    List<ItemsModel> resultList = [];
    if (searchWord != "" && searchWord != "null") {
      if (searchWord.contains(" ") &&
          searchWord[0] != " " &&
          searchWord[searchWord.length - 1] != " ") {
        List<String> searchWords = searchWord.toLowerCase().split(" ");
        searchWords.removeWhere((element) => element == "");
        resultList = powerFilteredList
            .where((item) => searchWords
                .every((word) => item.itemName.split(' ').contains(word)))
            .toList();
      } else {
        resultList = powerFilteredList
            .where((element) => element.itemName
                .toLowerCase()
                .contains(searchWord.toLowerCase()))
            .toList();
      }
    } else {
      resultList = powerFilteredList;
    }
    switch (filterType) {
      case FilterType.less:
        {
          return resultList
              .where((element) => element.curQty < compareValue)
              .toList();
        }
      case FilterType.more:
        {
          return resultList
              .where((element) => element.curQty > compareValue)
              .toList();
        }
      case FilterType.equal:
        {
          return resultList
              .where((element) => element.curQty == compareValue)
              .toList();
        }
      case FilterType.all:
        {
          return resultList;
        }
      default:
        return resultList;
    }
  }

  List<ItemsModel> filterStor({
    required BuildContext context,
    required bool canTap,
  }) {
    List<ItemsModel> filteredItems = filterItems(context: context);
    if (filteredItems.isNotEmpty && canTap) {
      if (context.read<GeneralState>().currentReceipt["selected_stor_id"] ==
          null) {
        return filteredItems;
      } else {
        return filteredItems
            .where((element) =>
                element.storId ==
                context.read<GeneralState>().currentReceipt["selected_stor_id"])
            .toList();
      }
    } else {
      return filteredItems;
    }
  }
}
