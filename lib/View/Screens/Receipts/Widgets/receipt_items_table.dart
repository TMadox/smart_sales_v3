import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Resources/colors_manager.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_column.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';

class ReceiptItemsTable extends StatelessWidget {
  final Map data;
  final ReceiptsController receiptsController;
  final bool isEditing;
  const ReceiptItemsTable({
    Key? key,
    required this.data,
    required this.receiptsController,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: OptionsColumn(
            isEditing: isEditing,
            data: data,
            controller: receiptsController,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: (receiptsController
                              .currentReceipt.value["section_type_no"] ==
                          2)
                      ? Colors.red
                      : defaultGreen,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.hardEdge,
              child: Obx(
                () {
                  return SingleChildScrollView(
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (receiptsController
                                  .currentReceipt.value["section_type_no"] ==
                              2) {
                            return Colors.red;
                          }
                          return defaultGreen;
                        },
                      ),
                      headingRowHeight: 30,
                      dataRowHeight: 35,
                      showBottomBorder: true,
                      columnSpacing: 0,
                      horizontalMargin: 0,
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
                            onSelectChanged: isEditing
                                ? null
                                : (boolValue) {
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
