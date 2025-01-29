import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/helper/common_helper.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/card_style_preview_page/card_style_preview_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

import 'edit_account_page_logic.dart';

class EditAccountPage extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());
  final Account? account;
  final bool isEditMode;

  EditAccountPage({super.key, this.account}) : isEditMode = account != null {
    if (isEditMode) {
      controller.setAccount(account!);
    }
  }

  final int _portraitCrossAxisCount = 4;
  final int _landscapeCrossAxisCount = 5;
  final double _borderRadius = 30;
  final double _blurRadius = 5;
  final double _iconSize = 24;

  String _getCardStyleDisplayName(String style) {
    switch (style) {
      case 'PRIMARY' || 'primary':
        return FinanceLocales.l_primary_style.tr;
      case 'SECONDARY' || 'secondary':
        return FinanceLocales.l_secondary_style.tr;
      case 'ACCENT' || 'accent':
        return FinanceLocales.l_accent_style.tr;
      case 'ON_BLACK' || 'onBlack':
        return FinanceLocales.l_on_black_style.tr;
      case 'ON_WHITE' || 'onWhite':
        return FinanceLocales.l_on_white_style.tr;
      default:
        return style;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavigationBar(context),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<AccountController>(
              builder: (controller) => _buildSettingsList(controller),
            ),
          ),
        ],
      ),
    );
  }

  _buildNavigationBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Text(
        isEditMode
            ? FinanceLocales.l_edit_account.tr
            : FinanceLocales.l_add_account.tr,
        style: TextStyle(color: CupertinoColors.label, fontSize: 14.sp),
      ),
      leading: Container(),
      actions: [
        IconButton(
            onPressed: () {
              Get.back();
              if (Get.isRegistered<AccountController>()) {
                Get.delete<AccountController>();
              }
            },
            icon: Icon(
              CupertinoIcons.clear_circled_solid,
              color: Colors.blue[200],
              size: 24.sp,
            ))
      ],
    );
  }

  SettingsList _buildSettingsList(AccountController controller) {
    return SettingsList(
      lightTheme: const SettingsThemeData(
        settingsListBackground: Color(0xFFF8F8F8),
      ),
      sections: [
        _buildAccountInfoSection(controller),
        _buildAppearanceSection(controller),
        _buildSaveButtonSection(controller),
        if (isEditMode) _buildDeleteButtonSection(),
      ],
    );
  }

  SettingsSection _buildAccountInfoSection(AccountController controller) {
    return SettingsSection(
      title: Text(FinanceLocales.l_account_info.tr),
      tiles: [
        SettingsTile(
          title: Text(FinanceLocales.l_account_name.tr),
          leading: Icon(Icons.account_circle, color: Colors.blueAccent[100]),
          description: Text(
            '${FinanceLocales.l_remaining_characters.tr}: ${controller.remainingCharacters}',
            style: TextStyle(color: controller.remainingCharactersColor),
          ),
          trailing: _buildAccountNameInput(),
        ),
        _buildAccountTypeSelectorTile(),
        if (controller.selectedAccountType == AccountType.CREDIT_CARD.name ||
            controller.selectedAccountType == AccountType.DEBIT_CARD.name)
          _buildBankTypeSelectorTile(controller)
      ],
    );
  }

  Widget _buildAccountNameInput() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller.nameController,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.grey),
          hintText: FinanceLocales.hint_enter_account_name.tr,
          counterText: '',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        textAlign: TextAlign.right,
        maxLength: 20,
        onChanged: (text) {
          controller.updateRemainingCharacters(text);
        },
      ),
    );
  }

  SettingsSection _buildAppearanceSection(AccountController controller) {
    return SettingsSection(
      title: Text(FinanceLocales.l_appearance.tr),
      tiles: [
        _buildCurrencySelectorTile(),
        _buildAccountCardStyleSelectorTile(),
      ],
    );
  }

  SettingsTile _buildCurrencySelectorTile() {
    List<PullDownMenuItem> buildCurrencyMenu() {
      return CurrencyType.values.map((type) {
        return PullDownMenuItem(
          title: type.displayName,
          onTap: () {
            controller.selectedCurrency = type.name;
            controller.update();
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

  SettingsTile _buildAccountTypeSelectorTile() {
    return SettingsTile(
      title: Text(FinanceLocales.l_account_type.tr),
      leading: Icon(Icons.account_balance_wallet, color: Colors.teal[300]),
      trailing: PullDownButton(
        itemBuilder: (context) => _buildAccountTypeMenu(),
        buttonBuilder: (context, showMenu) => GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Text(controller.getAccountTypeDisplayName()),
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

  SettingsTile _buildAccountCardStyleSelectorTile() {
    return SettingsTile.navigation(
      title: Text(FinanceLocales.l_card_style.tr),
      leading: const Icon(CupertinoIcons.creditcard, color: Colors.blueAccent),
      trailing: Row(
        children: [
          Text(_getCardStyleDisplayName(controller.selectedAccountCardStyle)),
          Icon(CupertinoIcons.chevron_right, size: 16.w, color: Colors.grey)
        ],
      ),
      onPressed: (BuildContext context) async {
        dynamic value = await showCupertinoModalBottomSheet(
          expand: true,
          enableDrag: false,
          context: Get.context!,
          backgroundColor: Colors.transparent,
          builder: (context) => CardStylePreviewPage(),
        );
        debugPrint('value: $value');
      },
    );
  }

  SettingsTile _buildBankTypeSelectorTile(AccountController controller) {
    if (controller.selectedBankType.isEmpty) {
      controller.selectedBankType = BankType.VISA.name;
      controller.update();
    }
    return SettingsTile(
      title: Text(FinanceLocales.l_bank_type.tr),
      leading: const Icon(Icons.monetization_on, color: Colors.teal),
      trailing: PullDownButton(
        itemBuilder: (context) => _buildBankTypeMenu(),
        buttonBuilder: (context, showMenu) => GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Text(controller.getBankTypeDisplayName()),
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

  List<PullDownMenuItem> _buildAccountTypeMenu() {
    return AccountType.values.map((type) {
      return PullDownMenuItem(
        title: type.displayName,
        onTap: () {
          controller.selectedAccountType = type.name;
          controller.update();
        },
      );
    }).toList();
  }

  List<PullDownMenuItem> _buildBankTypeMenu() {
    return BankType.values.map((type) {
      return PullDownMenuItem(
        title: type.displayName,
        onTap: () {
          controller.selectedBankType = type.name;
          controller.update();
        },
      );
    }).toList();
  }

  CustomSettingsSection _buildSaveButtonSection(AccountController controller) {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            if (isEditMode) {
              controller.updateAccount(account!);
            } else {
              controller.addAccount();
            }
            Get.back();
            showSuccessTips(isEditMode
                ? FinanceLocales.snackbar_update_account_success.tr
                : FinanceLocales.snackbar_add_account_success.tr);
            controller.clearInputFields();
          },
          icon: const Icon(CupertinoIcons.cube, color: Colors.teal),
          label: Text(
              isEditMode
                  ? FinanceLocales.l_update_account.tr
                  : FinanceLocales.l_add_account.tr,
              style: const TextStyle(color: Colors.teal)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  _buildDeleteButtonSection() {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            bool deleteResult = await controller.deleteAccount(account!.id!);
            if (deleteResult) {
              Get.back();
              showSuccessTips(
                  FinanceLocales.snackbar_delete_account_success.tr);
            }
          },
          icon: const Icon(CupertinoIcons.trash, color: Colors.red),
          label: Text(FinanceLocales.l_delete_account.tr,
              style: const TextStyle(color: Colors.redAccent)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
