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
      case 101:
        return !checkTitle(prefs.getString("101").toString())
            ? prefs.getString("101")
            : "seizure_document".tr;
      case 102:
        return !checkTitle(prefs.getString("102").toString())
            ? prefs.getString("102")
            : "payment_document".tr;
      default:
        return !checkTitle(prefs.getString("1").toString())
            ? prefs.getString("1")
            : "sales".tr;
    }
  } else {
    switch (sectionTypeNo) {
      case 1:
        return "sales".tr;
      case 2:
        return "return".tr;
      case 101:
        return "seizure_document".tr;
      case 102:
        return "payment_document".tr;
      default:
        return "sales".tr;
    }
  }
}

bool checkTitle(String value) {
  return value.replaceAll(" ", "").isEmpty;
}
