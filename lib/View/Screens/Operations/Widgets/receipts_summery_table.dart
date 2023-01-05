import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/View/Common/Features/receipt_type.dart';

class ReceiptsSummeryTable extends StatelessWidget {
  const ReceiptsSummeryTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
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
        headingRowHeight: 30,
        dataRowHeight: 30,
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
                            ReceiptType().get(type: type),
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
                            ValuesManager.numToString(
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
                            ValuesManager.numToString(
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
                              ValuesManager.numToString(
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
                            ValuesManager.numToString(totalValues(
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
                            ValuesManager.numToString(
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
                            ValuesManager.numToString(
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
    );
  }

  double totalValues(
      {required BuildContext context, required int type, required String key}) {
    final List<Map> operations = ReadData().readOperations();
    if (type == 1) {
      if (key == "oper_value") {
        return operations
            .where((element) => (element["section_type_no"] == type))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      } else {
        return operations
            .where((element) => (element["section_type_no"] == type ||
                element["section_type_no"] == 101 ||
                element["section_type_no"] == 31 ||
                element["section_type_no"] == 3 ||
                element["section_type_no"] == 107 ||
                element["section_type_no"] == 105 ||
                element["section_type_no"] == 103))
            .fold<double>(
                0, (double sum, receipt) => sum + (receipt[key] ?? 0));
      }
    } else if (type == 2) {
      if (key == "oper_value") {
        return operations
            .where((element) => (element["section_type_no"] == type))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      } else {
        return operations
            .where((element) => (element["section_type_no"] == type ||
                element["section_type_no"] == 102 ||
                element["section_type_no"] == 4 ||
                element["section_type_no"] == 106 ||
                element["section_type_no"] == 108 ||
                element["section_type_no"] == 104))
            .fold<double>(0, (double sum, receipt) => sum + receipt[key]);
      }
    } else {
      if (key == "oper_value") {
        return (operations
                .where((element) => (element["section_type_no"] == 1))
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]) -
            operations
                .where((element) => (element["section_type_no"] == 2))
                .fold<double>(0, (double sum, receipt) => sum + receipt[key]));
      } else {
        return (operations
                .where(
                  (element) => (element["section_type_no"] == 1 ||
                      element["section_type_no"] == 101 ||
                      element["section_type_no"] == 3 ||
                      element["section_type_no"] == 31 ||
                      element["section_type_no"] == 107 ||
                      element["section_type_no"] == 103),
                )
                .fold<double>(
                    0, (double sum, receipt) => sum + (receipt[key] ?? 0)) -
            operations
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
