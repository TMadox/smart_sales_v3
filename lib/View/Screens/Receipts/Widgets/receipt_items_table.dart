import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_column.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class ReceiptItemsTable extends StatelessWidget {
  final Map data;
  final ReceiptsController receiptsController;
  const ReceiptItemsTable({
    Key? key,
    required this.data,
    required this.receiptsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OptionsColumn(
            data: data,
            controller: receiptsController,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 20,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: (receiptsController
                              .currentReceipt.value["section_type_no"] ==
                          2)
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.hardEdge,
              child: Obx(
                () {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (receiptsController
                                    .currentReceipt.value["section_type_no"] ==
                                2) {
                              return Colors.red;
                            }
                            return Colors.green;
                          },
                        ),
                        headingRowHeight: 30,
                        dataRowHeight: 35,
                        showBottomBorder: true,
                        dividerThickness: 1,
                        columns: receiptsController
                            .itemTableColumns()
                            .map(
                              (title) => DataColumn(
                                label: Expanded(
                                  child: Center(
                                    child: Text(
                                      title.tr,
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        rows: receiptsController.receiptItems.value.map(
                          (item) {
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if ((receiptsController.receiptItems.value
                                            .indexOf(item) %
                                        2) ==
                                    0) {
                                  return Colors.grey[200];
                                }
                                return null;
                              }),
                              onSelectChanged: (boolValue) {
                                receiptsController.addNRemoveItem(
                                  item: item,
                                  value: boolValue!,
                                );
                              },
                              selected: receiptsController.selectedItems.value
                                  .contains(item),
                              cells: receiptsController.itemTableDataCells(
                                item,
                                context,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
