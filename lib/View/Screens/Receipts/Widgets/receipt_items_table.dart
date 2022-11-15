import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_cell.dart';
import 'package:smart_sales/View/Widgets/Common/options_column.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';

class ReceiptItemsTable extends StatefulWidget {
  final double width;
  final double height;
  final BuildContext context;
  final Map data;
  const ReceiptItemsTable({
    Key? key,
    required this.width,
    required this.height,
    required this.context,
    required this.data,
  }) : super(key: key);

  @override
  _ReceiptItemsTableState createState() => _ReceiptItemsTableState();
}

class _ReceiptItemsTableState extends State<ReceiptItemsTable> {
  List selected = [];
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OptionsColumn(
            height: widget.height,
            data: widget.data,
          ),
        ),
        SizedBox(
          width: widget.width * 0.01,
        ),
        Expanded(
          flex: 20,
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Consumer<GeneralState>(
                  builder: (context, generalState, child) {
                    return Consumer<ReceiptViewmodel>(
                      builder: (
                        BuildContext context,
                        ReceiptViewmodel receiptState,
                        Widget? child,
                      ) =>
                          Container(
                        alignment: AlignmentDirectional.topCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 0.5, color: Colors.black),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (context
                                      .read<GeneralState>()
                                      .currentReceipt["section_type_no"] ==
                                  2) {
                                return Colors.red;
                              }
                              return Colors.green;
                            },
                          ),
                          headingRowHeight: widget.height * 0.07,
                          dataRowHeight: widget.height * 0.08,
                          showBottomBorder: true,
                          columnSpacing: context
                                      .read<GeneralState>()
                                      .currentReceipt["section_type_no"] ==
                                  5
                              ? null
                              : (generalState.receiptItems.isEmpty
                                  ? widget.width * 0.1
                                  : 0),
                          horizontalMargin: context
                                      .read<GeneralState>()
                                      .currentReceipt["section_type_no"] ==
                                  5
                              ? null
                              : widget.width * 0.023,
                          dividerThickness: 1,
                          columns: (context
                                          .read<GeneralState>()
                                          .currentReceipt["section_type_no"] ==
                                      5
                                  ? [
                                      "number".tr,
                                      "unit".tr,
                                      "item".tr,
                                      "qty".tr,
                                    ]
                                  : [
                                      "number".tr,
                                      "unit".tr,
                                      "item".tr,
                                      "qty".tr,
                                      "price".tr,
                                      "discount".tr,
                                      "value".tr,
                                      "free_qty".tr
                                    ])
                              .map(
                                (e) => DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text(
                                        e,
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
                          rows: generalState.receiptItems.map(
                            (item) {
                              return DataRow(
                                color:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if ((generalState.receiptItems.indexOf(item) %
                                          2) ==
                                      0) {
                                    return Colors.grey[200];
                                  }
                                  return null;
                                }),
                                onSelectChanged: (boolValue) {
                                  receiptState.addNRemoveItem(
                                    item: item,
                                    value: boolValue!,
                                  );
                                },
                                selected:
                                    receiptState.selectedItems.contains(item),
                                cells: context
                                                .read<GeneralState>()
                                                .currentReceipt[
                                            "section_type_no"] ==
                                        5
                                    ? [
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'fat_det_id',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'unit_convert',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'name',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: true,
                                            item: item,
                                            keyValue: 'fat_qty',
                                            controller:
                                                item["fat_qty_controller"],
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                      ]
                                    : [
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'fat_det_id',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'unit_convert',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'name',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: true,
                                            item: item,
                                            keyValue: 'fat_qty',
                                            controller:
                                                item["fat_qty_controller"],
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: context
                                                .read<PowersState>()
                                                .canEditItemPrice,
                                            item: item,
                                            keyValue: 'original_price',
                                            controller:
                                                item["fat_price_controller"],
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: context
                                                .read<PowersState>()
                                                .canEditItemDisc,
                                            item: item,
                                            keyValue: 'fat_disc_value_with_tax',
                                            controller: item[
                                                "fat_disc_value_controller"],
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: false,
                                            item: item,
                                            keyValue: 'fat_value',
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                        DataCell(
                                          CustomCell(
                                            isEditable: context
                                                .read<PowersState>()
                                                .canEditFreeQty,
                                            item: item,
                                            keyValue: 'free_qty',
                                            controller:
                                                item["free_qty_controller"],
                                            width: widget.width,
                                            generalState: generalState,
                                          ),
                                        ),
                                      ],
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
        ),
      ],
    );
  }
}
