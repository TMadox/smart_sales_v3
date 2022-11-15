import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Data/Models/kinds_model.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/bottom_info.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/details_table.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/groups_row.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/offers_column.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/products_box.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/search_bar.dart';
import 'package:smart_sales/View/Screens/Cashier/Widget/types_column.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';

class CashierView extends StatefulWidget {
  final ClientsModel client;
  const CashierView({Key? key, required this.client}) : super(key: key);

  @override
  State<CashierView> createState() => _CashierViewState();
}

class _CashierViewState extends State<CashierView> {
  final CashierController cashierController = Get.find<CashierController>();
  KindsModel? selectedModel;
  Map data = {};
  final storage = GetStorage();
  @override
  void initState() {
    data.addAll({
      "extend_time": DateTime.now().toString(),
      "section_type_no": 9999,
      "user_name": widget.client.amName,
      "credit_before": widget.client.curBalance ?? 0.0,
      "cst_tax": widget.client.taxFileNo ?? ".....",
      "employ_id": context.read<UserState>().user.defEmployAccId,
      "basic_acc_id": widget.client.accId,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generalState = context.read<GeneralState>();
    final double height = screenHeight(context);
    return WillPopScope(
      onWillPop: () async {
        if (generalState.receiptItems.isNotEmpty) {
          generalDialog(
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
                            generalState: generalState,
                            storage: storage,
                            onTap: () async {
                              await storage.write(
                                "show_cashier_details",
                                !(storage.read('show_cashier_details') ?? true),
                              );
                              setState(() {});
                            },
                          ),
                          Expanded(
                            child: Obx(
                              () {
                                cashierController.selectedKindId.value;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TypesColumn(
                                        cashierController: cashierController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.005,
                                    ),
                                    Expanded(
                                      flex: cashierController
                                          .cashierSettings.value.productsFlex,
                                      child: ProductsBox(
                                        cashierController: cashierController,
                                      ),
                                    ),
                                    if (!(storage
                                            .read("show_cashier_details") ??
                                        true)) ...[
                                      SizedBox(
                                        width: screenWidth(context) * 0.005,
                                      ),
                                      Expanded(
                                        child: OffersColumn(
                                          cashierController: cashierController,
                                        ),
                                      )
                                    ]
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Visibility(
                      visible: storage.read("show_cashier_details") ?? true,
                      child: Expanded(
                        child: Consumer<GeneralState>(
                          builder: (context, generalState, child) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Consumer<GeneralState>(builder:
                                                (context, state, widget) {
                                              return NeumorphicButton(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                style: NeumorphicStyle(
                                                  color: state.receiptItems
                                                          .isNotEmpty
                                                      ? Colors.orange
                                                      : Colors.grey,
                                                  shape:
                                                      NeumorphicShape.concave,
                                                  surfaceIntensity: 50,
                                                  shadowDarkColor: Colors.black,
                                                ),
                                                onPressed: state
                                                        .receiptItems.isNotEmpty
                                                    ? () {
                                                        cashierController
                                                            .saveChashier(
                                                          context: context,
                                                          generalState:
                                                              generalState,
                                                        );
                                                      }
                                                    : null,
                                                child: const Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }),
                                            Text(
                                              "customer".tr +
                                                  " : " +
                                                  context
                                                      .read<ClientsState>()
                                                      .currentClient!
                                                      .amName
                                                      .toString(),
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
                                                    generalState
                                                        .removeFromListReceiptItems(
                                                      inputs: cashierController
                                                          .selectedItems.value,
                                                    );
                                                    cashierController
                                                        .clearSelectedItems();
                                                  },
                                            style: NeumorphicStyle(
                                              color: cashierController
                                                      .selectedItems
                                                      .value
                                                      .isEmpty
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
                                      child: DetailsTable(
                                        generalState: generalState,
                                        height: height,
                                        width: constraints.maxWidth,
                                        cashierController: cashierController,
                                      ),
                                    ),
                                    BottomInfo(
                                      width: constraints.maxWidth,
                                      height: height,
                                      generalState: generalState,
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  if (!(storage.read("show_cashier_details") ?? true))
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 70,
                      leading: const SizedBox(),
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GroupsRow(
                          cashierController: cashierController,
                          storage: storage,
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
