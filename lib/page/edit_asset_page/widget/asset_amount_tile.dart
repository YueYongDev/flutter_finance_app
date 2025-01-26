import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:flutter_finance_app/widget/numeric_keyboard.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

/// 构建资产金额输入组件
SettingsTile buildAssetAmountTile(BuildContext context) {
  AssetController controller = Get.find<AssetController>();

  /// 构建货币选择菜单
  List<PullDownMenuItem> buildCurrencyMenu() {
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

  void showNumericKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () {}, // 阻止点击穿透
          child: Container(
            height: 260, // 与 NumericKeyboard 默认高度一致
            child: NumericKeyboard(
              controller: controller.amountController,
              onEnterTapped: () {
                // 处理 Enter 键逻辑，例如验证输入并关闭键盘
                Navigator.pop(context);
                // 例如，调用某个提交方法:
                // _submitAmount();
              },
              onBackspaceTapped: () {
                // 可选：如果需要额外处理后退键
              },
            ),
          ),
        );
      },
    );
  }

  return SettingsTile(
    leading: controller.selectedCurrencyIcon,
    title: Text(FinanceLocales.l_amount_label.tr),
    trailing: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: GestureDetector(
            onTap: () => showNumericKeyboard(context),
            child: AbsorbPointer(
              child: TextField(
                controller: controller.amountController,
                focusNode: controller.amountFocusNode,
                readOnly: true,
                // 禁用系统键盘
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
          ),
        ),
        const SizedBox(width: 8), // 增加间距以改善UI
        PullDownButton(
            itemBuilder: (context) => buildCurrencyMenu(),
            buttonBuilder: (context, showMenu) => GestureDetector(
                onTap: showMenu,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.selectedCurrency,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 1),
                    const Icon(
                      CupertinoIcons.chevron_up_chevron_down,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                )))
      ],
    ),
  );
}
