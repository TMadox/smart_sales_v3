import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/stor_model.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';

class StoreState extends ChangeNotifier {
  List<StorModel> stors = [];
  void fillStors(
      {required List<StorModel> input, required BuildContext context}) {
    context.read<ReceiptViewmodel>().setSelectedStor(stor: null);
    stors = List.from(input);
  }
}
