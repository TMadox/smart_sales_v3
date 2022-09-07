import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/power_model.dart';

class PowersState extends ChangeNotifier {
  List<PowersModel> userPowersList = [];
  List<PowersModel> generalPowersList = [];

  late bool canEditItemPrice;
  late bool canEditItemDisc;
  late bool canEditFreeQty;
  late bool canSellWithLowerPrice;
  late bool showPurchasePrices;
  late bool showLastPrices;
  late bool allowSellQtyLessThanZero;
  late bool allowMultiStorFat;

  void fillPowers() {
    userPowersList = powersModelFromMap(
        locator.get<SharedStorage>().prefs.getString("user_powers")!);
    generalPowersList = powersModelFromMap(
        locator.get<SharedStorage>().prefs.getString("powers")!);

    showPurchasePrices = userPowersList.firstWhere(
          (element) => element.powerId == 746,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    allowSellQtyLessThanZero = userPowersList.firstWhere(
          (element) => element.powerId == 510,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    canEditItemPrice = userPowersList.firstWhere(
          (element) => element.powerId == 515,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    canEditFreeQty = (canEditItemPrice &&
        userPowersList.firstWhere(
              (element) => element.powerId == 783,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1);
    canSellWithLowerPrice = (canEditItemPrice &&
        userPowersList.firstWhere(
              (element) => element.powerId == 526,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1);
    canEditItemDisc = (canEditItemPrice ||
        (userPowersList.firstWhere(
              (element) => element.powerId == 1141,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1));
    if (userPowersList.where((element) => element.powerId == 509).isEmpty) {
      allowMultiStorFat = generalPowersList
              .firstWhere((element) => element.powerId == 509)
              .defState ==
          "1";
    } else {
      allowMultiStorFat = userPowersList
              .firstWhere((element) => element.powerId == 509)
              .powerState ==
          1;
    }
    log(allowMultiStorFat.toString());
  }
}
