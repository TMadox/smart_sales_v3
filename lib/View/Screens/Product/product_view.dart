import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Data/Models/item_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Screens/Product/product_controller.dart';
import 'package:smart_sales/View/Widgets/Common/common_button.dart';

class ProductView extends StatefulWidget {
  final CashierController cashierController;
  final ItemsModel item;
  const ProductView(
      {Key? key, required this.item, required this.cashierController})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("معلومات المنتج"),
      ),
      body: Align(
        alignment: AlignmentDirectional.topStart,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth(context) / 2,
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        widget.item.itemName,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.outPrice.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.item.unitName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(),
                          Obx(
                            () => Text(
                              (widget.item.outPrice *
                                          productController.qty.value)
                                      .toString() +
                                  " (${productController.qty.value}x)",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CommonButton(
                                title: "add product".tr,
                                icon: const Icon(Icons.shopping_cart_checkout),
                                color: Colors.green,
                                onPressed: () {
                                  widget.cashierController.addCashierItem(
                                    context: context,
                                    item: widget.item,
                                    generalState: context.read<GeneralState>(),
                                    qty: productController.qty.value,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        productController.incrementQty();
                                      },
                                      icon: const Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        productController.qty.value.toString(),
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        productController.decrementQty();
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        size: 35,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "خلافاَ للإعتقاد السائد فإن لوريم إيبسوم ليس نصاَ عشوائياً، بل إن له جذور في الأدب اللاتيني الكلاسيكي منذ العام 45 قبل الميلاد، مما يجعله أكثر من 2000 عام في القدم. قام البروفيسور  (Richard McClintock) وهو بروفيسور اللغة اللاتينية في جامعة هامبدن-سيدني في فيرجينيا بالبحث عن أصول كلمة لاتينية غامضة في نص لوريم إيبسوم وهي"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
