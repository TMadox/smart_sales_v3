import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:provider/provider.dart';

class ReceiptsSummeryTable extends StatelessWidget {
  final double width;
  final double height;
  const ReceiptsSummeryTable({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.98,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return smaltBlue;
          }),
          border: TableBorder.all(
            width: 0.5,
            style: BorderStyle.none,
            borderRadius: BorderRadius.circular(15),
          ),
          headingRowHeight: height * 0.07,
          dataRowHeight: height * 0.07,
          horizontalMargin: 0,
          columnSpacing: 0,
          columns: [
            "operation_type".tr,
            "final_value".tr,
            "total_discounts".tr,
            "total_additions".tr,
            "total_tax".tr,
            "total_value".tr,
            "total_cash".tr,
          ]
              .map((e) => DataColumn(
                      label: Expanded(
                    child: Center(
                      child: Text(
                        e,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )))
              .toList(),
          rows: [
            ...[1, 2, 0]
                .map(
                  (type) => DataRow(
                    cells: [
                      DataCell(
                        Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              receiptType(type: type),
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(
                                totalValues(
                                  context: context,
                                  type: type,
                                  key: "oper_value",
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: type == 0 ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(
                                totalValues(
                                  context: context,
                                  type: type,
                                  key: "oper_disc_value",
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: type == 0 ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Container(
                              color: type == 0 ? Colors.red : null,
                              child: Text(
                                ValuesManager.doubleToString(
                                  totalValues(
                                    context: context,
                                    type: type,
                                    key: "oper_add_value",
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  color: type == 0 ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(totalValues(
                                context: context,
                                type: type,
                                key: "tax_value",
                              )),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: type == 0 ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(
                                totalValues(
                                  context: context,
                                  type: type,
                                  key: "oper_net_value_with_tax",
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: type == 0 ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: type == 0 ? Colors.red : null,
                          child: Center(
                            child: Text(
                              ValuesManager.doubleToString(
                                totalValues(
                                  context: context,
                                  type: type,
                                  key: "cash_value",
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                color: type == 0 ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  String receiptType({required int type}) {
    switch (type) {
      case 0:
        return "total".tr;
      case 1:
        return "sales".tr;
      case 2:
        return "return".tr;
      case 3:
        return "purchase".tr;
      case 4:
        return "purchase_return".tr;
      case 101:
        return "seizure_document".tr;
      case 31:
        return "cashier_receipt".tr;
      default:
        return "sales".tr;
    }
  }

  double totalValues(
      {required BuildContext context, required int type, required String key}) {
    if (type == 1) {
      if (key == "oper_value") {
        return context
            .read<GeneralState>()
            .receiptsList
            .where((element) => (element["section_type_no"] == type))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      } else {
        return context
            .read<GeneralState>()
            .receiptsList
            .where((element) => (element["section_type_no"] == type ||
                element["section_type_no"] == 101 ||
                element["section_type_no"] == 31 ||
                element["section_type_no"] == 3 ||
                element["section_type_no"] == 107 ||
                element["section_type_no"] == 103))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      }
    } else if (type == 2) {
      if (key == "oper_value") {
        return context
            .read<GeneralState>()
            .receiptsList
            .where((element) => (element["section_type_no"] == type))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      } else {
        return context
            .read<GeneralState>()
            .receiptsList
            .where((element) => (element["section_type_no"] == type ||
                element["section_type_no"] == 102 ||
                element["section_type_no"] == 4 ||
                element["section_type_no"] == 108 ||
                element["section_type_no"] == 104))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      }
    } else {
      if (key == "oper_value") {
        return (context
                .read<GeneralState>()
                .receiptsList
                .where((element) => (element["section_type_no"] == 1))
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]) -
            context
                .read<GeneralState>()
                .receiptsList
                .where((element) => (element["section_type_no"] == 2))
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]));
      } else {
        return (context
                .read<GeneralState>()
                .receiptsList
                .where((element) => (element["section_type_no"] == 1 ||
                    element["section_type_no"] == 101 ||
                    element["section_type_no"] == 3 ||
                    element["section_type_no"] == 31 ||
                    element["section_type_no"] == 107 ||
                    element["section_type_no"] == 103))
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]) -
            context
                .read<GeneralState>()
                .receiptsList
                .where(
                  (element) => (element["section_type_no"] == 2 ||
                      element["section_type_no"] == 102 ||
                      element["section_type_no"] == 4 ||
                      element["section_type_no"] == 108 ||
                      element["section_type_no"] == 104),
                )
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]));
      }
    }
  }
}
