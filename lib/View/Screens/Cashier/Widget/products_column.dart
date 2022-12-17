import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Screens/Product/product_controller.dart';
import 'package:smart_sales/View/Screens/Product/product_view.dart';

class ProductsColumn extends StatelessWidget {
  final CashierController cashierController;
  const ProductsColumn({
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
                "items".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
              () => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      cashierController.cashierSettings.value.gridCount,
                  childAspectRatio:
                      cashierController.cashierSettings.value.tileSize,
                ),
                itemCount: cashierController.filteredItems.value.length,
                primary: false,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  final ItemsModel item =
                      cashierController.filteredItems.value[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => ProductView(
                          item: item,
                          cashierController: cashierController,
                        ),
                        binding: BindingsBuilder(
                          () => Get.lazyPut(
                            () => ProductController(),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: Border.all(
                        color: cashierController.receiptItems.value
                                .where((element) =>
                                    element["unit_id"] == item.unitId)
                                .isNotEmpty
                            ? darkBlue
                            : Colors.white,
                        width: 3,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              color: Colors.blue,
                            ),
                          ),
                          AutoSizeText(
                            item.itemName.toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AutoSizeText(
                            "${item.unitName} ${item.outPrice}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
