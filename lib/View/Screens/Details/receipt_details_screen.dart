import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
// ignore: implementation_imports
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/create_payment_pdf.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Widgets/Dialogs/return_dialog.dart';
import 'package:provider/provider.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  final Map receipt;
  const ReceiptDetailsScreen({Key? key, required this.receipt})
      : super(key: key);

  @override
  _ReceiptDetailsScreenState createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map> products = List.from(json.decode(widget.receipt["products"]));
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (layoutContext, constrains) {
            double width = constrains.maxWidth;
            double height = constrains.maxHeight;
            return Center(
              child: SizedBox(
                width: width * 0.98,
                height: height * 0.96,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: height * 0.09,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.01,
                            ),
                            decoration: const BoxDecoration(
                              color: whiteHaze,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: AutoSizeText(
                                widget.receipt["user_name"],
                                maxLines: 1,
                                style: GoogleFonts.cairo(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: height * 0.09,
                            decoration: const BoxDecoration(
                              color: smaltBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "date".tr,
                                      style: GoogleFonts.cairo(color: atlantis),
                                    ),
                                    TextSpan(
                                      text: ": " +
                                          widget.receipt["created_date"]
                                              .toString(),
                                      style: GoogleFonts.cairo(
                                          color: Colors.white),
                                    )
                                  ]),
                                ),
                                AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "time".tr,
                                      style: GoogleFonts.cairo(color: atlantis),
                                    ),
                                    TextSpan(
                                      text: ": " +
                                          widget.receipt["oper_time"]
                                              .toString(),
                                      style: GoogleFonts.cairo(
                                          color: Colors.white),
                                    )
                                  ]),
                                ),
                                AutoSizeText(
                                  titleSelect(
                                      widget.receipt["section_type_no"]),
                                  style: GoogleFonts.cairo(
                                    color: atlantis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.008),
                      decoration: const BoxDecoration(
                        color: smaltBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: "total_quantity".tr,
                                style: GoogleFonts.cairo(color: atlantis),
                              ),
                              TextSpan(
                                text: ": " +
                                    widget.receipt["items_count"].toString(),
                                style: GoogleFonts.cairo(color: Colors.white),
                              )
                            ]),
                          ),
                          AutoSizeText.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: "total_free_qty".tr,
                                style: GoogleFonts.cairo(color: atlantis),
                              ),
                              TextSpan(
                                text: ": " +
                                    itemsTotalFreeQty(items: products)
                                        .toString(),
                                style: GoogleFonts.cairo(color: Colors.white),
                              )
                            ]),
                          ),
                          AutoSizeText.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: "receipt_number".tr,
                                style: GoogleFonts.cairo(color: atlantis),
                              ),
                              TextSpan(
                                text: ": " +
                                    widget.receipt["oper_code"].toString(),
                                style: GoogleFonts.cairo(color: Colors.white),
                              )
                            ]),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: (widget.receipt['section_type_no'] ==
                                          1 ||
                                      widget.receipt['section_type_no'] == 3),
                                  child: OptionsButton(
                                    height: height * 0.06,
                                    color: Colors.blue,
                                    onPressed: () {
                                      showReturnDialog(
                                        context: context,
                                        receipt: widget.receipt,
                                      );
                                    },
                                    iconData: Icons.redo,
                                  ),
                                ),
                                SizedBox(
                                  height: width * 0.01,
                                ),
                                OptionsButton(
                                  height: height * 0.06,
                                  color: Colors.purple,
                                  onPressed: () async {
                                    EasyLoading.show();
                                    if (widget.receipt["section_type_no"] ==
                                            1 ||
                                        widget.receipt["section_type_no"] ==
                                            2) {
                                      await createPDF(
                                        bContext: context,
                                        receipt: widget.receipt,
                                      );
                                    } else {
                                      await createPaymentPDF(
                                        bContext: context,
                                        receipt: widget.receipt,
                                      );
                                    }
                                    EasyLoading.dismiss();
                                    // Navigator.pushNamed(
                                    //     context, Routes.printingRoute);
                                  },
                                  iconData: Icons.print,
                                ),
                                SizedBox(
                                  height: width * 0.01,
                                ),
                                OptionsButton(
                                  height: height * 0.06,
                                  color: Colors.red,
                                  iconData: Icons.arrow_back_ios,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(
                                  height: width * 0.01,
                                ),
                                OptionsButton(
                                  height: height * 0.06,
                                  color: Colors.green,
                                  onPressed: () async {
                                    await createPDF(
                                      bContext: context,
                                      receipt: context
                                          .read<GeneralState>()
                                          .receiptsList
                                          .last,
                                      share: true,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  iconData: Icons.share,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Expanded(
                            flex: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                      return Colors.red;
                                    }),
                                    headingRowHeight: height * 0.07,
                                    dataRowHeight: height * 0.1,
                                    columnSpacing: width * 0.066,
                                    border: TableBorder.all(
                                      width: 0.5,
                                      style: BorderStyle.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    columns: [
                                      "number".tr,
                                      "item".tr,
                                      "qty".tr,
                                      "quantity_before".tr,
                                      "quantity_remaining".tr,
                                      "price".tr,
                                      "discount".tr,
                                      "value".tr,
                                      "free_qty".tr
                                    ]
                                        .map(
                                          (e) => DataColumn(
                                            label: Text(
                                              e,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    rows: products.map<DataRow>((receipt) {
                                      final cell = [
                                        receipt["fat_det_id"],
                                        receipt["name"],
                                        receipt["fat_qty"],
                                        receipt["original_qty"],
                                        receipt["original_qty_after"],
                                        receipt["original_price"],
                                        receipt["fat_disc_value_with_tax"],
                                        receipt["original_fat_value"],
                                        receipt["free_qty"]
                                      ];
                                      return DataRow(
                                          cells: cell
                                              .mapIndexed((index, cell) =>
                                                  DataCell(Text(
                                                    textFilter(
                                                        index,
                                                        cell == null
                                                            ? "0.0"
                                                            : cell.toString()),
                                                    style: GoogleFonts.cairo(),
                                                  )))
                                              .toList());
                                    }).toList(),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Visibility(
                      visible: widget.receipt["section_type_no"] != 98,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: DataTable(
                              headingRowColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                return smaltBlue;
                              }),
                              headingRowHeight: height * 0.06,
                              dataRowHeight: height * 0.1,
                              columns: [
                                "receipt_value".tr,
                                "discount".tr,
                                "addition".tr,
                                "tax".tr,
                                "receipt_total".tr,
                                "paid_amount".tr,
                                "remaining_amount".tr,
                              ].map((e) {
                                return DataColumn(
                                    label: Expanded(
                                  child: Center(
                                    child: Text(
                                      e,
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ));
                              }).toList(),
                              rows: [
                                DataRow(
                                    cells: [
                                  "original_oper_value",
                                  "oper_disc_value_with_tax",
                                  "oper_add_value_with_tax",
                                  "tax_value",
                                  "oper_net_value_with_tax",
                                  "cash_value",
                                  "reside_value",
                                ]
                                        .map((e) => DataCell(Center(
                                                child: Text(
                                              ValuesManager.doubleToString(
                                                      widget.receipt[e])
                                                  .toString(),
                                              style: GoogleFonts.cairo(),
                                            ))))
                                        .toList())
                              ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  titleSelect(int sectionNo) {
    switch (sectionNo) {
      case 1:
        return "sales_receipt".tr;
      case 2:
        return "return_receipt".tr;
      case 3:
        return "purchase_receipt".tr;
      case 4:
        return "purchase_return_receipt".tr;
      case 5:
        return "stor_transfer".tr;
      case 17:
        return "selling_order".tr;
      case 18:
        return "purchase_order".tr;
      case 101:
        return "seizure_document".tr;
      case 102:
        return "payment_document".tr;
      case 103:
        return "mow_seizure_document".tr;
      case 104:
        return "mow_payment_document".tr;
      case 107:
        return "expenses_seizure_document".tr;
      case 98:
        return "inventory".tr;
      case 31:
        return "cashier_receipt".tr;
      case 108:
        return "expenses_document".tr;
      default:
        "";
    }
  }

  double itemsTotalFreeQty({required List<Map> items}) {
    return items.fold<double>(
        0, (double sum, receipt) => (sum + receipt["free_qty"]));
  }

  textFilter(int index, String text) {
    if ((index == 0) || (index == 1) || (index == 2) || (index == 6)) {
      return text.toString();
    } else {
      return double.parse(text.toString()).toStringAsFixed(3);
    }
  }
}
