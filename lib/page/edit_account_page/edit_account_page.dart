import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';
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
      title: Text(
        isEditMode
            ? FinanceLocales.l_edit_account.tr
            : FinanceLocales.l_add_account.tr,
        style: const TextStyle(color: CupertinoColors.label, fontSize: 18),
      ),
      leading: GestureDetector(
        onTap: () {
          Get.back();
          Get.delete<AccountController>();
        },
        child: const Icon(
          CupertinoIcons.back,
        ),
      ),
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
        // _buildColorPickerTile(),
        _buildCurrencySelectorTile(),
        _buildAccountCardStyleSelectorTile(),
      ],
    );
  }

  SettingsTile _buildColorPickerTile() {
    return SettingsTile(
      title: Text(FinanceLocales.l_color.tr),
      leading: const Icon(Icons.color_lens, color: Colors.teal),
      trailing: CircleAvatar(
        radius: 12,
        backgroundColor: Color(int.parse(controller.selectedColor)),
      ),
      onPressed: (_) => _showColorPicker(),
    );
  }

  SettingsTile _buildCurrencySelectorTile() {
    return SettingsTile(
      title: Text(FinanceLocales.l_currency.tr),
      leading: Icon(Icons.monetization_on, color: Colors.redAccent[100]),
      trailing: PullDownButton(
        itemBuilder: (context) => _buildCurrencyMenu(),
        buttonBuilder: (context, showMenu) => GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Text(controller.selectedCurrency),
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
              Text(controller.selectedAccountType),
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
    return SettingsTile(
      title: Text(FinanceLocales.l_card_style.tr),
      leading: const Icon(CupertinoIcons.creditcard, color: Colors.blueAccent),
      trailing: PullDownButton(
        itemBuilder: (context) => _buildAccountCardStyleMenu(),
        buttonBuilder: (context, showMenu) => GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Text(controller.selectedAccountCardStyle),
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
              Text(controller.selectedBankType),
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

  List<PullDownMenuItem> _buildCurrencyMenu() {
    var currencyList = CurrencyType.values.map((e) => e.name).toList();
    return List.generate(currencyList.length, (index) {
      return PullDownMenuItem(
        title: currencyList[index],
        onTap: () {
          controller.selectedCurrency = currencyList[index];
          controller.update();
        },
      );
    });
  }

  List<PullDownMenuItem> _buildAccountCardStyleMenu() {
    var accountCardStyleList =
        CreditCardStyle.values.map((e) => e.name).toList();
    return List.generate(accountCardStyleList.length, (index) {
      return PullDownMenuItem(
        title: accountCardStyleList[index],
        onTap: () {
          controller.selectedAccountCardStyle = accountCardStyleList[index];
          controller.update();
        },
      );
    });
  }

  List<PullDownMenuItem> _buildAccountTypeMenu() {
    var accountTypeList = AccountType.values.map((e) => e.name).toList();
    return List.generate(accountTypeList.length, (index) {
      return PullDownMenuItem(
        title: accountTypeList[index],
        onTap: () {
          controller.selectedAccountType = accountTypeList[index];
          controller.update();
        },
      );
    });
  }

  List<PullDownMenuItem> _buildBankTypeMenu() {
    var bankTypeList = BankType.values.map((e) => e.name).toList();
    return List.generate(bankTypeList.length, (index) {
      return PullDownMenuItem(
        title: bankTypeList[index],
        onTap: () {
          controller.selectedBankType = bankTypeList[index];
          controller.update();
        },
      );
    });
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
            Get.snackbar(
              'Success',
              isEditMode
                  ? 'Account updated successfully!'
                  : 'Account added successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
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
          onPressed: () {
            controller.deleteAccount(account!.id!);
            Get.back();
            Get.snackbar(
              'Success',
              'Account deleted successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
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

  void _showColorPicker() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: Color(int.parse(controller.selectedColor)),
              onColorChanged: (color) {
                String colorString =
                    color.value.toRadixString(16).padLeft(8, '0');
                if (!colorString.startsWith('0xFF')) {
                  colorString = '0xFF$colorString';
                }
                controller.selectedColor = colorString;
                controller.update();
              },
              availableColors: colors,
              layoutBuilder: pickerLayoutBuilder,
              itemBuilder: pickerItemBuilder,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
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
              color: color.withOpacity(0.8),
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
