import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
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
        border: Border.all(color: darkBlue, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Neumorphic(
              child: Text(
                "offers".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              style: NeumorphicStyle(
                color: darkBlue,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.zero),
                shape: NeumorphicShape.concave,
                surfaceIntensity: 50,
                shadowDarkColor: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              primary: false,
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
                            ? darkBlue
                            : Colors.transparent,
                      ),
                    ),
                    child: SizedBox(
                      height: 150,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset("assets/download.jpg"),
                            ),
                            const Text("dummy data"),
                          ],
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
