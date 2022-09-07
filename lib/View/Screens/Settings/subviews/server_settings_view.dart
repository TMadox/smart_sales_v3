import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';

class ServerSettingsView extends StatelessWidget {
  const ServerSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("خيارات و صلاحيات السرفر"),
      ),
      body: SettingsList(
        contentPadding: EdgeInsets.zero,
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "الخيارات",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "(الخيارات و صلاحيات الموجودة في السيرفر)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            tiles: context
                .read<OptionsState>()
                .options
                .map((e) => SettingsTile.switchTile(
                      title: Text(e.optionCode.toString()),
                      initialValue: e.optionValue == 1.0,
                      onToggle: (bool value) {},
                    ))
                .toList(),
          ),
          SettingsSection(
            title: const Text(
              "ًصلاحيات",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            tiles: context
                .read<PowersState>()
                .userPowersList
                .map((e) => SettingsTile.switchTile(
                      title: Text(e.powerName.toString()),
                      initialValue: e.powerState == 1.0,
                      onToggle: (bool value) {},
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
