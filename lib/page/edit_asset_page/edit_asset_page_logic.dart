import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail.logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:get/get.dart';

class AssetController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();

  // 检查是否已经注册了 AccountDetailLogic
  final accountDetailLogic = Get.isRegistered<AccountDetailLogic>()
      ? Get.find<AccountDetailLogic>()
      : null;

  final assetRepository = AssetRepository();
  var assets = <Asset>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  Account? selectedAccount;
  String selectedCurrency = "CNY";
  CountSummaryType selectedCountType = CountSummaryType.SummaryAccount;
  String selectedCountTypeString = 'Summary Account';
  Icon selectedCurrencyIcon = const Icon(
    CupertinoIcons.money_yen,
    color: Colors.red,
  );
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;
  bool enableCounting = true;

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
    selectedCurrency = '';
    selectedAccount = null;
    enableCounting = false;
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
        extra: {},
      );

      await assetRepository.createAsset(newAsset);
      await accountPageLogic.refreshAccount();
      if (accountDetailLogic != null) {
        await accountDetailLogic!
            .refreshAccountAndAssets(selectedAccount?.id ?? '');
      }
      Get.back(); // Close the dialog or page
    } catch (e) {
      debugPrint('Error adding asset: $e');
      Get.snackbar('Error', 'Failed to add asset. Please try again.');
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
      asset.extra = {}; // Update extra with Map
      await assetRepository.updateAsset(asset);
      await accountPageLogic.refreshAccount();
      if (accountDetailLogic != null) {
        await accountDetailLogic!
            .refreshAccountAndAssets(selectedAccount?.id ?? '');
      }
      Get.back(); // Close the dialog or page
    } catch (e) {
      debugPrint('Error updating asset: $e');
      Get.snackbar('Error', 'Failed to update asset. Please try again.');
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      await assetRepository.deleteAsset(asset.id!);
      await accountPageLogic.refreshAccount();
      if (accountDetailLogic != null) {
        await accountDetailLogic!
            .refreshAccountAndAssets(selectedAccount?.id ?? '');
      }
      Get.snackbar('Success', 'Asset deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      debugPrint('Error deleting asset: $e');
      Get.snackbar('Error', 'Failed to delete asset. Please try again.');
    }
  }
}
