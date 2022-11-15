import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/power_model.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

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

  Future<void> fetchPowers(BuildContext context) async {
    final generalPowers = await DioRepository.to.get(path: '/get_data_powers');
    final userPowers = await DioRepository.to.get(
      path: '/get_user_powers_by_user_id',
      data: {
        "user_id": context.read<UserState>().user.userId,
      },
    );
    await GetStorage().write("powers", generalPowers);
    await GetStorage().write("user_powers", userPowers);
  }

  void loadPowers() {
    userPowersList = powersModelFromMap(GetStorage().read("user_powers")!);
    generalPowersList = powersModelFromMap(GetStorage().read("powers")!);
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
  }

  Future<void> reloadPowers(BuildContext buildContext) async {
    await fetchPowers(buildContext);
    loadPowers();
  }
}
