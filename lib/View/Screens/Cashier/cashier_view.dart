import 'dart:developer';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';

import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/bottom_info.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/details_table.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/groups_row.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/offers_column.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/products_column.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/search_bar.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/types_column.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/general_dialog.dart';

class CashierView extends StatefulWidget {
  final Entity client;
  const CashierView({
    Key? key,
    required this.client,
  }) : super(key: key);
  @override
  State<CashierView> createState() => _CashierViewState();
}

class _CashierViewState extends State<CashierView> {
  KindsModel? selectedModel;
  Map data = {};
  final CashierController cashierController = Get.find<CashierController>();
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.client.name,
      "credit_before": widget.client.curBalance,
      "cst_tax": widget.client.taxFileNo,
      "employ_id": context.read<UserState>().user.defEmployAccId,
      "basic_acc_id": widget.client.accId,
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        cashierController.startReceipt(
          context: context,
          entity: widget.client,
          sectionTypeNo: 31,
          selectedStorId: null,
          resetReceipt: true,
        );
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (cashierController.receiptItems.value.isNotEmpty) {
          await generalDialog(
            context: context,
            message: 'receipt_still_inprogress'.tr,
            onCancelIcon: const Icon(Icons.exit_to_app),
            onCancelText: 'exit'.tr,
            onOkText: 'stay'.tr,
            onCancel: () {
              if ((GetStorage().read("request_visit") ?? false)) {
                exitDialog(
                  context: context,
                  data: data,
                );
                return false;
              } else {
                Get.back();
              }
            },
            title: 'warning'.tr,
          );
          return false;
        } else {
          if ((GetStorage().read("request_visit") ?? false)) {
            exitDialog(
              context: context,
              data: data,
            );
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: NestedScrollView(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SearchBar(
                            data: data,
                            onChanged: (value) {
                              cashierController.setSearchWord(value ?? "");
                            },
                            storage: GetStorage(),
                            onTap: () async {
                              cashierController.updateShowCart(
                                  input: !cashierController
                                      .cashierSettings.value.showCart);
                              setState(() {});
                            },
                            cashierController: cashierController,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth(context) * 0.2,
                                  child: TypesColumn(
                                    cashierController: cashierController,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: cashierController.cashierSettings.value
                                              .productsFlex >
                                          0
                                      ? cashierController
                                          .cashierSettings.value.productsFlex
                                      : 1,
                                  child: ProductsColumn(
                                    cashierController: cashierController,
                                  ),
                                ),
                                if (!cashierController
                                        .cashierSettings.value.showCart &&
                                    cashierController
                                        .cashierSettings.value.showOffers) ...[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: cashierController.cashierSettings
                                                .value.productsFlex <
                                            0
                                        ? cashierController
                                            .cashierSettings.value.productsFlex
                                            .abs()
                                        : 1,
                                    child: OffersColumn(
                                      cashierController: cashierController,
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: cashierController.cashierSettings.value.showCart,
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(
                                      () => NeumorphicButton(
                                        margin: const EdgeInsets.all(5.0),
                                        style: NeumorphicStyle(
                                          color: cashierController
                                                  .receiptItems.value.isNotEmpty
                                              ? Colors.orange
                                              : Colors.grey,
                                          shape: NeumorphicShape.concave,
                                          surfaceIntensity: 50,
                                          shadowDarkColor: Colors.black,
                                        ),
                                        onPressed: cashierController
                                                .receiptItems.value.isNotEmpty
                                            ? () {
                                                cashierController.saveChashier(
                                                  context: context,
                                                );
                                              }
                                            : null,
                                        child: const Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "customer".tr +
                                          " : " +
                                          widget.client.name.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => NeumorphicButton(
                                    margin: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: cashierController
                                            .selectedItems.value.isEmpty
                                        ? null
                                        : () {
                                            cashierController.deleteItems(
                                                context: context);
                                          },
                                    style: NeumorphicStyle(
                                      color: cashierController
                                              .selectedItems.value.isEmpty
                                          ? Colors.grey
                                          : Colors.indigo,
                                      shape: NeumorphicShape.concave,
                                      surfaceIntensity: 50,
                                      shadowDarkColor: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Obx(
                                () {
                                  cashierController.currentReceipt.value;
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: DetailsTable(
                                          cashierController: cashierController,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      BottomInfo(
                                        controller: cashierController,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  if (!cashierController.cashierSettings.value.showCart)
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 70,
                      leading: const SizedBox(),
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GroupsRow(
                          cashierController: cashierController,
                          storage: GetStorage(),
                        ),
                      ),
                    ),
                ];
              },
            ),
          ),
        ),
      ),
    );
  }
}
