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
import 'package:smart_sales/View/Common/Features/receipt_type.dart';
import 'package:smart_sales/View/Common/Widgets/Common/options_button.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/return_dialog.dart';

class DetailsView extends StatefulWidget {
  final Map receipt;
  const DetailsView({Key? key, required this.receipt}) : super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    List<Map> products = List.from(json.decode(widget.receipt["products"]));
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: whiteHaze,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
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
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: smaltBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              15,
                            ),
                            topRight: Radius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AutoSizeText.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: "date".tr + " ",
                                  style: GoogleFonts.cairo(color: atlantis),
                                ),
                                TextSpan(
                                  text: ": " + widget.receipt["created_date"],
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                  ),
                                )
                              ]),
                            ),
                            AutoSizeText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "time".tr + " ",
                                    style: GoogleFonts.cairo(
                                      color: atlantis,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ": " +
                                        widget.receipt["oper_time"].toString(),
                                    style:
                                        GoogleFonts.cairo(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            AutoSizeText(
                              ReceiptType()
                                  .get(type: widget.receipt["section_type_no"]),
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
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                height: 30,
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
                    Expanded(
                      child: Center(
                        child: AutoSizeText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "total_quantity".tr,
                                style: GoogleFonts.cairo(
                                  color: atlantis,
                                ),
                              ),
                              TextSpan(
                                text: ": ",
                                style: GoogleFonts.cairo(
                                  color: atlantis,
                                ),
                              ),
                              TextSpan(
                                text: widget.receipt["items_count"].toString(),
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "total_free_qty".tr,
                              style: GoogleFonts.cairo(color: atlantis),
                            ),
                            TextSpan(
                              text: ": " +
                                  (widget.receipt["free_items_count"] ?? 0)
                                      .toString(),
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: (widget.receipt['section_type_no'] == 1 ||
                                widget.receipt['section_type_no'] == 3),
                            child: OptionsButton(
                              height: 30,
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
                          const SizedBox(
                            height: 5,
                          ),
                          OptionsButton(
                            height: 30,
                            color: Colors.purple,
                            onPressed: () async {
                              EasyLoading.show();
                              if (widget.receipt["section_type_no"] == 1 ||
                                  widget.receipt["section_type_no"] == 2) {
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
                            },
                            iconData: Icons.print,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          OptionsButton(
                            height: 30,
                            color: Colors.red,
                            iconData: Icons.arrow_back_ios,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          OptionsButton(
                            height: 30,
                            color: Colors.green,
                            onPressed: () async {
                              await createPDF(
                                bContext: context,
                                receipt: widget.receipt,
                                share: true,
                              );
                              Navigator.of(context).pop();
                            },
                            iconData: Icons.share,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
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
                              headingRowColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                return Colors.red;
                              }),
                              headingRowHeight: 30,
                              dataRowHeight: 30,
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
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            e,
                                            textAlign: TextAlign.center,
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
                                        .mapIndexed(
                                          (index, cell) => DataCell(
                                            Center(
                                              child: Text(
                                                textFilter(
                                                    index,
                                                    cell == null
                                                        ? "0.0"
                                                        : cell.toString()),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.cairo(),
                                              ),
                                            ),
                                          ),
                                        )
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
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: widget.receipt["section_type_no"] != 98,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.resolveWith<Color?>(
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
                              .map(
                                (e) => DataCell(
                                  Center(
                                    child: Text(
                                      ValuesManager.doubleToString(
                                              widget.receipt[e])
                                          .toString(),
                                      style: GoogleFonts.cairo(),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
