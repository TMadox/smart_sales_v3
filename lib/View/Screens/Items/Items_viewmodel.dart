import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';

class ItemsViewmodel extends ChangeNotifier {
  List<ItemsModel> items = [];
  String lastFetchDate = "";
  int compareValue = 0;
  String searchWord = "";
  FilterType filterType = FilterType.more;
  void fillItems({required List<ItemsModel> input}) {
    items = input;
    lastFetchDate = DateTime.now().toString();
    notifyListeners();
  }

  void reset() {
    compareValue = 0;
    searchWord = "";
    filterType = FilterType.more;
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
  }) async {
    ItemsModel currentItem =
        items.firstWhere((element) => element.unitId == id);
    double itemQty = currentItem.curQty;

    double totalReceiptQty = qty * currentItem.unitConvert;
    if (sectionTypeNo == 3) {
      items.firstWhere((element) => element.unitId == id).curQty =
          itemQty + qty;
      items
          .where((element) => (element.typeId == currentItem.typeId &&
              element.unitId != currentItem.unitId))
          .forEach((element) {
        element.curQty =
            (element.curQty + (totalReceiptQty / element.unitConvert));
      });
    } else if (sectionTypeNo == 17 || sectionTypeNo == 18) {
    } else {
      log("receipt total item qty =" + totalReceiptQty.toString());
      items.firstWhere((element) => element.unitId == id).curQty =
          itemQty - qty;
      log("current new qty of the item" +
          items
              .firstWhere((element) => element.unitId == id)
              .curQty
              .toString());
      items
          .where((element) => (element.typeId == currentItem.typeId &&
              element.unitId != currentItem.unitId))
          .forEach((element) {
        element.curQty =
            (element.curQty - (totalReceiptQty / element.unitConvert));
      });
    }
    await locator.get<SaveData>().saveItemsData(
          input: items,
        );
  }

  List<ItemsModel> filterItems() {
    List<ItemsModel> resultList = [];
    if (searchWord != "" && searchWord != "null") {
      resultList = items
          .where(
            (element) => element.itemName.toString().toLowerCase().contains(
                  searchWord.toString().toLowerCase(),
                ),
          )
          .toList();
    } else {
      resultList = items;
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
    List<ItemsModel> filteredItems = filterItems();
    if (filteredItems.isNotEmpty && canTap) {
      if (context.read<GeneralState>().currentReceipt["selected_stor_id"] ==
          null) {
        return filteredItems;
      } else {
        return filteredItems;
        // .where((element) =>
        //     element.storId ==
        //     context.read<GeneralState>().currentReceipt["selected_stor_id"])
        // .toList();
      }
    } else {
      return filteredItems;
    }
  }
}
