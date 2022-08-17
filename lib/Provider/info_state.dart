import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/info_model.dart';

class InfoState extends ChangeNotifier {
  late InfoModel info;
  void fillInfo({required InfoModel input}) {
    info = input;
  }
}
