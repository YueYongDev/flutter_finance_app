import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:flutter_finance_app/widget/accout_select_modal.dart';
import 'package:flutter_finance_app/widget/numeric_keyboard.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

class EditAssetPage extends StatelessWidget {
  final Account? account;
  final Asset? asset;
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
      controller.selectedCurrency =
          (asset?.currency.isNotEmpty ?? false) ? asset!.currency : "CNY";
      controller.selectedAccount = account!;
      controller.selectedCurrencyIcon =
          getCurrencyIconByName(controller.selectedCurrency);
      if (asset!.extra['icon'] != null) {
        controller.selectedIcon = asset!.extra['icon'];
      }
      controller.enableCounting = asset!.enableCounting;
      controller.updateRemainingCharacters(controller.nameController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode
              ? FinanceLocales.l_edit_asset.tr
              : FinanceLocales.l_add_asset.tr,
          style: const TextStyle(color: CupertinoColors.label, fontSize: 18),
        ),
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
                Get.delete<AssetController>();
              },
              icon: const Icon(
                CupertinoIcons.clear_circled_solid,
                color: Colors.blue,
              ))
        ],
      ),
      body: GetBuilder<AssetController>(
        builder: (controller) => Stack(
          children: [
            SettingsList(
              lightTheme: const SettingsThemeData(
                settingsListBackground: Color(0xFFF8F8F8),
              ),
              sections: [
                _buildAccountSection(context),
                _buildAssetDetailsSection(context),
                _buildAddAssetButton(context, isEditMode),
                if (isEditMode) _buildDeleteAssetButton(context),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: controller.amountFocusNode.hasFocus
                    ? SafeArea(
                        child: NumericKeyboard(
                            controller: controller.amountController))
                    : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  /// 构建账户选择部分
  SettingsSection _buildAccountSection(BuildContext context) {
    return SettingsSection(
      title: Text(FinanceLocales.l_account_info.tr),
      tiles: [
        SettingsTile.navigation(
          title: Text(FinanceLocales.l_belong_account.tr),
          leading: Icon(CupertinoIcons.rectangle_stack_badge_plus,
              color: Colors.blueAccent[100]),
          trailing: Row(
            children: [
              account != null
                  ? Text(account!.name)
                  : Text(controller.selectedAccount?.name ??
                      FinanceLocales.l_select_account.tr),
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
                  if (fetchAllAccounts.isEmpty) {
                    Get.snackbar(
                      'Warning',
                      'Please add an account first!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  dynamic value = await showCupertinoModalBottomSheet(
                    expand: true,
                    enableDrag: false,
                    context: Get.context!,
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
      title: Text(FinanceLocales.l_asset_detail.tr),
      tiles: [
        _buildAssetNameTile(),
        _buildAssetAmountTile(context),
        _buildAssetIconTile(context), // 新增图标选择组件
        _buildAssetSwitchTile(),
      ],
    );
  }

  /// 构建资产图标选择组件
  SettingsTile _buildAssetIconTile(BuildContext context) {
    return SettingsTile.navigation(
      leading: Icon(CupertinoIcons.photo, color: Colors.blue[200]),
      title: Text(FinanceLocales.l_select_icon.tr),
      trailing: Row(
        children: [
          Image.asset(
            controller.selectedIcon != null
                ? '${AccountCardConstants.defaultAssetIconBasePath}/${controller.selectedIcon}'
                : AccountCardConstants.defaultAssetIcon,
            width: 30,
            fit: BoxFit.fitWidth,
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 20,
            color: Colors.grey,
          )
        ],
      ),
      onPressed: (context) async {
        final iconWidgets = await _buildIconList(context);
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('选择图标'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.width * .7,
                child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    padding: const EdgeInsets.all(8.0),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: iconWidgets),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('关闭'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    controller.update();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 构建图标列表
  Future<List<Widget>> _buildIconList(BuildContext context) async {
    return assetIconPathList.map((String url) {
      return GestureDetector(
        onTap: () {
          controller.selectedIcon = url.split('/').last;
          Navigator.of(context).pop();
          controller.update();
        },
        child: GridTile(
            child: Image.asset(
          url,
          fit: BoxFit.cover,
          width: 12.0,
          height: 12.0,
        )),
      );
    }).toList();
  }

  /// 构建资产名称输入组件
  SettingsTile _buildAssetNameTile() {
    return SettingsTile(
      title: Text(FinanceLocales.l_asset_name.tr),
      leading: Icon(
        CupertinoIcons.bag_badge_plus,
        color: Colors.redAccent[100],
      ),
      description: Text(
        '${FinanceLocales.l_remaining_characters.tr}: ${controller.remainingCharacters}',
        style: TextStyle(color: controller.remainingCharactersColor),
      ),
      trailing: SizedBox(
        width: 200,
        child: TextField(
          controller: controller.nameController,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            hintText: FinanceLocales.hint_enter_asset_name.tr,
            counterText: '',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
      title: Text(FinanceLocales.l_amount_label.tr),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller.amountController,
              focusNode: controller.amountFocusNode,
              keyboardType: TextInputType.none,
              // Disable system keyboard
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: FinanceLocales.l_amount_label.tr,
                counterText: '',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              textAlign: TextAlign.right,
              maxLength: 10,
            ),
          ),
          const SizedBox(width: 3),
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
        color: Colors.teal[200],
      ),
      initialValue: controller.enableCounting,
      onToggle: (value) {
        controller.toggleCounting(value);
        controller.update();
      },
      title: Text(FinanceLocales.l_enable_counting.tr),
    );
  }

  /// 构建添加资产按钮
  CustomSettingsSection _buildAddAssetButton(
      BuildContext context, bool isEditMode) {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
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
          icon: const Icon(CupertinoIcons.cube, color: Colors.teal),
          label: Text(
              isEditMode
                  ? FinanceLocales.l_update_asset.tr
                  : FinanceLocales.l_add_asset.tr,
              style: const TextStyle(color: Colors.teal)),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  /// 构建删除资产按钮
  _buildDeleteAssetButton(BuildContext context) {
    return CustomSettingsSection(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            await controller.deleteAsset(asset!);
            Get.back();
            Get.snackbar(
              'Success',
              'Asset deleted successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          icon: const Icon(CupertinoIcons.trash,
              color: CupertinoColors.destructiveRed),
          label: Text(FinanceLocales.l_delete_asset.tr,
              style: const TextStyle(color: CupertinoColors.destructiveRed)),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
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
