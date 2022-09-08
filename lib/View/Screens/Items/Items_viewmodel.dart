import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/enums_manager.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Data/Models/type_model.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';

class ItemsViewmodel extends ChangeNotifier {
  List<ItemsModel> items = [];
  List<ItemsModel> selectedItems = [];
  List<TypeModel> types = [];
  String lastFetchDate = "";
  int compareValue = 0;
  String searchWord = "";
  FilterType filterType = FilterType.more;
  void fillTypeQty({required List<TypeModel> input}) {
    types = input;
  }

  void fillItems({required List<ItemsModel> input}) {
    items = input;
    lastFetchDate = DateTime.now().toString();
    notifyListeners();
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

  Future<void> refillItems({
    required BuildContext context,
    required UserModel user,
  }) async {
    final OptionsModel transAllStors = context
        .read<OptionsState>()
        .options
        .firstWhere((option) => option.optionId == 6);
    items = transAllStors.optionValue == 0
        ? itemsListFromJson(
            input: await locator.get<GeneralRepository>().get(
              path: '/get_data_items_with_stor_id',
              data: {
                "stor_id": user.defStorId,
              },
            ),
          )
        : itemsListFromJson(
            input: await locator.get<GeneralRepository>().get(
                  path: '/get_data_items',
                ),
          );
    await locator.get<SaveData>().saveItemsData(
          input: items,
        );
  }

  void reset() {
    selectedItems.clear();
    compareValue = 0;
    searchWord = "";
    filterType = FilterType.more;
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
    }
    await locator.get<SaveData>().saveItemsData(
          input: items,
        );
  }

  List<ItemsModel> filterItems() {
    List<ItemsModel> resultList = [];
    if (searchWord != "" && searchWord != "null") {
      if (searchWord.contains(" ")) {
        final List<String> searchWords = searchWord.toLowerCase().split(" ");
        List<ItemsModel> proccessedList = [];
        for (var searchWord in searchWords) {
          for (var item in items) {
            if (item.itemName.toLowerCase().split(" ").contains(searchWord)) {
              proccessedList.add(item);
            }
          }
        }
        resultList = proccessedList;
      } else {
        resultList = items
            .where((element) => element.itemName
                .toLowerCase()
                .contains(searchWord.toLowerCase()))
            .toList();
      }
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
