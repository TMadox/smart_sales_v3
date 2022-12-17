import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
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
      final MowModel mow = mows.firstWhere((element) => element.accId == id);
      mows[mows.indexOf(mow)] = mows[mows.indexOf(mow)]
          .copyWith(curBalance: (originalAmount - amount));
    } else {
      double originalAmount =
          mows.firstWhere((element) => element.accId == id).curBalance;
      final MowModel mow = mows.firstWhere((element) => element.accId == id);
      mows[mows.indexOf(mow)] = mows[mows.indexOf(mow)]
          .copyWith(curBalance: (originalAmount + amount));
    }
    await GetStorage().write("mows", mowModelToMap(mows));
    return mows.firstWhere((element) => element.accId == id).curBalance;
  }
}
