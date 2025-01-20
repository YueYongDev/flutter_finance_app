import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/helper/finance_ui_manager.dart';
import 'package:flutter_finance_app/intl/finance_internation.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

import 'settings_page_logic.dart';

class SettingsPage extends StatelessWidget {
  final controller = Get.put(SettingsPageLogic());

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        CupertinoTheme.of(Get.context!).barBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(FinanceLocales.main_tab_setting.tr,
            style: const TextStyle(color: CupertinoColors.label, fontSize: 18)),
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
                title: Text(FinanceLocales.setting_basic.tr),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.monetization_on),
                    title: Text(FinanceLocales.setting_default_currency.tr),
                    value: const Text('CNY'),
                    onPressed: (context) {
                      // Define action on press, if required.
                    },
                  ),
                  _buildLanguageSelectorTile(),
                ],
              ),
              SettingsSection(
                title: Text(FinanceLocales.setting_data_security.tr),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      // Define action on toggle, if required.
                    },
                    initialValue: true,
                    leading: const Icon(Icons.cloud_sync),
                    title: Text(FinanceLocales.setting_icloud_data_sync.tr),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(FinanceLocales.setting_advance.tr),
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
                title: Text(FinanceLocales.setting_product_guide.tr),
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

  SettingsTile _buildLanguageSelectorTile() {
    return SettingsTile(
      title: Text(FinanceLocales.l_locale_language.tr),
      leading: const Icon(Icons.language),
      trailing: PullDownButton(
        itemBuilder: (context) => _buildLanguageSelectMenu(),
        buttonBuilder: (context, showMenu) => GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Text(controller.selectedLanguage),
              const SizedBox(width: 3),
              const Icon(
                CupertinoIcons.chevron_up_chevron_down,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PullDownMenuItem> _buildLanguageSelectMenu() {
    var languageList = FinanceInternation.localeMap.entries.toList();
    return List.generate(languageList.length, (index) {
      return PullDownMenuItem(
        title: languageList[index].value,
        onTap: () {
          controller.selectedLanguage = languageList[index].value;
          controller.update();
          financeUI.changeLocal(languageList[index].key);
        },
      );
    });
  }
}
