import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/printing_sorting_view.dart';

class ElementsSettingsView extends StatefulWidget {
  const ElementsSettingsView({Key? key}) : super(key: key);

  @override
  State<ElementsSettingsView> createState() => _ElementsSettingsViewState();
}

class _ElementsSettingsViewState extends State<ElementsSettingsView> {
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("printing_elements".tr),
      ),
      body: SettingsList(
        contentPadding: EdgeInsets.zero,
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('company_elements'.tr),
                Text('printing_settings_head'.tr),
              ],
            ),
            tiles: [
              SettingsTile.navigation(
                title: const Text("اعدادات ورق a4"),
                onPressed: (v) {
                  Get.to(const PrintingSortingView());
                },
              ),
              SettingsTile.navigation(
                title: const Text("نوع الورق"),
                trailing: SizedBox(
                  width: screenWidth(context) * 0.3,
                  child: FormBuilderDropdown(
                    initialValue: storage.read("paper_size") ?? "roll80",
                    items: const [
                      DropdownMenuItem(
                        child: Center(child: Text("A4")),
                        value: "a4",
                      ),
                      DropdownMenuItem(
                        child: Center(child: Text("A5")),
                        value: "a5",
                      ),
                      DropdownMenuItem(
                        child: Center(child: Text("Letter")),
                        value: "letter",
                      ),
                      DropdownMenuItem(
                        child: Center(child: Text("roll80")),
                        value: "roll80",
                      ),
                      DropdownMenuItem(
                        child: Center(child: Text("roll57")),
                        value: "roll57",
                      ),
                      DropdownMenuItem(
                        child: Center(child: Text("roll48")),
                        value: "roll48",
                      ),
                    ],
                    onChanged: (v) {
                      storage.write("paper_size", v.toString());
                    },
                    isDense: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    name: 'papertype',
                  ),
                ),
              ),
              SettingsTile.switchTile(
                title: Text(
                  "company_name".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("company_name") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("company_name", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "company_address".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("company_address") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("company_address", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "company_tax".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("company_tax") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("company_tax", value);
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text("operation_elements".tr),
            tiles: [
              SettingsTile.switchTile(
                title: Text(
                  "receipt_number".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("receipt_number") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("receipt_number", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "receipt_date".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("receipt_date") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("receipt_date", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "employee_name".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("employee_name") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("employee_name", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "customer_name".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("customer_name") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("customer_name", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "customer_tax".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("customer_tax") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("customer_tax", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "paid_amount".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("paid_amount") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("paid_amount", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "remaining_amount".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("remaining_amount") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("remaining_amount", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "credit_before".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("credit_before") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("credit_before", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "credit_after".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("credit_after") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("credit_after", value);
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('doc_elements'.tr),
            tiles: [
              SettingsTile.switchTile(
                title: Text(
                  "company_name".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("doc_company_name") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("doc_company_name", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "company_address".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("doc_company_address") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("doc_company_address", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "company_tax".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("doc_company_tax") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("doc_company_tax", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "credit_before".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("doc_credit_before") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("doc_credit_before", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "credit_after".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("doc_credit_after") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("doc_credit_after", value);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
