// ignore_for_file: implementation_imports
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Controllers/upload_controller.dart';
import 'package:smart_sales/View/Screens/Operations/Widgets/receipts_summery_table.dart';
import 'package:smart_sales/View/Screens/Operations/operations_source.dart';
import 'package:smart_sales/View/Screens/Operations/operations_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class OperationsView extends StatefulWidget {
  const OperationsView({Key? key}) : super(key: key);

  @override
  State<OperationsView> createState() => _OperationsViewState();
}

class _OperationsViewState extends State<OperationsView> {
  bool isLoading = false;
  String searchWord = "";
  int filterSectionType = 0;
  final OperationsController operationController =
      Get.find<OperationsController>();
  @override
  void initState() {
    operationController.loadOperations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Colors.white,
          flexibleSpace: Row(
            children: [
              const BackButton(
                color: Colors.green,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: CustomTextField(
                    name: "search",
                    onChanged: (p0) {
                      // setState(() {
                      //   searchWord = p0!;
                      // });
                    },
                    activated: true,
                    hintText: "search".tr,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    5,
                  ),
                  child: FormBuilderDropdown<int>(
                    initialValue: 0,
                    name: "filter",
                    iconEnabledColor: Colors.transparent,
                    // isDense: false,
                    onChanged: (value) {
                      setState(() {
                        filterSectionType = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "all".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "sales".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "return".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "seizure_document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 101,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "payment_document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 102,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "mow_seizure_document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 103,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "mow_payment_document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 104,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "visit".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 9999,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "inventory".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 98,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "selling_order".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 17,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "cashier_receipt".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 31,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "purchase_order".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 18,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "purchase_receipt".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 3,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "purchase_return_receipt".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 4,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "employee payment document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 106,
                      ),
                      DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        child: AutoSizeText(
                          "employee seizure document".tr,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        value: 105,
                      )
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  await Get.find<UploadController>().commit(showLoading: true);
                },
                mini: true,
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.upload,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "last_upload_date".tr +
                        ": " +
                        (context.read<UserState>().user.uploadDate ?? ".."),
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.green, width: 4),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SingleChildScrollView(
                        child: PaginatedDataTable(
                      arrowHeadColor: Colors.green,
                      headingRowHeight: 30,
                      dataRowHeight: 30,
                      horizontalMargin: 0,
                      columnSpacing: 0,
                      source: OperationsSource(
                        context: context,
                        receipts: filterList(
                          input: searchWord,
                          receiptsList: operationController.operations.value,
                        ),
                        controller: operationController,
                      ),
                      columns: [
                        "number".tr,
                        "customer_name".tr,
                        "receipt_total".tr,
                        "date".tr,
                        "time".tr,
                        "paid_amount".tr,
                        "operation_type".tr,
                        "uploaded".tr
                      ]
                          .map(
                            (e) => DataColumn(
                              label: Expanded(
                                child: Container(
                                  color: Colors.green,
                                  width: screenWidth(context) * 0.15,
                                  child: Center(
                                    child: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const ReceiptsSummeryTable()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List filterList({required String input, required List<Map> receiptsList}) {
    if (filterSectionType == 0) {
      if (input != "") {
        return receiptsList.where((element) {
          return (element["user_name"].contains(input));
        }).toList();
      } else {
        return receiptsList;
      }
    } else {
      if (input != "") {
        return receiptsList.where((element) {
          return (element["user_name"].contains(input) &&
              element["section_type_no"] == filterSectionType);
        }).toList();
      } else {
        return receiptsList
            .where((element) => element["section_type_no"] == filterSectionType)
            .toList();
      }
    }
  }
}
