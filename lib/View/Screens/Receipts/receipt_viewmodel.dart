import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Base/base_viewmodel.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';

class ReceiptViewmodel extends ChangeNotifier with BaseViewmodel {
  List selectedItems = [];
  StorModel? selectedStor;
  void setSelectedStor({StorModel? stor}) {
    selectedStor = stor;
    notifyListeners();
  }

  void addNRemoveItem({required Map item, required bool value}) {
    if (value) {
      selectedItems.add(item);
    } else {
      selectedItems.remove(item);
    }
    notifyListeners();
  }


  void clearSelected() {
    selectedItems = [];
    notifyListeners();
  }
}
