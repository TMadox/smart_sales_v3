import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final storage = locator.get<SharedStorage>();
  String password = "";
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings".tr,
        ),
        actions: [
          Center(child: Text("settings_back_warning".tr)),
          const SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: WillPopScope(onWillPop: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          await storage.prefs.setString(
              "ip_password", _formKey.currentState!.value["ip_password"]);
          await storage.prefs.setString(
              "ip_address", _formKey.currentState!.value["ip_address"]);
          await storage.prefs
              .setString("user_id", _formKey.currentState!.value["user_id"]);
          context.read<UserState>().setLoginInfo(
                input: _formKey.currentState!.value,
              );
          return true;
        } else {
          return false;
        }
      }, child: LayoutBuilder(
        builder: (context, size) {
          double width = size.maxWidth;
          return FormBuilder(
            key: _formKey,
            child: SettingsList(
              contentPadding: EdgeInsets.zero,
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'account'.tr,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'settings_warning'.tr,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.dns),
                      title: Text(
                        'api_address'.tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: SizedBox(
                        width: width * 0.3,
                        child: CustomTextField(
                          initialValue: storage.ipAddress,
                          name: 'ip_address',
                          hintText: 'رابط التعريف',
                          validators: FormBuilderValidators.required(context),
                          activated: true,
                        ),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.password),
                      title: Text(
                        'api_password'.tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: SizedBox(
                        width: width * 0.3,
                        child: CustomTextField(
                          initialValue: storage.ipPassword,
                          validators: FormBuilderValidators.required(context),
                          name: 'ip_password',
                          hintText: '',
                          activated: true,
                        ),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.person),
                      title: Text(
                        'user_id'.tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: SizedBox(
                        width: width * 0.3,
                        child: CustomTextField(
                          initialValue: storage.userId,
                          validators: FormBuilderValidators.required(context),
                          name: 'user_id',
                          hintText: '',
                          activated: true,
                        ),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.label),
                      title: Text(
                        'device_id'.tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: SizedBox(
                        width: width * 0.3,
                        child: CustomTextField(
                          readOnly: true,
                          initialValue:
                              locator.get<DeviceParam>().deviceId.toString(),
                          validators: FormBuilderValidators.required(context),
                          suffixWidget: InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: locator
                                      .get<DeviceParam>()
                                      .deviceId
                                      .toString(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          name: 'reference_id',
                          activated: true,
                          hintText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'receipt_settings'.tr,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                  tiles: [
                    SettingsTile.navigation(
                      leading: const Icon(Icons.article),
                      title: Text(
                        "receipts_naming".tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.namesRoute);
                        },
                        child: Row(
                          children: [
                            Text(
                              "click_to_change".tr,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.dashboard),
                      title: Text(
                        "printing_elements".tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.printingSettingsRoute);
                        },
                        child: Row(
                          children: [
                            Text(
                              "click_to_change".tr,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(
                    "app_settings".tr,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tiles: [
                    SettingsTile.navigation(
                      onPressed: (v) {
                        Navigator.of(context)
                            .pushNamed(Routes.serverSettingsRoute);
                      },
                      enabled: context.read<UserState>().user.userId != null,
                      leading: const Icon(FontAwesomeIcons.server),
                      title: Text(
                        "server_options".tr,
                        style: GoogleFonts.cairo(),
                      ),
                      trailing: Row(
                        children: [
                          Text(
                            context.read<UserState>().user.userId != null
                                ? "click_to_change".tr
                                : "must_login".tr,
                            style: TextStyle(
                              color:
                                  context.read<UserState>().user.userId != null
                                      ? Colors.green
                                      : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: context.read<UserState>().user.userId != null
                                ? Colors.green
                                : Colors.grey,
                          )
                        ],
                      ),
                    ),
                    SettingsTile.navigation(
                      title: Text(
                        "operations_settings".tr,
                        style: GoogleFonts.cairo(),
                      ),
                      leading: const Icon(FontAwesomeIcons.desktop),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.operationsSettingsRoute);
                        },
                        child: Row(
                          children: [
                            Text(
                              "click_to_change".tr,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                    SettingsTile.navigation(
                      title: Text(
                        "اعدادات الكاشير",
                        style: GoogleFonts.cairo(),
                      ),
                      leading: const Icon(FontAwesomeIcons.cashRegister),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.cashierSettingsRoute);
                        },
                        child: Row(
                          children: [
                            Text(
                              "click_to_change".tr,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      )),
    );
  }
}
