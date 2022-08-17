// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PrintingViewmodel extends ChangeNotifier {
  List<BluetoothDevice> devices = [];
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice? selectedPrinter;

  Future<void> getPrinters() async {
    devices = await bluetooth.getBondedDevices();
    notifyListeners();
  }

  Future<void> disconnectPrinter() async {
    selectedPrinter = null;
    if ((await bluetooth.isConnected)!) await bluetooth.disconnect();
  }

  Future<void> connectPrinter(BluetoothDevice printer) async {
    await bluetooth.connect(printer);
    selectedPrinter = printer;
    notifyListeners();
  }

  Future<void> printDocument(
      {required String path, required BuildContext cxt}) async {
    await bluetooth.isConnected.then((value) async {
      if (value == true) {
        await bluetooth.printNewLine();
        await bluetooth.printImage(path);
        await bluetooth.paperCut();
      }
    });
  }
}
