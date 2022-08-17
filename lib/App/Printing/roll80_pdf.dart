import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/create_qr.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/options_state.dart';

Future<pw.Page> roll80Pdf({
  required Map receipt,
  required BuildContext bContext,
  bool share = false,
  required pw.Font arabic,
  required SharedPreferences storage,
  required String paper,
}) async {
  String title = await chooseTitle(
    sectionTypeNo: receipt["section_type_no"],
    prefs: storage,
  );
  Uint8List qrImage = await createQrCode(
    info: bContext.read<InfoState>().info,
    receipt: receipt,
  );
  bool createQr = bContext.read<OptionsState>().options[2].optionValue == 1;
  PdfPageFormat pageFormat() {
    switch (paper) {
      case "roll80":
        return PdfPageFormat.roll80;
      case "roll57":
        return PdfPageFormat.roll57;
      default:
        return PdfPageFormat.roll80;
    }
  }

  return pw.Page(
      pageFormat: pageFormat(),
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            children: [
              storage.getBool("company_name") ?? true
                  ? pw.Container(
                      width: double.infinity,
                      child: pw.Text(
                        bContext.read<InfoState>().info.companyName.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: arabic,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                    )
                  : pw.SizedBox(),
              storage.getBool("company_address") ?? true
                  ? pw.Column(
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Container(
                          child: pw.Align(
                            alignment: pw.Alignment.topCenter,
                            child: pw.Text(
                              bContext
                                  .read<InfoState>()
                                  .info
                                  .companyAddress
                                  .toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: arabic,
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(5),
                            ),
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                        ),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("company_tax") ?? true
                  ? pw.Column(
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Container(
                              padding:
                                  const pw.EdgeInsets.symmetric(horizontal: 5),
                              decoration: pw.BoxDecoration(
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(5),
                                ),
                                border: pw.Border.all(color: PdfColors.black),
                              ),
                              child: pw.Text(
                                bContext
                                    .read<InfoState>()
                                    .info
                                    .companyTax
                                    .toString(),
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            pw.Text(
                              "tax_number".tr + ": ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                font: arabic,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : pw.SizedBox(),
              pw.Divider(),
              pw.Text(
                title,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  font: arabic,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              pw.Divider(),
              storage.getBool("receipt_number") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerRight,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  receipt["oper_code"].toString(),
                                  style: pw.TextStyle(
                                    font: arabic,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "receipt_number".tr + ": ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("receipt_date") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerRight,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  receipt["created_date"].toString() +
                                      "  -  " +
                                      receipt["oper_time"].toString(),
                                  style: pw.TextStyle(font: arabic),
                                ),
                              ),
                            ),
                            pw.Expanded(
                                child: pw.Text(
                              "date".tr + ": ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                font: arabic,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            )),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("employee_name") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerRight,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  receipt["employee_name"],
                                  style: pw.TextStyle(
                                    font: arabic,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "employee".tr + ": ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("customer_name") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerRight,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  ValuesManager.doubleToString(
                                    receipt["user_name"],
                                  ),
                                  style: pw.TextStyle(font: arabic),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "customer".tr + ": ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("customer_tax") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerRight,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  receipt["cst_tax"],
                                  style: pw.TextStyle(font: arabic),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "tax_number".tr + ": ",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    )
                  : pw.SizedBox(),
              _createItemsTable(receipt: receipt, font: arabic),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        ValuesManager.doubleToString(
                          receipt["original_oper_value"],
                        ),
                        style: pw.TextStyle(
                          font: arabic,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "final_value".tr + ":",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: arabic,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        ValuesManager.doubleToString(
                          receipt["oper_disc_value_with_tax"],
                        ),
                        style: pw.TextStyle(
                          font: arabic,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "discount".tr + ":",
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: arabic,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        ValuesManager.doubleToString(
                          receipt["oper_add_value_with_tax"],
                        ),
                        style: pw.TextStyle(
                          font: arabic,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "addition".tr + ":",
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: arabic,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        ValuesManager.doubleToString(
                          receipt["tax_value"] is double
                              ? receipt["tax_value"].toStringAsFixed(2)
                              : receipt["tax_value"].toString(),
                        ),
                        style: pw.TextStyle(
                          font: arabic,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "tax".tr + ":",
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: arabic,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(5),
                        ),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Text(
                        ValuesManager.doubleToString(
                          receipt["oper_net_value_with_tax"],
                        ),
                        style: pw.TextStyle(
                          font: arabic,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "total".tr + ":",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        font: arabic,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              pw.Divider(),
              storage.getBool("paid_amount") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerLeft,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  ValuesManager.doubleToString(
                                    receipt["cash_value"],
                                  ),
                                  style: pw.TextStyle(
                                    font: arabic,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "cash".tr + ":",
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        pw.SizedBox(height: 5),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("remaining_amount") ?? true
                  ? pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5),
                                alignment: pw.Alignment.centerLeft,
                                decoration: pw.BoxDecoration(
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(5),
                                  ),
                                  border: pw.Border.all(color: PdfColors.black),
                                ),
                                child: pw.Text(
                                  ValuesManager.doubleToString(
                                    receipt["reside_value"],
                                  ),
                                  style: pw.TextStyle(
                                    font: arabic,
                                  ),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "remaining".tr + ":",
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : pw.SizedBox(),
              pw.Divider(),
              storage.getBool("credit_before") ?? true
                  ? pw.Text(
                      ValuesManager.doubleToString(
                        receipt["credit_before"],
                      ),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          font: arabic,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold),
                    )
                  : pw.SizedBox(),
              pw.Divider(endIndent: 55, indent: 55),
              storage.getBool("credit_after") ?? true
                  ? pw.Text(
                      ValuesManager.doubleToString(
                        receipt["credit_after"],
                      ),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          font: arabic,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold),
                    )
                  : pw.SizedBox(),
              pw.Divider(),
              createQr
                  ? pw.Image(
                      pw.MemoryImage(qrImage),
                    )
                  : pw.SizedBox(),
              pw.Divider(),
              pw.Text(
                receipt["notes"],
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: arabic, fontSize: 15, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        );
      });
}

pw.Table _createItemsTable({required Map receipt, required font}) {
  List headers = [
    "item".tr,
    "quantity".tr,
    "price".tr,
    "value".tr,
  ];
  List<dynamic> items = json.decode(
    receipt["products"],
  );

  final data = items.map((item) {
    return [
      (item["name"].toString() +
          " \n" +
          "(" +
          item["barcode"].toString() +
          ")"),
      (ValuesManager.doubleToString(
            item["fat_qty"],
          ) +
          "\n" +
          "(" +
          item["free_qty"].toString() +
          ")"),
      (ValuesManager.doubleToString(
            item["original_price"],
          ) +
          "\n" +
          "(" +
          ValuesManager.doubleToString(
            item["fat_disc_value_with_tax"],
          ) +
          ")"),
      ValuesManager.doubleToString(
        item["original_fat_value"],
      ),
    ].reversed.toList();
  }).toList();

  return pw.Table.fromTextArray(
    cellAlignment: pw.Alignment.center,
    border: null,
    headers: headers.reversed.toList(),
    data: data,
    headerDecoration: const pw.BoxDecoration(
      color: PdfColors.grey300,
    ),
    columnWidths: {3: const pw.FractionColumnWidth(0.4)},
    headerStyle: pw.TextStyle(
      font: font,
      fontSize: 8,
    ),
    cellStyle: pw.TextStyle(
      font: font,
      fontSize: 8,
    ),
    cellHeight: 15,
  );
}
