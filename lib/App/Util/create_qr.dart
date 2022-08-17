import 'dart:convert';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_sales/Data/Models/info_model.dart';
import 'package:convert/convert.dart';

Future<Uint8List> createQrCode(
    {required Map receipt, required InfoModel info}) async {
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List imageData;
  String data = generateData(info: info, receipt: receipt);
  await screenshotController
      .captureFromWidget(QrImage(
        data: data,
        version: QrVersions.auto,
        size: 60,
        gapless: true,
      ))
      .then((value) => imageData = value);
  return imageData;
}

String generateData({required Map receipt, required InfoModel info}) {
  String date = receipt["oper_date"].split("-").reversed.join("-");
  BytesBuilder bytesBuilder = BytesBuilder();
  //1. Seller Name
  bytesBuilder.addByte(1);
  List<int> sellerNameBytes = utf8.encode(info.companyName ?? "");
  bytesBuilder.addByte(sellerNameBytes.length);
  bytesBuilder.add(sellerNameBytes);
  //2. VAT Registration
  bytesBuilder.addByte(2);
  List<int> regBytes = utf8.encode(info.companyTax.toString());
  bytesBuilder.addByte(regBytes.length);
  bytesBuilder.add(regBytes);
  //3. Time Stamp
  bytesBuilder.addByte(3);
  List<int> timeBytes = utf8.encode(date + "T" + receipt["oper_time"] + "Z");
  bytesBuilder.addByte(timeBytes.length);
  bytesBuilder.add(timeBytes);
  //4. Invoice total
  bytesBuilder.addByte(4);
  List<int> invoiceBytes =
      utf8.encode(receipt["oper_net_value_with_tax"].toString());
  bytesBuilder.addByte(invoiceBytes.length);
  bytesBuilder.add(invoiceBytes);
  //5. Vat total.
  bytesBuilder.addByte(5);
  List<int> vatBytes = utf8.encode(receipt["tax_value"].toString());
  bytesBuilder.addByte(vatBytes.length);
  bytesBuilder.add(vatBytes);
  Uint8List qr = bytesBuilder.toBytes();
  Base64Encoder btest = const Base64Encoder();
  return btest.convert(qr);

  // return base64.encode(utf8.encode(
  //   toHex(info.companyName ?? "") +
  //       toHex(info.companyTax ?? "") +
  //       toHex(date + "T" + receipt["oper_time"] + "Z") +
  //       toHex(receipt["oper_net_value_with_tax"].toString()) +
  //       toHex(receipt["tax_value"].toString()),
  // ));
}

String toHex(String input) {
  return hex.encode(ascii.encode(input));
}
