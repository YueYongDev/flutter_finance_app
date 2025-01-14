import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

import 'edit_account_page_logic.dart';

class EditAccountPage extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());

  EditAccountPage({super.key});

  final int _portraitCrossAxisCount = 4;
  final int _landscapeCrossAxisCount = 5;
  final double _borderRadius = 30;
  final double _blurRadius = 5;
  final double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(context),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: GetBuilder<AccountController>(
              builder: (controller) => _buildSettingsList(context),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建导航栏
  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: const Text('Edit Account'),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(
          CupertinoIcons.back,
          color: Colors.teal,
        ),
      ),
    );
  }

  /// 构建设置列表
  SettingsList _buildSettingsList(BuildContext context) {
    return SettingsList(
      lightTheme: const SettingsThemeData(
        settingsListBackground: Color(0xFFF8F8F8),
      ),
      sections: [
        _buildAccountInfoSection(),
        _buildAppearanceSection(context),
        _buildSaveButtonSection(),
      ],
    );
  }

  /// 构建账户信息部分
  SettingsSection _buildAccountInfoSection() {
    return SettingsSection(
      title: const Text('Account Info'),
      tiles: [
        SettingsTile(
          title: const Text('Name'),
          leading: const Icon(Icons.account_circle, color: Colors.teal),
          description: Text(
            'Remaining characters: ${controller.remainingCharacters}',
            style: TextStyle(color: controller.remainingCharactersColor),
          ),
          trailing: _buildAccountNameInput(),
        ),
      ],
    );
  }

  /// 构建账户名称输入框
  Widget _buildAccountNameInput() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller.nameController,
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          hintText: 'Enter account name',
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        textAlign: TextAlign.right,
        maxLength: 20,
        onChanged: (text) {
          controller.updateRemainingCharacters(text);
        },
      ),
    );
  }

  /// 构建外观设置部分
  SettingsSection _buildAppearanceSection(BuildContext context) {
    return SettingsSection(
      title: const Text('Appearance'),
      tiles: [
        _buildColorPickerTile(context),
        _buildCurrencySelectorTile(),
      ],
    );
  }

  /// 构建颜色选择器条目
  SettingsTile _buildColorPickerTile(BuildContext context) {
    return SettingsTile(
      title: const Text('Color'),
      leading: const Icon(Icons.color_lens, color: Colors.teal),
      trailing: CircleAvatar(
        radius: 12,
        backgroundColor: Color(int.parse(controller.selectedColor)),
      ),
      onPressed: (_) => _showColorPicker(context),
    );
  }

  /// 构建货币选择器条目
  SettingsTile _buildCurrencySelectorTile() {
    return SettingsTile(
      title: const Text('Currency'),
      leading: const Icon(Icons.monetization_on, color: Colors.teal),
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

  /// 构建货币选择菜单
  List<PullDownMenuItem> _buildCurrencyMenu() {
    var currencyList = ['CNY', 'USD', 'EUR'];
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

  /// 构建保存按钮部分
  CustomSettingsSection _buildSaveButtonSection() {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            controller.addAccount();
            Get.back();
            Get.snackbar(
              'Success',
              'Account saved successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          icon: const Icon(CupertinoIcons.cube, color: Colors.teal),
          label:
              const Text('Save Account', style: TextStyle(color: Colors.teal)),
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

  /// 显示颜色选择器
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
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
