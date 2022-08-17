import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Printing/printing_viewmodel.dart';

class PrintingView extends StatefulWidget {
  const PrintingView({Key? key}) : super(key: key);

  @override
  State<PrintingView> createState() => _PrintingViewState();
}

class _PrintingViewState extends State<PrintingView> {
  String? path;
  final PrintingViewmodel printingViewmodel = PrintingViewmodel();
  @override
  Future<void> didChangeDependencies() async {
    // await printingViewmodel.getPrinters();
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    // await printingViewmodel.disconnectPrinter();
    printingViewmodel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    path = locator.get<DeviceParam>().documentsPath! +
        "/" +
        "receipt".tr +
        " " +
        context.read<GeneralState>().receiptsList.last["oper_id"].toString() +
        '.pdf';

    return Scaffold(
      appBar: AppBar(
        title: Text("select_printer".tr),
        leading: const BackButton(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // context.read<PrintingViewmodel>().disconnectPrinter();
      }),
      // body: ProgressHUD(
      //   child: Builder(builder: (context) {
      //     return Center(
      //       child: SizedBox(
      //         width: screenWidth(context) * 0.98,
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: ListView(
      //                 children: printingViewmodel.devices
      //                     .map(
      //                       (printer) => Card(
      //                         child: ListTile(
      //                           title: Text(printer.name.toString()),
      //                           selected: printingViewmodel.selectedPrinter ==
      //                               printer,
      //                           onTap: () async {
      //                             try {
      //                               ProgressHUD.of(context)!.show();
      //                               await printingViewmodel
      //                                   .connectPrinter(printer);
      //                               setState(() {});
      //                             } catch (e) {
      //                               log(e.toString());
      //                               showErrorDialog(
      //                                 context: context,
      //                                 title: "error".tr,
      //                                 description: "connecting_error".tr,
      //                               );
      //                             } finally {
      //                               ProgressHUD.of(context)!.dismiss();
      //                             }
      //                           },
      //                         ),
      //                       ),
      //                     )
      //                     .toList(),
      //               ),
      //             ),
      //             Expanded(
      //               child: Column(
      //                 children: [
      //                   Expanded(child: Image.file(File(path!))),
      //                   SizedBox(
      //                     width: double.infinity,
      //                     child: CommonButton(
      //                       title: "print",
      //                       icon: const Icon(Icons.print),
      //                       color: Colors.green,
      //                       onPressed: printingViewmodel.selectedPrinter == null
      //                           ? null
      //                           : () async {
      //                               try {
      //                                 ProgressHUD.of(context)!.show();
      //                                 await printingViewmodel.printDocument(
      //                                   path: path.toString(),
      //                                   cxt: context,
      //                                 );
      //                                 Navigator.pop(context);
      //                               } catch (e) {
      //                                 log(e.toString());
      //                                 showErrorDialog(
      //                                   context: context,
      //                                   title: "error".tr,
      //                                   description: "error".tr,
      //                                 );
      //                               } finally {
      //                                 ProgressHUD.of(context)!.dismiss();
      //                               }
      //                             },
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   }),
      // ),
    );
  }
}
