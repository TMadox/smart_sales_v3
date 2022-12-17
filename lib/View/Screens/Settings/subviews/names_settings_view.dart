import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/View/Common/Widgets/Common/custom_textfield.dart';

class ReceiptNamesView extends StatefulWidget {
  const ReceiptNamesView({Key? key}) : super(key: key);

  @override
  State<ReceiptNamesView> createState() => _ReceiptNamesViewState();
}

class _ReceiptNamesViewState extends State<ReceiptNamesView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final instance = GetStorage();
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("receipts_naming".tr),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _formKey.currentState!.save();
          Map values = _formKey.currentState!.value;
          await storage.write(
              "use_custom_names", values["use_custom_names"] ?? false);
          await storage.write("1", values["1"] ?? '');
          await storage.write("2", values["2"] ?? '');
          await storage.write("101", values["101"] ?? '');
          await storage.write("102", values["102"] ?? '');
          return true;
        },
        child: LayoutBuilder(
          builder: (context, size) {
            double width = size.maxWidth;
            return FormBuilder(
              key: _formKey,
              child: SettingsList(
                contentPadding: EdgeInsets.zero,
                platform: DevicePlatform.iOS,
                sections: [
                  SettingsSection(
                    title: FormBuilderCheckbox(
                      name: "use_custom_names",
                      initialValue: storage.read("use_custom_names") ?? false,
                      title: Text(
                        "custom_names".tr,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                    ),
                    tiles: <SettingsTile>[
                      SettingsTile.navigation(
                        leading: const Icon(Icons.dns),
                        title: Text(
                          "sales_receipt_name".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: SizedBox(
                          width: width * 0.3,
                          child: CustomTextField(
                            activated: true,
                            initialValue: storage.read("1"),
                            validators: (p0) {
                              return null;
                            },
                            hintText: "enter_name".tr,
                            name: "1",
                          ),
                        ),
                      ),
                      SettingsTile.navigation(
                        leading: const Icon(Icons.dns),
                        title: Text(
                          "return_receipt_name".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: SizedBox(
                          width: width * 0.3,
                          child: CustomTextField(
                            activated: true,
                            initialValue: storage.read("2"),
                            validators: (p0) {
                              return null;
                            },
                            hintText: "enter_name".tr,
                            name: "2",
                          ),
                        ),
                      ),
                      SettingsTile.navigation(
                        leading: const Icon(Icons.dns),
                        title: Text(
                          "seizure_doc_name".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: SizedBox(
                          width: width * 0.3,
                          child: CustomTextField(
                            activated: true,
                            initialValue: storage.read("101"),
                            validators: (p0) {
                              return null;
                            },
                            hintText: "enter_name".tr,
                            name: "101",
                          ),
                        ),
                      ),
                      SettingsTile.navigation(
                        leading: const Icon(Icons.dns),
                        title: Text(
                          "payment_doc_name".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        trailing: SizedBox(
                          width: width * 0.3,
                          child: CustomTextField(
                            activated: true,
                            initialValue: storage.read("102"),
                            validators: (p0) {
                              return null;
                            },
                            hintText: "enter_name".tr,
                            name: "102",
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
// Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FormBuilderCheckbox(
//                   name: "use_custom_names",
//                   initialValue:
//                       storage.read("use_custom_names") ?? false,
//                   title: Text(
//                     "استخدام مسميات مختلفة للعمليا؟",
//                     style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       " اسم فاتورة المبيعات ",
//                       style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: CustomTextField(
//                             activated: true,
//                             initialValue: storage.read("1"),
//                             validators: (p0) {
//                               return null;
//                             },
//                             hintText: "ادخل الاسم",
//                             name: "1")),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       " اسم فاتورة المردود ",
//                       style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: CustomTextField(
//                             activated: true,
//                             initialValue: storage.read("2"),
//                             validators: (p0) {
//                               return null;
//                             },
//                             hintText: "ادخل الاسم",
//                             name: "2")),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       " اسم سند القبض ",
//                       style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                         child: CustomTextField(
//                             activated: true,
//                             initialValue: storage.read("101"),
//                             validators: (p0) {
//                               return null;
//                             },
//                             hintText: "ادخل الاسم",
//                             name: "101")),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       " اسم سند الدفع ",
//                       style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                     ),
//                     Expanded(
//                       child: CustomTextField(
//                         activated: true,
//                         initialValue: storage.read("102"),
//                         validators: (p0) {
//                           return null;
//                         },
//                         hintText: "ادخل الاسم",
//                         name: "102",
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )