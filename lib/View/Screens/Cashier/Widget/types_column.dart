import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';

class TypesColumn extends StatelessWidget {
  final CashierController cashierController;
  const TypesColumn({
    Key? key,
    required this.cashierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: darkBlue,
          width: 2,
        ),
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
                "types".tr,
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
            child: Obx(
              () {
                cashierController.selectedKindId.value;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        cashierController.setSelectedKind(input: null);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: cashierController.selectedKindId.value == null
                            ? darkBlue
                            : Colors.transparent,
                        child: AutoSizeText(
                          "all".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                cashierController.selectedKindId.value == null
                                    ? Colors.white
                                    : Colors.red,
                          ),
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
                              cashierController.setSelectedKind(
                                  input: kindsModel.kindId);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: kindsModel.kindId ==
                                      cashierController.selectedKindId.value
                                  ? darkBlue
                                  : Colors.transparent,
                              child: AutoSizeText(
                                kindsModel.kindName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kindsModel.kindId ==
                                          cashierController.selectedKindId.value
                                      ? Colors.white
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
