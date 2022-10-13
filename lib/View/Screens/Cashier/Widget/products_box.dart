import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class ProductsBox extends StatelessWidget {
  final CashierController cashierController;
  const ProductsBox({
    Key? key,
    required this.cashierController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "items".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.green,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: cashierController.filteredItems.value.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                final ItemsModel item =
                    cashierController.filteredItems.value[index];
                return InkWell(
                  onTap: () {
                    cashierController.addOrIncrementItem(
                      context: context,
                      item: item,
                      generalState: context.read<GeneralState>(),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: context
                                .read<GeneralState>()
                                .receiptItems
                                .where((element) =>
                                    element["unit_id"] == item.unitId)
                                .isNotEmpty
                            ? Colors.green
                            : Colors.white,
                      ),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        item.itemName.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
