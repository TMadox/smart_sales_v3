import 'package:flutter/cupertino.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';

class KindsState extends ChangeNotifier {
  List<KindsModel> kinds = [];

  void fillKinds({required List<KindsModel> input}) {
    kinds = List.from(input);
  }
}
