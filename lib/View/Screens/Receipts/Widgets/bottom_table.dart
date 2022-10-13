import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Models/client_model.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Receipts/Widgets/bottom_table_cell.dart';


class BottomTable extends StatefulWidget {
  final ClientsModel customer;
  final double height;
  final double width;
  final List<TextEditingController> controllers;

  const BottomTable({
    Key? key,
    required this.customer,
    required this.height,
    required this.width,
    required this.controllers,
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
    double height = widget.height;
    double width = widget.width;

    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<GeneralState>(
          builder: (context, state, w) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return smaltBlue;
                }),
                headingRowHeight: height * 0.06,
                dataRowHeight: height * 0.1,
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
                          width: width * 0.1,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.customer.curBalance.toString(),
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
                          width: width * 0.1,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(
                                      state.currentReceipt['oper_value'])
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
                          state: state,
                        ),
                      ),
                      DataCell(
                        BottomTableCell(
                          keyName: "oper_add_value",
                          controller: controllers[1],
                          readOnly: false,
                          state: state,
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: width * 0.1,
                          child: Text(
                            ValuesManager.doubleToString(
                                state.currentReceipt['tax_value']),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ValuesManager.doubleToString(state
                                .currentReceipt['oper_net_value_with_tax']),
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
                          state: state,
                          readOnly:
                              state.currentReceipt["pay_by_cash_only"] == 1,
                          color: Colors.orange,
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: width * 0.1,
                          child: Text(
                            ValuesManager.doubleToString(
                                state.currentReceipt['reside_value']),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: width * 0.1,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            creditAfter(
                              context: context,
                              reside: state.currentReceipt['reside_value'],
                            ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  creditAfter({required BuildContext context, required double? reside}) {
    if (context.read<GeneralState>().currentReceipt["section_type_no"] == 1) {
      return ((widget.customer.curBalance ?? 0.0) + (reside ?? 0.0))
          .toStringAsFixed(3);
    } else {
      return ((widget.customer.curBalance ?? 0.0) - (reside ?? 0.0))
          .toStringAsFixed(3);
    }
  }
}
