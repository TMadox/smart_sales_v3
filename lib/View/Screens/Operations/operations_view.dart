// ignore_for_file: implementation_imports
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Operations/Widgets/receipts_summery_table.dart';
import 'package:smart_sales/View/Screens/Operations/operations_source.dart';
import 'package:smart_sales/View/Screens/Operations/operations_viewmodel.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  bool isLoading = false;
  String searchWord = "";
  int filterSectionType = 0;
  OperationsViewmodel operationsViewmodel = OperationsViewmodel();
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
                      setState(() {
                        searchWord = p0!;
                      });
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
                        value: 51,
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
                  await operationsViewmodel.uploadReceipts(context);
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
        body: Consumer<GeneralState>(
          builder: (BuildContext context, GeneralState state, Widget? w) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                double height = constraints.maxHeight;
                return ModalProgressHUD(
                  inAsyncCall: isLoading,
                  progressIndicator: const CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: width * 0.98,
                        height: height * 0.95,
                        child: Column(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                "last_upload_date".tr +
                                    ": " +
                                    (context
                                            .read<UserState>()
                                            .user
                                            .uploadDate ??
                                        ".."),
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SingleChildScrollView(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: PaginatedDataTable(
                                    arrowHeadColor: Colors.green,
                                    headingRowHeight: height * 0.09,
                                    dataRowHeight: height * 0.1,
                                    horizontalMargin: 0,
                                    columnSpacing: 0,
                                    source: OperationsSource(
                                        context: context,
                                        receipts: filterList(
                                          input: searchWord,
                                          receiptsList: state.receiptsList,
                                        )),
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
                                                width:
                                                    screenWidth(context) * 0.15,
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
                                  ),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            ReceiptsSummeryTable(
                              height: height,
                              width: width,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
