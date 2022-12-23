import 'package:flutter/cupertino.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';

class StoreState extends ChangeNotifier {
  List<StorModel> stors = [];
  void fillStors({
    required List<StorModel> input,
    required BuildContext context,
  }) {
    // context.read<ReceiptViewmodel>().setSelectedStor(stor: null);
    stors = List.from(input);
  }
}
