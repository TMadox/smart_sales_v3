import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/colors_manager.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/entity.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/bottom_table_cell.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class BottomTable extends StatefulWidget {
  final Entity customer;
  final List<TextEditingController> controllers;
  final ReceiptsController receiptsController;
  const BottomTable({
    Key? key,
    required this.customer,
    required this.controllers,
    required this.receiptsController,
  }) : super(key: key);

  @override
  _BottomTableState createState() => _BottomTableState();
}

class _BottomTableState extends State<BottomTable> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late List<TextEditingController> controllers;
  @override
  void initState() {
    controllers = widget.controllers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GetBuilder<ReceiptsController>(builder: (controller) {
            return DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return defaultGreen;
              }),
              border: TableBorder.all(
                width: 0.5,
                style: BorderStyle.none,
                borderRadius: BorderRadius.circular(15),
              ),
              headingRowHeight: 30,
              dataRowHeight: 35,
              columnSpacing: 5,
              columns: [
                "previous_credit".tr,
                "receipt_value".tr,
                "discount".tr,
                "addition".tr,
                "tax".tr,
                "receipt_total".tr,
                "cash".tr,
                "remaining".tr,
                "current_credit".tr,
              ]
                  .map(
                    (e) => DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            e,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: [
                DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ValuesManager.numToString(
                              controller.currentReceipt.value['credit_before']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            ValuesManager.numToString(controller
                                    .currentReceipt.value['oper_value'])
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      BottomTableCell(
                        keyName: "oper_disc_value",
                        controller: controllers[0],
                        readOnly: false,
                        receiptsController: widget.receiptsController,
                      ),
                    ),
                    DataCell(
                      BottomTableCell(
                        keyName: "oper_add_value",
                        controller: controllers[1],
                        readOnly: false,
                        receiptsController: widget.receiptsController,
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: Text(
                          ValuesManager.numToString(widget.receiptsController
                              .currentReceipt.value['tax_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ValuesManager.numToString(widget.receiptsController
                              .currentReceipt.value['oper_net_value_with_tax']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      BottomTableCell(
                        keyName: "cash_value",
                        controller: controllers[3],
                        receiptsController: widget.receiptsController,
                        readOnly: widget.receiptsController.currentReceipt
                                .value["pay_by_cash_only"] ==
                            1,
                        color: Colors.orange,
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: Text(
                          ValuesManager.numToString(widget.receiptsController
                              .currentReceipt.value['reside_value']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ValuesManager.numToString(
                              controller.currentReceipt.value['credit_after']),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  creditAfter({required double? reside}) {
    if (widget.receiptsController.currentReceipt.value["section_type_no"] ==
        1) {
      return ((widget.customer.curBalance) + (reside ?? 0.0))
          .toStringAsFixed(3);
    } else {
      return ((widget.customer.curBalance) - (reside ?? 0.0))
          .toStringAsFixed(3);
    }
  }
}
