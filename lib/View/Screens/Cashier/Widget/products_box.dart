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

class ProductsBox extends StatelessWidget {
  final CashierController cashierController;
  const ProductsBox({
    Key? key,
    required this.cashierController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralState>(
      builder: (context, state, widget) {
        return Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
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
                        child: GetBuilder<CashierController>(
                          builder: (state) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: context
                                        .read<GeneralState>()
                                        .receiptItems
                                        .where((element) =>
                                            element["unit_id"] == item.unitId)
                                        .isNotEmpty
                                    ? darkBlue
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
