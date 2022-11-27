import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';

import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:provider/provider.dart';

createPaymentPDF({
  required Map receipt,
  required BuildContext bContext,
  bool share = false,
}) async {
  var data = await rootBundle.load("fonts/arial.ttf");
  var arabic = pw.Font.ttf(data);
  final pdf = pw.Document();
  final storage = GetStorage();
  String title = await chooseTitle(
    sectionTypeNo: receipt["section_type_no"],
    prefs: storage,
  );
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            children: [
              storage.read("doc_company_name") ?? true
                  ? pw.Container(
                      width: double.infinity,
                      child: pw.Text(
                          bContext
                              .read<InfoState>()
                              .info
                              .companyName
                              .toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              font: arabic,
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold)),
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
              storage.read("doc_company_address") ?? true
                  ? pw.Column(children: [
                      pw.SizedBox(
                        height: 10,
                      ),
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
                                    color: PdfColors.red,
                                    font: arabic,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold))),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.yellow300,
                          border: pw.Border.all(
                            color: PdfColors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ])
                  : pw.SizedBox(),
              storage.read("doc_company_tax") ?? true
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
                              "الرقم الضريبي: ",
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
              pw.Text(title,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: arabic,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15)),
              pw.Divider(),
              pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          alignment: pw.Alignment.centerRight,
                          decoration: pw.BoxDecoration(
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(5),
                              ),
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Text(receipt["oper_code"].toString(),
                              style: pw.TextStyle(
                                font: arabic,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          "رقم السند:",
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
              ),
              pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 5),
                            alignment: pw.Alignment.centerRight,
                            decoration: pw.BoxDecoration(
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(5),
                                ),
                                border: pw.Border.all(color: PdfColors.black)),
                            child: pw.Text(
                                receipt["created_date"].toString() +
                                    "  -  " +
                                    receipt["oper_time"].toString(),
                                style: pw.TextStyle(font: arabic)),
                          ),
                        ),
                        pw.Expanded(
                            child: pw.Text("تاريخ السند:",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: arabic,
                                  fontWeight: pw.FontWeight.bold,
                                ))),
                      ]),
                  pw.SizedBox(height: 5),
                ],
              ),
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          alignment: pw.Alignment.centerRight,
                          decoration: pw.BoxDecoration(
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(5),
                              ),
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Text(receipt["user_name"],
                              style: pw.TextStyle(
                                font: arabic,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          alignment: pw.Alignment.centerRight,
                          decoration: pw.BoxDecoration(
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(5),
                              ),
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Text(receipt["employ_id"].toString(),
                              style: pw.TextStyle(
                                font: arabic,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text("استلمنا من:",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: arabic,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                    ]),
                pw.SizedBox(height: 5),
              ]),
              pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          alignment: pw.Alignment.centerRight,
                          decoration: pw.BoxDecoration(
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(5),
                              ),
                              border: pw.Border.all(color: PdfColors.black)),
                          child: pw.Text(
                              ValuesManager.doubleToString(
                                  receipt["cash_value"]),
                              style: pw.TextStyle(font: arabic)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text("ألمبلغ المستلم:",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: arabic,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      )
                    ]),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        alignment: pw.Alignment.centerRight,
                        decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(5),
                            ),
                            border: pw.Border.all(color: PdfColors.black)),
                        child: pw.Text(
                            ValuesManager.doubleToString(receipt["notes"]),
                            style: pw.TextStyle(font: arabic)),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text("ملاحظات:",
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabic,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    )
                  ]),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        alignment: pw.Alignment.centerRight,
                        decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(5),
                            ),
                            border: pw.Border.all(color: PdfColors.black)),
                        child: pw.Text(
                            receipt["payment_method_id"] == 3
                                ? "بنك"
                                : "cash".tr,
                            style: pw.TextStyle(font: arabic)),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text("طريقة الدفع:",
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabic,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    )
                  ]),
              pw.SizedBox(
                height: 5,
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        alignment: pw.Alignment.centerRight,
                        decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(5),
                            ),
                            border: pw.Border.all(color: PdfColors.black)),
                        child: pw.Text(
                            ValuesManager.doubleToString(
                                receipt["client_acc_id"].toString()),
                            style: pw.TextStyle(font: arabic)),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text("اسم الصندوق:",
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabic,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    )
                  ]),
              pw.Divider(),
              storage.read("doc_credit_before") ?? true
                  ? pw.Column(children: [
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
                                    border:
                                        pw.Border.all(color: PdfColors.black)),
                                child: pw.Text(
                                    ValuesManager.doubleToString(
                                        receipt["credit_before"].toString()),
                                    style: pw.TextStyle(font: arabic)),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text("الرصيد:",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                    font: arabic,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                            )
                          ]),
                      pw.SizedBox(
                        height: 5,
                      ),
                    ])
                  : pw.SizedBox(),
              storage.read("doc_credit_after") ?? true
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
                                    border:
                                        pw.Border.all(color: PdfColors.black)),
                                child: pw.Text(
                                    ValuesManager.doubleToString(
                                        receipt["credit_after"].toString()),
                                    style: pw.TextStyle(font: arabic)),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "الرصيد الباقي:",
                                textDirection: pw.TextDirection.rtl,
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
                  : pw.SizedBox()
            ],
          ),
        );
      },
    ),
  );
  List<int> bytes = await pdf.save();
  await saveFile(
    bytes,
    "فاتورة " + receipt["oper_id"].toString() + '.pdf',
    share,
  );
}
