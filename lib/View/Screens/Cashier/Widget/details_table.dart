import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Widgets/Common/custom_cell.dart';

class DetailsTable extends StatelessWidget {
  final double width;
  final double height;
  final GeneralState generalState;
  final CashierController cashierController;
  const DetailsTable({
    Key? key,
    required this.width,
    required this.height,
    required this.generalState,
    required this.cashierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: darkBlue,
            width: 2,
          ),
        ),
        child: Obx(
          () {
            final selectedItems = cashierController.selectedItems.value;
            return DataTable(
              onSelectAll: (v) {},
              columnSpacing: width * 0.0,
              headingRowHeight: height * 0.13,
              dataRowHeight: height * 0.2,
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return darkBlue;
              }),
              columns: [
                "${"item".tr}\n${"unit".tr}",
                "${"qty".tr}\n${"free_qty".tr}",
                "${"price".tr}\n${"discount".tr}",
                "value".tr,
              ]
                  .map(
                    (e) => DataColumn(
                      label: Center(
                        child: SizedBox(
                          width: width * 0.2,
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: generalState.receiptItems.map(
                (item) {
                  return DataRow(
                    onSelectChanged: (v) {
                      cashierController.selectItem(
                        input: item,
                        value: v ?? false,
                      );
                    },
                    selected: selectedItems.contains(item),
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if ((generalState.receiptItems.indexOf(item) % 2) == 0) {
                        return Colors.grey[200];
                      }
                      return null;
                    }),
                    cells: [
                      DataCell(
                        Column(
                          children: [
                            Expanded(
                              child: CustomCell(
                                isEditable: false,
                                item: item,
                                keyValue: 'name',
                                generalState: generalState,
                                width: width,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable: false,
                                item: item,
                                keyValue: 'unit_convert',
                                width: width,
                                generalState: generalState,
                              ),
                            )
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          children: [
                            Expanded(
                              child: CustomCell(
                                isEditable: true,
                                item: item,
                                keyValue: 'fat_qty',
                                controller: item["fat_qty_controller"],
                                generalState: generalState,
                                width: width,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable:
                                    context.read<PowersState>().canEditFreeQty,
                                controller: item["free_qty_controller"],
                                item: item,
                                keyValue: 'free_qty',
                                width: width,
                                generalState: generalState,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Column(
                          children: [
                            Expanded(
                              child: CustomCell(
                                isEditable: context
                                    .read<PowersState>()
                                    .canEditItemPrice,
                                item: item,
                                keyValue: 'original_price',
                                controller: item["fat_price_controller"],
                                generalState: generalState,
                                width: width,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable: true,
                                controller: item["fat_disc_value_controller"],
                                item: item,
                                keyValue: 'fat_disc_value_with_tax',
                                width: width,
                                generalState: generalState,
                              ),
                            )
                          ],
                        ),
                      ),
                      DataCell(
                        CustomCell(
                          isEditable: false,
                          item: item,
                          keyValue: 'fat_value',
                          generalState: generalState,
                          width: width,
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
