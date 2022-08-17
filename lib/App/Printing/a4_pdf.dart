import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';
import 'package:smart_sales/App/Util/create_qr.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';
import 'package:smart_sales/View/Widgets/A4/footer_cell.dart';
import 'package:smart_sales/View/Widgets/A4/header_cell.dart';

Future<pw.Page> a4Pdf({
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
  List<String> cells =
      List<String>.from(bContext.read<SettingsViewmodel>().cells)
          .reversed
          .toList();
  List<pw.Widget> headerWidgets = [];
  List<String> headers = bContext.read<SettingsViewmodel>().headers;
  bool createQr = bContext.read<OptionsState>().options[2].optionValue == 1;
  Uint8List qrImage = await createQrCode(
    info: bContext.read<InfoState>().info,
    receipt: receipt,
  );
  PdfPageFormat pageFormat() {
    switch (paper) {
      case "a4":
        return PdfPageFormat.a4;
      case "a5":
        return PdfPageFormat.a5;
      case "letter":
        return PdfPageFormat.letter;
      default:
        return PdfPageFormat.a4;
    }
  }

  chooseHeaderElement({required String name}) {
    switch (name) {
      case "number":
        return headerCell(
          arabic: arabic,
          key: 'oper_code',
          name: 'receipt_number'.tr,
          receipt: receipt,
          width: 65,
          visible: storage.getBool("receipt_number") ?? true,
        );
      case "date":
        return headerCell(
          arabic: arabic,
          key: 'created_date',
          name: "date".tr,
          receipt: receipt,
          width: 65,
          visible: storage.getBool("receipt_date") ?? true,
        );
      case "employee":
        return headerCell(
          arabic: arabic,
          key: 'employee_name',
          name: "employee".tr,
          receipt: receipt,
          width: 65,
          visible: storage.getBool("employee_name") ?? true,
        );
      case "customer":
        return headerCell(
          arabic: arabic,
          key: 'user_name',
          name: "customer".tr,
          receipt: receipt,
          width: 65,
          visible: storage.getBool("customer_name") ?? true,
        );
      case "tax":
        return headerCell(
          arabic: arabic,
          key: 'cst_tax',
          name: "tax_number".tr,
          receipt: receipt,
          width: 65,
          visible: storage.getBool("customer_tax") ?? true,
        );
    }
  }

  void setHeaders() {
    for (var element in headers) {
      headerWidgets.add(chooseHeaderElement(name: element));
    }
  }

  setHeaders();
  return pw.Page(
      pageFormat: pageFormat(),
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              storage.getBool("company_name") ?? true
                  ? pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      child: pw.Text(
                        bContext.read<InfoState>().info.companyName.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: arabic,
                          color: PdfColor.fromHex("f44336"),
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("FCF29D"),
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(1),
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
                        pw.SizedBox(height: 5),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          child: pw.Text(
                            bContext
                                .read<InfoState>()
                                .info
                                .companyAddress
                                .toString(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: arabic,
                              color: PdfColor.fromHex("f44336"),
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("FCF29D"),
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                        ),
                      ],
                    )
                  : pw.SizedBox(),
              storage.getBool("company_tax") ?? true
                  ? pw.Column(
                      children: [
                        pw.SizedBox(height: 5),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex("FCF29D"),
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(1),
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
                      ],
                    )
                  : pw.SizedBox(),
              pw.SizedBox(height: 10),
              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(1),
                  ),
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Center(
                  child: pw.Text(
                    title,
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                      font: arabic,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(1),
                  ),
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.LayoutBuilder(
                  builder: (context, constraints) {
                    double factor =
                        constraints!.maxWidth / screenWidth(bContext);
                    return pw.Column(
                      children: [
                        pw.SizedBox(
                          height: 15,
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                right: (storage.getDouble(headers[0] + "_x") ??
                                        0) *
                                    factor,
                                child: headerWidgets[0],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.SizedBox(
                          height: 15,
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                right:
                                    (storage.getDouble(headers[1] + "_x") ?? 0),
                                child: headerWidgets[1],
                              )
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.SizedBox(
                          height: 15,
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                right:
                                    storage.getDouble(headers[2] + "_x") ?? 0,
                                child: headerWidgets[2],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.SizedBox(
                          height: 15,
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                right:
                                    storage.getDouble(headers[3] + "_x") ?? 0,
                                child: headerWidgets[3],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.SizedBox(
                          height: 15,
                          child: pw.Stack(
                            children: [
                              pw.Positioned(
                                right:
                                    storage.getDouble(headers[4] + "_x") ?? 0,
                                child: headerWidgets[4],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              pw.SizedBox(height: 10),
              _createItemsTable(receipt: receipt, font: arabic, cells: cells),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black)),
                                    child: pw.Text(
                                        ValuesManager.doubleToString(
                                            receipt["original_oper_value"]),
                                        style: pw.TextStyle(
                                          font: arabic,
                                        )),
                                  ),
                                  pw.Container(
                                    width: 50,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(1),
                                      ),
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Text(
                                      "final_value".tr,
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
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black)),
                                    child: pw.Text(
                                        ValuesManager.doubleToString(
                                          receipt["oper_disc_value_with_tax"],
                                        ),
                                        style: pw.TextStyle(
                                          font: arabic,
                                        )),
                                  ),
                                  pw.Container(
                                    width: 50,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(1),
                                      ),
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Text(
                                      "discount".tr,
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
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black)),
                                    child: pw.Text(
                                        ValuesManager.doubleToString(
                                            receipt["oper_add_value_with_tax"]),
                                        style: pw.TextStyle(
                                          font: arabic,
                                        )),
                                  ),
                                  pw.Container(
                                    width: 50,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(1),
                                      ),
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Text(
                                      "addition".tr,
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
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black)),
                                    child: pw.Text(
                                        ValuesManager.doubleToString(
                                          receipt["tax_value"] is double
                                              ? receipt["tax_value"]
                                                  .toStringAsFixed(2)
                                              : receipt["tax_value"].toString(),
                                        ),
                                        style: pw.TextStyle(
                                          font: arabic,
                                        )),
                                  ),
                                  pw.Container(
                                    width: 50,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(1),
                                      ),
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Text(
                                      "tax".tr,
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
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black)),
                                    child: pw.Text(
                                        ValuesManager.doubleToString(
                                            receipt["oper_net_value_with_tax"]),
                                        style: pw.TextStyle(
                                          font: arabic,
                                        )),
                                  ),
                                  pw.Container(
                                    width: 50,
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: const pw.BorderRadius.all(
                                        pw.Radius.circular(1),
                                      ),
                                      border:
                                          pw.Border.all(color: PdfColors.black),
                                    ),
                                    child: pw.Text(
                                      "total".tr,
                                      textDirection: pw.TextDirection.rtl,
                                      style: pw.TextStyle(
                                        font: arabic,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Container(
                              padding:
                                  const pw.EdgeInsets.symmetric(horizontal: 5),
                              alignment: pw.Alignment.centerLeft,
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              child: pw.Text(
                                  ValuesManager.doubleToString(
                                    receipt["items_count"],
                                  ),
                                  style: pw.TextStyle(
                                    font: arabic,
                                  )),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              decoration: pw.BoxDecoration(
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(1),
                                ),
                                border: pw.Border.all(color: PdfColors.black),
                              ),
                              child: pw.Text(
                                "qty".tr,
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        footerCell(
                          arabic: arabic,
                          key: 'cash_value',
                          name: 'paid_amount'.tr,
                          receipt: receipt,
                          visible: storage.getBool("paid_amount") ?? true,
                        ),
                        pw.SizedBox(height: 5),
                        footerCell(
                          arabic: arabic,
                          key: 'reside_value',
                          name: 'remaining_amount'.tr,
                          receipt: receipt,
                          visible: storage.getBool("remaining_amount") ?? true,
                        ),
                        pw.SizedBox(height: 5),
                        footerCell(
                          arabic: arabic,
                          key: 'credit_before',
                          name: 'credit_before'.tr,
                          receipt: receipt,
                          visible: storage.getBool("credit_before") ?? true,
                        ),
                        pw.SizedBox(height: 5),
                        footerCell(
                          arabic: arabic,
                          key: 'credit_after',
                          name: 'current_credit'.tr,
                          receipt: receipt,
                          visible: storage.getBool("credit_after") ?? true,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(1),
                  ),
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Text(
                  "notes".tr + ": " + (receipt["notes"] ?? ""),
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    font: arabic,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              createQr
                  ? pw.Center(
                      child: pw.Image(
                        pw.MemoryImage(qrImage),
                      ),
                    )
                  : pw.SizedBox(),
            ],
          ),
        );
      });
}

pw.Table _createItemsTable(
    {required Map receipt, required font, required List<String> cells}) {
  List<dynamic> items = json.decode(receipt["products"]);
  final data = items.map((item) {
    return [
      ValuesManager.doubleToString(
        item[getKey(name: cells[0])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[1])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[2])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[3])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[4])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[5])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[6])],
      ),
      ValuesManager.doubleToString(
        item[getKey(name: cells[7])],
      )
    ];
  }).toList();

  return pw.Table.fromTextArray(
    cellAlignment: pw.Alignment.center,
    border: null,
    headers: cells,
    data: data,
    headerFormat: (index, header) {
      return cells[index].tr;
    },
    headerDecoration: const pw.BoxDecoration(
      color: PdfColors.grey300,
    ),
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

getKey({required String name}) {
  switch (name) {
    case "number":
      return "unit_id";
    case "item":
      return "name";
    case "unit":
      return "unit_name";
    case "qty":
      return "fat_qty";
    case "free_qty":
      return "free_qty";
    case "discount":
      return "fat_disc_value";
    case "price":
      return "original_price";
    case "value":
      return "original_fat_value";
  }
}
