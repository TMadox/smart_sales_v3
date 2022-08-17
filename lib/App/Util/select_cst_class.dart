import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/item_model.dart';

double? selectCstClass({
  required int customerClass,
  required BuildContext context,
  required ItemsModel item,
}) {
  switch (customerClass) {
    case 1:
      return item.outPrice;
    case 2:
      return item.outPrice2;
    case 3:
      return item.outPrice3;
    case 4:
      return item.outPrice4;
    case 5:
      return item.outPrice5;
    case 6:
      return item.outPrice6;
    case 7:
      return item.outPrice7;
    case 8:
      return item.outPrice8;
    default:
      return item.outPrice;
  }
}

double selectCstPer(
    {required int customerClass,
    required BuildContext context,
    required ItemsModel item}) {
  switch (customerClass) {
    case 1:
      return item.lowOutPer;
    case 2:
      return item.lowOutPer2;
    case 3:
      return item.lowOutPer3;
    case 4:
      return item.lowOutPer4;
    case 5:
      return item.lowOutPer5;
    case 6:
      return item.lowOutPer6;
    case 7:
      return item.lowOutPer7;
    case 8:
      return item.lowOutPer8;
    default:
      return item.lowOutPer;
  }
}
