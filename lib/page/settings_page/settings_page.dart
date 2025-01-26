import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/helper/finance_ui_manager.dart';
import 'package:flutter_finance_app/intl/finance_internation.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/main.dart';
import 'package:flutter_finance_app/page/about_page/about_page.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

import 'settings_page_logic.dart';

class SettingsPage extends StatelessWidget {
  final controller = Get.put(SettingsPageLogic());

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        title: Text(FinanceLocales.main_tab_setting.tr,
            style: const TextStyle(color: CupertinoColors.label, fontSize: 18)),
      ),
      body: GetBuilder<SettingsPageLogic>(builder: (logic) {
        return MediaQuery.removePadding(
          context: context,
          child: SettingsList(
            lightTheme:
                SettingsThemeData(settingsListBackground: backgroundColor),
            shrinkWrap: true,
            sections: [
              // 基础设置
              _buildBasicSettingsSection(),
              // 数据与安全设置
              _buildDataSecuritySection(),
              // 产品指南
              _buildProductGuideSection(),
              // 联系我们
              _buildContactUsSection(),
              if (kDebugMode) _buildDeveloperSection(),
            ],
          ),
        );
      }),
    );
  }

  // 基础设置
  _buildBasicSettingsSection() {
    SettingsTile buildLanguageSelectorTile() {
      List<PullDownMenuItem> buildLanguageSelectMenu() {
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

      return SettingsTile(
        title: Text(FinanceLocales.l_locale_language.tr),
        leading: const Icon(Icons.language, color: Colors.blueAccent),
        trailing: PullDownButton(
          itemBuilder: (context) => buildLanguageSelectMenu(),
          buttonBuilder: (context, showMenu) => GestureDetector(
            onTap: showMenu,
            child: Row(
              children: [
                Text(controller.selectedLanguage,
                    style: TextStyle(fontSize: 14.sp)),
                const SizedBox(width: 3),
                Icon(CupertinoIcons.chevron_up_chevron_down,
                    color: Colors.grey, size: 18.sp),
              ],
            ),
          ),
        ),
      );
    }

    SettingsTile buildCurrencySelectorTile() {
      List<PullDownMenuItem> buildCurrencyMenu() {
        return CurrencyType.values.map((type) {
          return PullDownMenuItem(
            title: type.displayName,
            onTap: () {
              controller.selectedCurrency = type.name;
              controller.update();
              controller.changeDefaultCurrency(type.name);
            },
          );
        }).toList();
      }

      return SettingsTile(
        title: Text(FinanceLocales.setting_default_currency.tr),
        leading: const Icon(Icons.monetization_on, color: Colors.redAccent),
        trailing: PullDownButton(
          itemBuilder: (context) => buildCurrencyMenu(),
          buttonBuilder: (context, showMenu) => GestureDetector(
            onTap: showMenu,
            child: Row(
              children: [
                Text(controller.getCurrencyDisplayName(),
                    style: TextStyle(fontSize: 14.sp)),
                const SizedBox(width: 3),
                Icon(CupertinoIcons.chevron_up_chevron_down,
                    color: Colors.grey, size: 18.sp),
              ],
            ),
          ),
        ),
      );
    }

    return SettingsSection(
      title: Text(FinanceLocales.setting_basic.tr),
      tiles: <SettingsTile>[
        // SettingsTile.navigation(
        //   leading: const Icon(Icons.account_circle, color: Colors.blueAccent),
        //   title: Text(FinanceLocales.l_account_type.tr),
        //   value: Text('高级会员', style: TextStyle(fontSize: 14.sp)),
        //   onPressed: (context) {
        //     // Define action on press, if required.
        //   },
        // ),
        buildCurrencySelectorTile(),
        buildLanguageSelectorTile(),
      ],
    );
  }

  // 数据与安全设置
  _buildDataSecuritySection() {
    return SettingsSection(
      title: Text(FinanceLocales.setting_data_security.tr),
      tiles: <SettingsTile>[
        SettingsTile.switchTile(
          enabled: false,
          onToggle: (bool value) {
            controller.toggleIcloudSync(value);
            controller.update();
          },
          initialValue: controller.icloudSyncEnable,
          leading: const Icon(Icons.cloud_sync, color: Colors.grey),
          title: Text(FinanceLocales.setting_icloud_data_sync.tr),
        ),
      ],
    );
  }

  // 产品指南
  _buildProductGuideSection() {
    return SettingsSection(
      title: Text(FinanceLocales.setting_product_guide.tr),
      tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading: const Icon(Icons.description, color: Colors.green),
          title: Text(FinanceLocales.setting_product_docs.tr),
          onPressed: (context) {
            // Define action on press, if required.
          },
        ),
      ],
    );
  }

  // 开发者设置
  _buildDeveloperSection() {
    return SettingsSection(
      title: const Text("开发者设置"),
      tiles: [
        SettingsTile.navigation(
          leading: const Icon(Icons.play_arrow),
          title: const Text("insert history mock data"),
          onPressed: (context) {
            BalanceHistoryRepository().insertMockData();
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.data_exploration),
          title: const Text("delete history mock data"),
          onPressed: (context) {
            BalanceHistoryRepository().cleanupMockData();
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.key_off),
          title: const Text("delete kFirstLaunchKey"),
          onPressed: (context) {
            GetStorage().remove(kFirstLaunchKey);
          },
        ),
      ],
    );
  }

  // 联系我们
  _buildContactUsSection() {
    return SettingsSection(
      title: Text(FinanceLocales.setting_contact_us.tr),
      tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading:
              const Icon(Icons.feedback_outlined, color: Colors.blueAccent),
          title: Text(FinanceLocales.setting_feedback.tr),
          onPressed: (context) {
            // Define action on press, if required.
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.star, color: Colors.orangeAccent),
          title: Text(FinanceLocales.setting_five_star_rating.tr),
          onPressed: (context) {
            // Define action on press, if required.
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(CupertinoIcons.share_up, color: Colors.teal),
          title: Text(FinanceLocales.setting_share_with_friends.tr),
          onPressed: (context) {
            // Define action on press, if required.
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(CupertinoIcons.news, color: Colors.blueGrey),
          title: Text(FinanceLocales.setting_about_us.tr),
          onPressed: (context) async {
            await showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              enableDrag: false,
              builder: (context) => const AboutPage(),
            );
          },
        ),
      ],
    );
  }
}
