import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

/// 构建资产图标选择组件
SettingsTile buildAssetIconTile(BuildContext context) {
  AssetController controller = Get.find<AssetController>();

  /// 构建图标列表
  Future<List<Widget>> buildIconList(BuildContext context) async {
    return assetIconPathList.map((String url) {
      return GestureDetector(
        onTap: () {
          controller.selectedIcon = url.split('/').last;
          Navigator.of(context).pop();
          controller.update();
        },
        child: GridTile(
            child:
                Image.asset(url, fit: BoxFit.cover, width: 12.0, height: 12.0)),
      );
    }).toList();
  }

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
      final iconWidgets = await buildIconList(context);
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
