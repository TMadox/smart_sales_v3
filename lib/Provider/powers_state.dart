import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/power_model.dart';

class PowersState extends ChangeNotifier {
  List<PowersModel> powersList = [];
  late bool canEditItemPrice;
  late bool canEditItemDisc;
  late bool canEditFreeQty;
  late bool canSellWithLowerPrice;
  late bool showPurchasePrices;
  late bool showLastPrices;
  late bool allowSellQtyLessThanZero;
  void fillPowers({required List<PowersModel> powers}) {
    powersList.addAll(powers);
    showPurchasePrices = powers.firstWhere(
          (element) => element.powerId == 746,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    allowSellQtyLessThanZero = powers.firstWhere(
          (element) => element.powerId == 510,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    canEditItemPrice = powers.firstWhere(
          (element) => element.powerId == 515,
          orElse: () {
            return PowersModel(powerState: 0);
          },
        ).powerState ==
        1;
    canEditFreeQty = (canEditItemPrice &&
        powers.firstWhere(
              (element) => element.powerId == 783,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1);
    canSellWithLowerPrice = (canEditItemPrice &&
        powers.firstWhere(
              (element) => element.powerId == 526,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1);
    canEditItemDisc = (canEditItemPrice ||
        (powers.firstWhere(
              (element) => element.powerId == 1141,
              orElse: () {
                return PowersModel(powerState: 0);
              },
            ).powerState ==
            1));
  }
}
