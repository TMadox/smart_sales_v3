import 'package:flutter/cupertino.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/mow_model.dart';

class MowState extends ChangeNotifier {
  List<MowModel> mows = [];

  void fillMows({required List<MowModel> input}) {
    mows = List.from(input);
  }

  Future<double> editMows({
    required int id,
    required double amount,
    required int sectionType,
  }) async {
    if (sectionType == 3 || sectionType == 104) {
      double originalAmount =
          mows.firstWhere((element) => element.accId == id).curBalance;
      mows.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount - amount);
    } else {
      double originalAmount =
          mows.firstWhere((element) => element.accId == id).curBalance;
      mows.firstWhere((element) => element.accId == id).curBalance =
          (originalAmount + amount);
    }
    await locator
        .get<SharedStorage>()
        .prefs
        .setString("mows", mowModelToMap(mows));
    return mows.firstWhere((element) => element.accId == id).curBalance;
  }
}
