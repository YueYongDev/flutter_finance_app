import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:flutter_finance_app/widget/accout_select_modal.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

class EditAssetPage extends StatelessWidget {
  final Account? account; // Updated to use Account class
  final Asset? asset; // Updated to use Asset class
  final controller = Get.put(AssetController());

  EditAssetPage({super.key, required this.account, this.asset});

  @override
  Widget build(BuildContext context) {
    // 判断是新增模式还是编辑模式
    final isEditMode = asset != null;

    // 初始化数据（如果是编辑模式）
    if (isEditMode) {
      controller.nameController.text = asset!.name;
      controller.amountController.text = asset!.amount.toString();
      controller.selectedCurrency = asset!.currency;
      controller.selectedAccount = account!;
      controller.selectedCurrencyIcon =
          getCurrencyIconByName(controller.selectedCurrency);
      controller.updateRemainingCharacters(controller.nameController.text);
    }

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          isEditMode ? 'Edit Asset' : 'Add Asset',
          style: const TextStyle(color: CupertinoColors.label, fontSize: 18),
        ),
      ),
      body: GetBuilder<AssetController>(
        builder: (controller) => SettingsList(
          lightTheme: const SettingsThemeData(
            settingsListBackground: Color(0xFFF8F8F8),
          ),
          sections: [
            _buildAccountSection(context),
            _buildAssetDetailsSection(context),
            _buildAddAssetButton(context, isEditMode),
          ],
        ),
      ),
    );
  }

  /// 构建账户选择部分
  SettingsSection _buildAccountSection(BuildContext context) {
    return SettingsSection(
      title: const Text('Account Info'),
      tiles: [
        SettingsTile.navigation(
          title: const Text("Belong Account"),
          leading: Icon(
            CupertinoIcons.rectangle_stack_badge_plus,
            color: account != null
                ? Color(int.parse(account!.color))
                : Colors.grey,
          ),
          trailing: Row(
            children: [
              account != null
                  ? Text(account!.name)
                  : Text(controller.selectedAccount?.name ?? 'Select Account'),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 20,
                color: Colors.grey,
              )
            ],
          ),
          onPressed: account != null
              ? null
              : (BuildContext context) async {
                  final accountPageLogic = Get.find<AccountPageLogic>();
                  List<Account> fetchAllAccounts =
                      await accountPageLogic.fetchAllAccountsWithAssets();

                  dynamic value = await showCupertinoModalBottomSheet(
                    expand: true,
                    enableDrag: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        AccountSelectModal(accounts: fetchAllAccounts),
                  );
                  if (value != null) {
                    controller.selectedAccount = value;
                    controller.update();
                  }
                },
        ),
      ],
    );
  }

  /// 构建资产详情部分
  SettingsSection _buildAssetDetailsSection(BuildContext context) {
    return SettingsSection(
      title: const Text('Assets Details'),
      tiles: [
        _buildAssetNameTile(),
        _buildAssetAmountTile(context),
        _buildAssetSwitchTile(),
      ],
    );
  }

  /// 构建资产名称输入组件
  SettingsTile _buildAssetNameTile() {
    return SettingsTile(
      title: const Text('Assets Name'),
      leading: Icon(
        CupertinoIcons.bag_badge_plus,
        color: account != null ? Color(int.parse(account!.color)) : Colors.grey,
      ),
      description: Text(
        'Remaining characters: ${controller.remainingCharacters}',
        style: TextStyle(color: controller.remainingCharactersColor),
      ),
      trailing: SizedBox(
        width: 200,
        child: TextField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: 'Enter Assets name',
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          textAlign: TextAlign.right,
          maxLength: 20,
          onChanged: (text) => controller.updateRemainingCharacters(text),
        ),
      ),
    );
  }

  /// 构建资产金额输入组件
  SettingsTile _buildAssetAmountTile(BuildContext context) {
    return SettingsTile(
      leading: controller.selectedCurrencyIcon,
      title: const Text('Asset Amount'),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            child: CupertinoTextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              placeholder: "Amount",
              decoration: null,
              textAlign: TextAlign.right,
              maxLength: 10,
              controller: controller.amountController,
            ),
          ),
          Text(
            controller.selectedCurrency,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          PullDownButton(
            itemBuilder: (context) => _buildCurrencyMenu(),
            buttonBuilder: (context, showMenu) => buildMenuButton(
              showMenu,
              icon: CupertinoIcons.chevron_up_chevron_down,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建货币选择菜单
  List<PullDownMenuItem> _buildCurrencyMenu() {
    return List.generate(currencyList.length, (i) {
      var currency = currencyList[i].entries;
      return PullDownMenuItem(
        title: currency.first.key,
        icon: currency.first.value.icon,
        onTap: () {
          controller.selectedCurrency = currency.first.key.toString();
          controller.selectedCurrencyIcon = currency.first.value;
          controller.update();
        },
      );
    });
  }

  /// 构建是否计入统计的开关
  SettingsTile _buildAssetSwitchTile() {
    return SettingsTile.switchTile(
      leading: Icon(
        CupertinoIcons.percent,
        color: account != null ? Color(int.parse(account!.color)) : Colors.grey,
      ),
      initialValue: controller.enableCounting,
      onToggle: (value) => controller.toggleCounting(value),
      title: const Text("是否计入统计账户"),
    );
  }

  /// 构建添加资产按钮
  CustomSettingsSection _buildAddAssetButton(
      BuildContext context, bool isEditMode) {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CupertinoButton.filled(
          child: Text(isEditMode ? 'Update Asset' : 'Add Asset'),
          onPressed: () async {
            if (isEditMode) {
              debugPrint("Asset updated: ${controller.nameController.text}");
              await controller.updateAsset(asset!);
            } else {
              debugPrint("New asset added: ${controller.nameController.text}");
              if (account != null) {
                controller.selectedAccount = account!;
              }
              await controller.addAsset();
            }
          },
        ),
      ),
    );
  }
}

/// 构建菜单按钮
Widget buildMenuButton(VoidCallback showMenu, {required IconData icon}) {
  return IconButton(
    icon: Icon(icon, size: 20),
    onPressed: showMenu,
  );
}
