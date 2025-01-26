import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/helper/common_helper.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/repository/operation_log_repository.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:get/get.dart';

class AssetController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();

  // 检查是否已经注册了 AccountDetailController
  final accountDetailController = Get.isRegistered<AccountDetailController>()
      ? Get.find<AccountDetailController>()
      : null;

  final assetRepository = AssetRepository();
  final operationLogRepository = OperationLogRepository();
  var assets = <Asset>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  Account? selectedAccount;
  String selectedCurrency = "CNY";
  CountSummaryType selectedCountType = CountSummaryType.SummaryAccount;
  String selectedCountTypeString = 'Summary Account';
  Icon selectedCurrencyIcon =
      const Icon(CupertinoIcons.money_yen, color: Colors.red);
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;
  bool enableCounting = true;
  String? selectedIcon; // 新增图标选择属性

  String tag = "None";
  String note = "";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    clearInputFields();
  }

  void clearInputFields() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Clear input fields
    nameController.clear();
    amountController.clear();
    selectedCurrency = "CNY";
    selectedAccount = null;
    enableCounting = true;
    selectedIcon = null; // 清除图标选择
  }

  void toggleCounting(bool value) {
    enableCounting = value;
    update(); // 通知 GetBuilder 更新
  }

  void updateRemainingCharacters(String text) {
    remainingCharacters.value = 20 - text.length;
    if (remainingCharacters.value <= 3) {
      remainingCharactersColor = Colors.red;
    } else if (remainingCharacters.value <= 10) {
      remainingCharactersColor = Colors.orange;
    } else {
      remainingCharactersColor = Colors.grey;
    }
    update();
  }

  void fetchAssets() async {
    List<Asset> retrievedAssets = await assetRepository.retrieveAssets();
    assets.assignAll(retrievedAssets);
  }

  Future<void> addAsset() async {
    try {
      var newAsset = Asset(
        id: generateShortId(),
        name: nameController.text,
        amount: double.parse(amountController.text),
        currency: selectedCurrency,
        tag: tag,
        note: note,
        accountId: selectedAccount?.id ?? '',
        enableCounting: enableCounting,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        type: AccountAssetType.CASH.name,
        extra: {'icon': selectedIcon}, // 将选择的图标保存到 extra 字段
      );

      await assetRepository.createAsset(newAsset);

      await operationLogRepository.recordAssetCreate(newAsset);
      await accountPageLogic.refreshAccount();
      if (accountDetailController != null) {
        accountDetailController!.refreshCardData();
        accountDetailController!.refresh();
      }
      Get.back(); // Close the dialog or page
    } catch (e) {
      debugPrint('Error adding asset: $e');
      showErrorTips(FinanceLocales.snackbar_add_asset_failure.tr);
    }
  }

  Future<void> updateAsset(Asset asset) async {
    try {
      asset.name = nameController.text;
      asset.amount = double.parse(amountController.text);
      asset.currency = selectedCurrency;
      asset.accountId =
          selectedAccount?.id ?? ''; // Ensure accountId is not null
      asset.enableCounting = enableCounting;
      asset.updatedAt = DateTime.now().millisecondsSinceEpoch;
      asset.extra = {'icon': selectedIcon}; // 更新 extra 字段中的图标

      await assetRepository.updateAsset(asset);
      await operationLogRepository.recordAssetUpdate(asset);
      await accountPageLogic.refreshAccount();

      if (accountDetailController != null) {
        accountDetailController!.refreshCardData();
        accountDetailController!.refresh();
      }
      Get.back(); // Close the dialog or page
    } catch (e) {
      debugPrint('Error updating asset: $e');
      showErrorTips(FinanceLocales.snackbar_update_asset_failure.tr);
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      await operationLogRepository.recordAssetDelete(asset);
      await assetRepository.deleteAsset(asset.id!);
      await accountPageLogic.refreshAccount();

      if (accountDetailController != null) {
        accountDetailController!.refreshCardData();
        accountDetailController!.refresh();
      }
    } catch (e) {
      debugPrint('Error deleting asset: $e');
      showErrorTips(FinanceLocales.snackbar_delete_asset_failure.tr);
    }
  }
}
