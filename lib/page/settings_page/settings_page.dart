import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsController extends GetxController {}

class SettingsPage extends StatelessWidget {
  final logic = Get.put(SettingsController());

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        CupertinoTheme.of(Get.context!).barBackgroundColor;
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("设置",
            style: TextStyle(color: CupertinoColors.label, fontSize: 18)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsList(
            lightTheme:
                SettingsThemeData(settingsListBackground: backgroundColor),
            shrinkWrap: true,
            sections: [
              SettingsSection(
                title: const Text('BASIC'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.monetization_on),
                    title: const Text('Default currency'),
                    value: const Text('CNY'),
                    onPressed: (context) {
                      // Define action on press, if required.
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.display_settings),
                    title: const Text('Display'),
                    onPressed: (context) {
                      // Define action on press, if required.
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('DATA & SECURITY'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      // Define action on toggle, if required.
                    },
                    initialValue: true,
                    leading: const Icon(Icons.cloud_sync),
                    title: const Text('iCloud Data Sync'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('ADVANCED'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      // Define action on toggle, if required.
                    },
                    initialValue: true,
                    leading: const Icon(Icons.code),
                    title: const Text('Scripting'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('PRODUCT GUIDE'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.play_arrow),
                    title: const Text('Enter demo mode'),
                    value: const Text('Try Plus'),
                    onPressed: (context) {
                      // Define action on press, if required.
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.description),
                    title: const Text('Product Docs'),
                    onPressed: (context) {
                      // Define action on press, if required.
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
