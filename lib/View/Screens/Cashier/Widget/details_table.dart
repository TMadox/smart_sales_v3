import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_controller.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_cell.dart';

class DetailsTable extends StatelessWidget {
  final CashierController cashierController;
  const DetailsTable({
    Key? key,
    required this.cashierController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: darkBlue,
          width: 2,
        ),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Obx(
          () {
            final selectedItems = cashierController.selectedItems.value;
            return DataTable(
              onSelectAll: (v) {},
              columnSpacing: 0,
              headingRowHeight: 60,
              dataRowHeight: 60,
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
                          width: 80,
                          child: AutoSizeText(
                            e,
                            textAlign: TextAlign.center,
                            maxLines: 2,
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
              rows: cashierController.receiptItems.value.map(
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
                      if (selectedItems.contains(item)) {
                        return Colors.blue[100];
                      }
                      if ((cashierController.receiptItems.value.indexOf(item) %
                              2) ==
                          0) {
                        return Colors.yellow[50];
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
                                generalController: cashierController,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable: false,
                                item: item,
                                keyValue: 'unit_convert',
                                generalController: cashierController,
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
                                fillColor: Colors.transparent,
                                controller: item["fat_qty_controller"],
                                borderColor: Colors.transparent,
                                generalController: cashierController,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable:
                                    context.read<PowersState>().canEditFreeQty,
                                controller: item["free_qty_controller"],
                                fillColor: Colors.transparent,
                                item: item,
                                keyValue: 'free_qty',
                                generalController: cashierController,
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
                                generalController: cashierController,
                                fillColor: Colors.transparent,
                              ),
                            ),
                            Expanded(
                              child: CustomCell(
                                isEditable: true,
                                controller: item["fat_disc_value_controller"],
                                item: item,
                                fillColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                keyValue: 'fat_disc_value_with_tax',
                                generalController: cashierController,
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
                          generalController: cashierController,
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
