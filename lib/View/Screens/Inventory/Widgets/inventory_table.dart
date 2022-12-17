// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_sales/Provider/general_state.dart';
// import 'package:smart_sales/View/Common/Widgets/Dialogs/edit_price_dialog.dart';
// import 'package:smart_sales/View/Common/Widgets/Dialogs/error_dialog.dart';

// class InventoryTable extends StatefulWidget {
//   final Map data;
//   const InventoryTable({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   @override
//   _InventoryTableState createState() => _InventoryTableState();
// }

// class _InventoryTableState extends State<InventoryTable> {
//   List selected = [];

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Expanded(
//         //     child: OptionsColumn(
//         //   data: widget.data,
//         //   controller: null,
//         // )),
//         Expanded(
//           flex: 20,
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: SingleChildScrollView(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: DataTable(
//                       headingRowColor:
//                           MaterialStateProperty.resolveWith<Color?>(
//                               (Set<MaterialState> states) {
//                         // if (context
//                         //         .read<GeneralState>()
//                         //         .currentReceipt["section_type_no"] ==
//                         //     2) {
//                         //   return Colors.red;
//                         // }
//                         return Colors.green;
//                       }),
//                       headingRowHeight: 30,
//                       dataRowHeight: 30,
//                       showBottomBorder: true,
//                       // horizontalMargin: widget.width * 0.023,
//                       border: TableBorder.all(
//                           width: 0.5,
//                           style: BorderStyle.none,
//                           borderRadius: BorderRadius.circular(15)),
//                       dividerThickness: 1,
//                       // columnSpacing: generalState.receiptItems.isEmpty
//                       //     ? widget.width * 0.1
//                       //     : 0,
//                       columns: [
//                         "number".tr,
//                         "unit".tr,
//                         "item".tr,
//                         "qty".tr,
//                         "remaining_qty".tr,
//                       ]
//                           .map(
//                             (e) => DataColumn(
//                               label: Expanded(
//                                 child: Center(
//                                   child: Text(
//                                     e,
//                                     style: GoogleFonts.cairo(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       rows: generalState.receiptItems.map((item) {
//                         return DataRow(
//                             color: MaterialStateProperty.resolveWith<Color?>(
//                                 (Set<MaterialState> states) {
//                               if ((generalState.receiptItems.indexOf(item) %
//                                       2) ==
//                                   0) {
//                                 return Colors.grey[200];
//                               }
//                               return null;
//                             }),
//                             onSelectChanged: (boolValue) {
//                               // receiptState.addNRemoveItem(
//                               //   item: item,
//                               //   value: boolValue!,
//                               // );
//                             },
//                             selected: receiptState.selectedItems.contains(item),
//                             cells: [
//                               customDataCell(
//                                 isEditable: false,
//                                 item: item,
//                                 key: 'fat_det_id',
//                               ),
//                               customDataCell(
//                                 isEditable: false,
//                                 item: item,
//                                 key: 'unit_convert',
//                               ),
//                               customDataCell(
//                                 isEditable: false,
//                                 item: item,
//                                 key: 'name',
//                               ),
//                               customDataCell(
//                                 isEditable: true,
//                                 item: item,
//                                 key: 'fat_qty',
//                                 controller: item["fat_qty_controller"],
//                               ),
//                               customDataCell(
//                                 isEditable: false,
//                                 item: item,
//                                 key: 'original_qty_after',
//                               ),
//                             ]);
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   DataCell customDataCell(
//       {required bool isEditable,
//       required String key,
//       required Map item,
//       bool canEdit = true,
//       TextEditingController? controller}) {
//     return DataCell(
//       SizedBox(
//         width: widget.width * 0.118,
//         child: Center(
//           child: Builder(builder: (context) {
//             String unit = double.parse(item["unit_convert"].toString()) > 1.0
//                 ? item["unit_name"].toString() +
//                     " " +
//                     item["unit_convert"].toString()
//                 : item["unit_name"].toString();
//             if (isEditable && key != "original_price") {
//               final currentValue = item[key];
//               return TextFormField(
//                 controller: controller,
//                 readOnly: !canEdit,
//                 scrollPadding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//                   FilteringTextInputFormatter.deny("")
//                 ],
//                 onTap: () {
//                   controller!.selection = TextSelection(
//                       baseOffset: 0,
//                       extentOffset: controller.value.text.length);
//                 },
//                 onChanged: (value) {
//                   try {
//                     changeValue(
//                         controller: controller!,
//                         item: item,
//                         value: value.toString(),
//                         key: key);
//                   } catch (e) {
//                     controller!.text = currentValue.toString();
//                     changeValue(
//                         controller: controller,
//                         item: item,
//                         value: currentValue.toString(),
//                         key: key);
//                     showErrorDialog(
//                       context: context,
//                       description: e.toString(),
//                       title: "error".tr,
//                     );
//                   }
//                 },
//                 decoration: InputDecoration(
//                     contentPadding:
//                         EdgeInsets.only(bottom: widget.height * 0.03)),
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.cairo(),
//               );
//             } else if (isEditable && key == "original_price") {
//               return InkWell(
//                 onTap: () {
//                   showEditPriceDialog(
//                     context: context,
//                     leastSellingPrice:
//                         item["least_selling_price_with_tax"].toString(),
//                     itemPrice: item["original_price"].toString(),
//                     item: item,
//                     originalPrice: item["original_price"].toString(),
//                   );
//                 },
//                 child: AutoSizeText(
//                   item[key].toString(),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   style: GoogleFonts.cairo(),
//                 ),
//               );
//             } else {
//               return AutoSizeText(
//                 key == "unit_convert" ? unit : item[key].toString(),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 style: GoogleFonts.cairo(),
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }

//   saveReceipt({required BuildContext context}) async {
//     await context.read<GeneralState>().computeReceipt(context: context);
//   }

//   changeValue(
//       {item,
//       required String key,
//       required TextEditingController controller,
//       value}) {
//     if (value != "" && value != ".") {
//       if (key == "fat_qty" || key == "free_qty") {
//         context
//             .read<GeneralState>()
//             .changeItemValue(item: item, input: {key: double.parse(value)});
//       } else {
//         context
//             .read<GeneralState>()
//             .changeItemValue(item: item, input: {key: double.parse(value)});
//       }
//     } else {
//       controller.text = (key == "fat_qty") ? 1.toString() : 0.0.toString();
//       controller.selection = TextSelection(
//           baseOffset: 0, extentOffset: controller.value.text.length);
//       context.read<GeneralState>().changeItemValue(
//           item: item, input: {key: (key == "fat_qty") ? 1 : 0.0});
//     }
//   }
// }
