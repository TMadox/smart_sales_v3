import 'package:auto_size_text/auto_size_text.dart';
// ignore: implementation_imports
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Services/Repositories/upload_repo.dart';
import 'package:smart_sales/View/Screens/Items/Items_viewmodel.dart';
import 'package:smart_sales/Provider/customers_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Widgets/Dialogs/edit_price_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/error_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/loading_dialog.dart';

class ReceiptEditItems extends StatefulWidget {
  final double width;
  final double height;
  final BuildContext context;
  const ReceiptEditItems({
    Key? key,
    required this.width,
    required this.height,
    required this.context,
  }) : super(key: key);

  @override
  _ReceiptEditItemsViewmodel createState() => _ReceiptEditItemsViewmodel();
}

class _ReceiptEditItemsViewmodel extends State<ReceiptEditItems> {
  List selected = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                OptionsButton(
                  color: Colors.red,
                  iconData: Icons.undo,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: widget.width * 0.01,
                ),
                OptionsButton(
                  color: Colors.blue,
                  iconData: Icons.save,
                  onPressed: () async {
                    showAnimatedDialog(
                      context: context,
                      builder: (bcontext) {
                        return AlertDialog(
                          title: const Text(
                            "تاكيد",
                            style: TextStyle(color: Colors.black),
                          ),
                          content: const Text(
                            "تاكيد انشاء فتورة جديدة ",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  Navigator.of(context).pop();
                                  showLoaderDialog(context);
                                  await saveReceipt(context);
                                  if (await InternetConnectionChecker()
                                      .hasConnection) {
                                    await locator
                                        .get<UploadReceipts>()
                                        .requestUploadReceipts(
                                            context: context);
                                    await locator
                                        .get<SaveData>()
                                        .saveReceiptsData(
                                            input: context
                                                .read<GeneralState>()
                                                .receiptsList,
                                            context: context);
                                  }
                                  await createPDF(
                                      bContext: context,
                                      receipt: context
                                          .read<GeneralState>()
                                          .receiptsList
                                          .last,
                                      share: true);
                                } finally {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.homeRoute, (route) => false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "مشاركة",
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  showLoaderDialog(context);
                                  await saveReceipt(context);
                                  if (await InternetConnectionChecker()
                                      .hasConnection) {
                                    try {
                                      await locator
                                          .get<UploadReceipts>()
                                          .requestUploadReceipts(
                                              context: context);
                                      await locator
                                          .get<SaveData>()
                                          .saveReceiptsData(
                                              input: context
                                                  .read<GeneralState>()
                                                  .receiptsList,
                                              context: context);
                                    } finally {}
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text("حفظ")),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  showLoaderDialog(context);
                                  await saveReceipt(context);
                                  try {
                                    if (await InternetConnectionChecker()
                                        .hasConnection) {
                                      await locator
                                          .get<UploadReceipts>()
                                          .requestUploadReceipts(
                                              context: context);
                                      await locator
                                          .get<SaveData>()
                                          .saveReceiptsData(
                                              input: context
                                                  .read<GeneralState>()
                                                  .receiptsList,
                                              context: context);
                                    }
                                  } finally {}
                                  await createPDF(
                                      bContext: context,
                                      receipt: context
                                          .read<GeneralState>()
                                          .receiptsList
                                          .last);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text("حفظ مع طباعة")),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text("ألغاء"))
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: widget.width * 0.01,
                ),
                OptionsButton(
                  color: Colors.purple,
                  iconData: Icons.print,
                  onPressed: () async {
                    showLoaderDialog(context);
                    await createPDF(
                        bContext: context,
                        receipt:
                            context.read<GeneralState>().receiptsList.last);
                    Navigator.of(context).pop();
                    // Navigator.pushNamed(context, Routes.printingRoute);
                  },
                ),
                SizedBox(
                  height: widget.width * 0.01,
                ),
                OptionsButton(
                  color: Colors.pink,
                  iconData: Icons.arrow_back_ios,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.homeRoute,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: widget.width * 0.01,
          ),
          Expanded(
            flex: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Consumer<GeneralState>(
                    builder: (context, value, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
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
                          }),
                          headingRowHeight: widget.height * 0.07,
                          dataRowHeight: widget.height * 0.08,
                          showBottomBorder: true,
                          horizontalMargin: widget.width * 0.023,
                          border: TableBorder.all(
                            width: 0.5,
                            style: BorderStyle.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          dividerThickness: 1,
                          columnSpacing: value.receiptItems.isEmpty
                              ? widget.width * 0.1
                              : 0,
                          columns: [
                            "number".tr,
                            "unit".tr,
                            "item".tr,
                            "qty".tr,
                            "price".tr,
                            "discount".tr,
                            "value".tr,
                            "free_qty".tr,
                            "remaining".tr,
                            "متبقي مجاني"
                          ]
                              .map((e) => DataColumn(
                                      label: Expanded(
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )))
                              .toList(),
                          rows: value.receiptItems.mapIndexed((index, item) {
                            return DataRow(
                                color:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if ((value.receiptItems.indexOf(item) % 2) ==
                                      0) {
                                    return Colors.grey[200];
                                  }
                                  return null;
                                }),
                                onSelectChanged: (boolValue) {
                                  setState(() {
                                    if (boolValue == true) {
                                      selected.add(item);
                                    }
                                    if (boolValue == false) {
                                      selected.remove(item);
                                    }
                                  });
                                },
                                selected: selected.contains(item),
                                cells: [
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'fat_det_id',
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'unit_convert',
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'name',
                                  ),
                                  customDataCell(
                                    isEditable: true,
                                    item: item,
                                    key: 'fat_qty',
                                    controller: item["fat_qty_controller"],
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'original_price',
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'fat_disc_value_with_tax',
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'fat_value',
                                  ),
                                  customDataCell(
                                    isEditable: true,
                                    item: item,
                                    key: 'free_qty',
                                    controller: item["free_qty_controller"],
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: widget.width * 0.118,
                                      child: AutoSizeText(
                                        (item["qty_remain"] - item["fat_qty"])
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: GoogleFonts.cairo(),
                                      ),
                                    ),
                                  ),
                                  customDataCell(
                                    isEditable: false,
                                    item: item,
                                    key: 'free_qty_remain',
                                  ),
                                ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataCell customDataCell(
      {required bool isEditable,
      required String key,
      required Map item,
      bool canEdit = true,
      TextEditingController? controller}) {
    return DataCell(
      SizedBox(
        width: widget.width * 0.118,
        child: Center(
          child: Builder(builder: (context) {
            String unit = double.parse(item["unit_convert"].toString()) > 1.0
                ? item["unit_name"].toString() +
                    " " +
                    item["unit_convert"].toString()
                : item["unit_name"].toString();
            if (isEditable && key != "original_price") {
              final currentValue = item[key];
              return TextFormField(
                controller: controller,
                readOnly: !canEdit,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                keyboardType: TextInputType.number,
                onTap: () {
                  controller!.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.value.text.length);
                },
                onChanged: (value) {
                  try {
                    changeValue(
                        controller: controller!,
                        item: item,
                        value: value.toString(),
                        key: key);
                  } catch (e) {
                    controller!.text = currentValue.toString();
                    changeValue(
                        controller: controller,
                        item: item,
                        value: currentValue.toString(),
                        key: key);
                    showErrorDialog(
                        context: context,
                        description: e.toString(),
                        title: "error".tr);
                  }
                },
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(bottom: widget.height * 0.03)),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(),
              );
            } else if (isEditable && key == "original_price") {
              return InkWell(
                onTap: () {
                  showEditPriceDialog(
                    context: context,
                    leastSellingPrice:
                        item["least_selling_price_with_tax"].toString(),
                    itemPrice: item["original_price"].toString(),
                    originalPrice: item["original_price"].toString(),
                    item: item,
                  );
                },
                child: AutoSizeText(
                  ValuesManager.doubleToString(
                      double.parse(item[key].toString())),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: GoogleFonts.cairo(),
                ),
              );
            } else {
              return AutoSizeText(
                key == "unit_convert" ? unit : item[key].toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.cairo(),
              );
            }
          }),
        ),
      ),
    );
  }

  saveReceipt(BuildContext context) async {
    context.read<GeneralState>().setRemainingQty();
    await context.read<GeneralState>().computeReceipt(context: context);
    await locator.get<SaveData>().saveReceiptsData(
        input: context.read<GeneralState>().receiptsList, context: context);
    await locator
        .get<SaveData>()
        .saveItemsData(input: context.read<ItemsViewmodel>().items);
    await locator
        .get<SaveData>()
        .saveCustomersData(input: context.read<CustomersState>().customers);
  }

  changeValue(
      {item,
      required String key,
      required TextEditingController controller,
      value}) {
    if (value != "" && value != ".") {
      if (key == "fat_qty" || key == "free_qty") {
        context
            .read<GeneralState>()
            .changeItemValue(item: item, input: {key: double.parse(value)});
      } else {
        context
            .read<GeneralState>()
            .changeItemValue(item: item, input: {key: double.parse(value)});
      }
    } else {
      controller.text = (key == "fat_qty") ? 1.toString() : 0.toString();
      controller.selection = TextSelection(
          baseOffset: 0, extentOffset: controller.value.text.length);
      context.read<GeneralState>().changeItemValue(
          item: item, input: {key: (key == "fat_qty") ? 1 : 0.0});
    }
  }
}
