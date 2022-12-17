import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_view.dart';
import 'package:smart_sales/View/Screens/Documents/documents_view.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_view.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class ClientsViewmodel {
  Future<void> intializeReceipt({
    required BuildContext context,
    required Entity client,
    required int sectionTypeNo,
    required bool canPushReplacement,
    required int selectedStorId,
  }) async {
    if (canPushReplacement) {
      Get.find<ReceiptsController>().startReceipt(
          entity: client,
          context: context,
          sectionTypeNo: sectionTypeNo,
          selectedStorId: selectedStorId,
          resetReceipt: true);
      Get.back();
    } else {
      if (sectionTypeNo == 101 || sectionTypeNo == 102) {
        Get.to(
          () => DocumentsScreen(
            sectionTypeNo: sectionTypeNo,
            entity: client,
            entitiesList: context.read<ClientsState>().clients,
          ),
        );
      } else if (sectionTypeNo == 98) {
        await Navigator.of(context)
            .pushNamed(Routes.inventoryRoute, arguments: client);
      } else if (sectionTypeNo == 31) {
        Get.to(
          () => CashierView(
            client: client,
          ),
          binding: BindingsBuilder(
            () => Get.lazyPut(
              () => CashierController(
                items: context.read<ItemsViewmodel>().items,
              ),
            ),
          ),
        );
      } else {
        Get.to(
          () => ReceiptView(
            entity: client,
            sectionTypeNo: sectionTypeNo,
            resetReceipt: true,
          ),
        );
      }
    }
  }
}
