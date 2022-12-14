import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';

class OperationsSettingsView extends StatefulWidget {
  const OperationsSettingsView({Key? key}) : super(key: key);

  @override
  State<OperationsSettingsView> createState() => _OperationsSettingsViewState();
}

class _OperationsSettingsViewState extends State<OperationsSettingsView> {
  List<String> favorites = [];
  final storage = GetStorage();

  @override
  void initState() {
    try {
      favorites = List.from(json.decode(storage.read("favorites") ?? "[]"));
    } catch (e) {
      favorites = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsViewmodel settingsViewmodel =
        context.read<SettingsViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("operations_settings".tr),
      ),
      body: SettingsList(
        contentPadding: EdgeInsets.zero,
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: Text("general_settings".tr),
            tiles: [
              SettingsTile.navigation(
                title: StatefulBuilder(builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorites.length.toString() + "/8",
                      ),
                      FormBuilderCheckboxGroup<String>(
                        onChanged: (value) async {
                          favorites = value!;
                          await storage.write("favorites", json.encode(value));
                          state(
                            () {},
                          );
                        },
                        disabled: favorites.length == 8
                            ? settingsViewmodel.filterOptions(input: favorites)
                            : [],
                        initialValue: favorites,
                        options: settingsViewmodel.favoritesOptions
                            .map(
                              (e) => FormBuilderFieldOption(
                                value: e,
                                child: Text(e.tr),
                              ),
                            )
                            .toList(),
                        name: 'favorites',
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              "info_settings".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            tiles: [
              SettingsTile.switchTile(
                initialValue: storage.read("allow_view_kinds") ?? true,
                onToggle: (value) {
                  setState(() {
                    storage.write("allow_view_kinds", value);
                  });
                },
                title: Text(
                  "allow_view_kinds".tr,
                  style: GoogleFonts.cairo(),
                ),
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_mows".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_mows") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_mows", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_expenses".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_expenses") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_expenses", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_clients".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_clients") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_clients", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_items".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_items") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_items", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_operations".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_operations") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_operations", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_groups".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_groups") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_groups", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_view_stors".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_view_stors") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_view_stors", value);
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "operations".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "operations_settings_head".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            tiles: [
              SettingsTile.switchTile(
                initialValue: storage.read("request_visit") ?? false,
                onToggle: (value) {
                  setState(() {
                    storage.write("request_visit", value);
                  });
                },
                title: Text(
                  "ask_visit".tr,
                  style: GoogleFonts.cairo(),
                ),
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_sales_receipt".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_sales_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_sales_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_return_receipt".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_return_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_return_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_payment_doc".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_payment_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_payment_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_collection_doc".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_collection_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_collection_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_inventory_doc".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_inventory_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_inventory_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_selling_order".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_order_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_order_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_purchase_order".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_purchase_order") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_purchase_order", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_cashier_receipt".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_cashier_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_cashier_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_mow_seizure_document".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue:
                    storage.read("allow_mow_seizure_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_mow_seizure_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_mow_payment_document".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue:
                    storage.read("allow_mow_payment_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_mow_payment_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_purchase_receipt".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_purchase_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_purchase_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_purchase_return_receipt".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue:
                    storage.read("allow_purchase_return_receipt") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_purchase_return_receipt", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_expenses_document".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_expenses_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_expenses_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_expenses_seizure_document".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue:
                    storage.read("allow_expenses_seizure_document") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_expenses_seizure_document", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_stor_transfer".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_stor_transfer") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_stor_transfer", value);
                  });
                },
              ),
              SettingsTile.switchTile(
                title: Text(
                  "allow_new_rec".tr,
                  style: GoogleFonts.cairo(),
                ),
                initialValue: storage.read("allow_new_rec") ?? true,
                onToggle: (bool value) {
                  setState(() {
                    storage.write("allow_new_rec", value);
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
