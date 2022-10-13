import 'package:universal_io/io.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Printing/a4_pdf.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Printing/roll80_pdf.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';

createPDF({
  required Map receipt,
  required BuildContext bContext,
  bool share = false,
}) async {
  var data = await rootBundle.load("fonts/arial.ttf");
  var arabic = pw.Font.ttf(data);
  final pdf = pw.Document();
  final storage = locator.get<SharedStorage>().prefs;
  pdf.addPage(
    await choosePdf(
      context: bContext,
      font: arabic,
      paper: storage.getString("paper_size") ?? "roll80",
      receipt: receipt,
      storage: storage,
    ),
  );
  Uint8List bytes = await pdf.save();
  await saveFile(
    bytes,
    "receipt".tr + " " + receipt["oper_id"].toString(),
    share,
  );
  // await for (var page in Printing.raster(bytes, pages: [0], dpi: 72)) {
  //   final image = await page.toPng();
  //   await saveFile(
  //     image,
  //     "receipt".tr + " " + receipt["oper_id"].toString() + '.pdf',
  //     share,
  //   );
  // }
}

Future<void> saveFile(List<int> bytes, String fileName, bool share) async {
  final path = locator.get<DeviceParam>().documentsPath;
  final file = File("$path/$fileName.pdf");
  await file.writeAsBytes(bytes, flush: true);
  if (share) {
    Share.shareFiles(["$path/$fileName.pdf"]);
  } else {
    await Printing.layoutPdf(onLayout: (_) async => await file.readAsBytes());
    // OpenFile.open("$path/$fileName");
  }
}

choosePdf({
  required String paper,
  required BuildContext context,
  required SharedPreferences storage,
  required pw.Font font,
  required receipt,
}) async {
  if (paper == "roll80" || paper == "roll57" || paper == "roll48") {
    return await roll80Pdf(
      arabic: font,
      bContext: context,
      receipt: receipt,
      storage: storage,
      paper: paper,
    );
  } else {
    return await a4Pdf(
      receipt: receipt,
      bContext: context,
      arabic: font,
      storage: storage,
      paper: paper,
    );
  }
}

chooseTitle(
    {required int sectionTypeNo, required SharedPreferences prefs}) async {
  bool usesCustomNames = prefs.getBool("use_custom_names") ?? false;
  if (usesCustomNames) {
    switch (sectionTypeNo) {
      case 1:
        return !checkTitle(prefs.getString("1").toString())
            ? prefs.getString("1")
            : "sales".tr;
      case 2:
        return !checkTitle(prefs.getString("2").toString())
            ? prefs.getString("2")
            : "return".tr;
      case 3:
        return !checkTitle(prefs.getString("3").toString())
            ? prefs.getString("3")
            : "purchase".tr;
      case 4:
        return !checkTitle(prefs.getString("4").toString())
            ? prefs.getString("4")
            : "purchase_return".tr;
      case 5:
        return !checkTitle(prefs.getString("5").toString())
            ? prefs.getString("5")
            : "stor_transfer".tr;
      case 17:
        return !checkTitle(prefs.getString("17").toString())
            ? prefs.getString("17")
            : "selling_order".tr;
      case 18:
        return !checkTitle(prefs.getString("18").toString())
            ? prefs.getString("18")
            : "purchase_order".tr;
      case 98:
        return !checkTitle(prefs.getString("98").toString())
            ? prefs.getString("98")
            : "inventory".tr;
      case 101:
        return !checkTitle(prefs.getString("101").toString())
            ? prefs.getString("101")
            : "seizure_document".tr;
      case 102:
        return !checkTitle(prefs.getString("102").toString())
            ? prefs.getString("102")
            : "payment_document".tr;
      case 103:
        return !checkTitle(prefs.getString("103").toString())
            ? prefs.getString("103")
            : "mow_seizure_document".tr;
      case 104:
        return !checkTitle(prefs.getString("104").toString())
            ? prefs.getString("104")
            : "mow_payment_document".tr;
      case 107:
        return !checkTitle(prefs.getString("107").toString())
            ? prefs.getString("107")
            : "expenses_seizure_document".tr;
      case 108:
        return !checkTitle(prefs.getString("108").toString())
            ? prefs.getString("108")
            : "expenses_document".tr;
      case 31:
        return !checkTitle(prefs.getString("31").toString())
            ? prefs.getString("31")
            : "cashier_receipt".tr;
      default:
        return !checkTitle(prefs.getString("1").toString())
            ? prefs.getString("1")
            : "sales".tr;
    }
  } else {
    switch (sectionTypeNo) {
      case 9999:
        return "visit".tr;
      case 0:
        return "total".tr;
      case 1:
        return "sales".tr;
      case 2:
        return "return".tr;
      case 3:
        return "purchase".tr;
      case 5:
        return "stor_transfer".tr;
      case 4:
        return "purchase_return".tr;
      case 101:
        return "seizure_document".tr;
      case 17:
        return "selling_order".tr;
      case 18:
        return "purchase_order".tr;
      case 98:
        return "inventory".tr;
      case 102:
        return "payment_document".tr;
      case 103:
        return "mow_seizure_document".tr;
      case 104:
        return "mow_payment_document".tr;
      case 107:
        return "expenses_seizure_document".tr;
      case 108:
        return "expenses_document".tr;
      case 31:
        return "cashier_receipt".tr;
      default:
        return "sales".tr;
    }
  }
}

bool checkTitle(String value) {
  return value.replaceAll(" ", "").isEmpty;
}
