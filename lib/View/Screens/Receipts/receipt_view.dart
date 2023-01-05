import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Features/exit.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/bottom_table.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/first_bar.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/receipt_items_table.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/second_bar.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class ReceiptView extends StatefulWidget {
  final Entity entity;
  final int sectionTypeNo;
  final int? selectedStorId;
  final bool resetReceipt;
  const ReceiptView({
    Key? key,
    required this.entity,
    required this.sectionTypeNo,
    this.selectedStorId,
    required this.resetReceipt,
  }) : super(key: key);

  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  final List<TextEditingController> controllers =
      List.generate(4, (i) => TextEditingController(text: 0.0.toString()));
  TextEditingController searchController = TextEditingController();
  late Map data = {};
  final storage = GetStorage();
  final ReceiptsController receiptsController = Get.find<ReceiptsController>();
  late bool isEditing;
  @override
  void initState() {
    data.addAll(
      {
        "extend_time": DateTime.now().toString(),
        "section_type_no": 9999,
        "user_name": widget.entity.name,
        "credit_before": widget.entity.curBalance,
        "cst_tax": widget.entity.taxFileNo,
        "employ_id": context.read<UserState>().user.defEmployAccId,
        "basic_acc_id": widget.entity.accId,
      },
    );
    isEditing = receiptsController.currentReceipt.value["saved"] == 1;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        receiptsController.startReceipt(
          context: context,
          entity: widget.entity,
          sectionTypeNo: widget.sectionTypeNo,
          selectedStorId: null,
          resetReceipt: widget.resetReceipt,
        );
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ReceiptsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Exit().commit(
          context: context,
          warnExit: receiptsController.receiptItems.value.isNotEmpty,
          data: data,
        );
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    FirstBar(
                      receiptsController: receiptsController,
                      isEditing: isEditing,
                      data: data,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SecondBar(
                      receiptsController: receiptsController,
                      searchController: searchController,
                      isEditing: isEditing,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: ReceiptItemsTable(
                        data: data,
                        receiptsController: receiptsController,
                        isEditing: isEditing,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: receiptsController
                              .currentReceipt.value["section_type_no"] !=
                          5,
                      child: Obx(
                        () {
                          receiptsController.currentReceipt.value;
                          return BottomTable(
                            controllers: controllers,
                            customer: widget.entity,
                            receiptsController: receiptsController,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
