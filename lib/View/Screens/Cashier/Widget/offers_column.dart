import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class OffersColumn extends StatelessWidget {
  final CashierController cashierController;
  const OffersColumn({
    Key? key,
    required this.cashierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "offers".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.green,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: context.read<KindsState>().kinds.length,
              itemBuilder: (BuildContext context, int index) {
                final KindsModel kindsModel =
                    context.read<KindsState>().kinds[index];
                return InkWell(
                  onTap: () {
                    cashierController.setSelectedKind(input: kindsModel.kindId);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: kindsModel.kindId ==
                                cashierController.selectedKindId.value
                            ? Colors.green
                            : Colors.transparent,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth(context) * 0.05),
                      child: Center(
                        child: Text("dummy data"),
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
