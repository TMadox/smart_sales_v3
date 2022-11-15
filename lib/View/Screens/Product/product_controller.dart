import 'package:get/get.dart';

class ProductController extends GetxController {
  RxInt qty = 1.obs;
  void incrementQty() {
    qty.value += 1;
  }

  void decrementQty() {
    if (qty.value != 1) {
      qty.value -= 1;
    }
  }
}
