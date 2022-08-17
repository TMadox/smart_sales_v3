import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/options_model.dart';

class OptionsState extends ChangeNotifier {
  List<OptionsModel> options = [];
  void fillOptions({required List<OptionsModel> input}) {
    options = List.from(input);
  }
}
