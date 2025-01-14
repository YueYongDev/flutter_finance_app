import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail.logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AssetController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();
  final accountDetailLogic = Get.find<AccountDetailLogic>();

  final dbHelper = DatabaseHelper();
  var assets = <Asset>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  Account? selectedAccount;
  String selectedCurrency = "CNY";
  CountSummaryType selectedCountType = CountSummaryType.SummaryAccount;
  String selectedCountTypeString = 'Summart Account';
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
    List<Asset> retrievedAssets = await dbHelper
        .getAssets()
        .then((result) => result.map((map) => Asset.fromMap(map)).toList());
    assets.assignAll(retrievedAssets);
  }

  Future<void> addAsset() async {
    try {
      var uuid = const Uuid();
      var newAsset = Asset(
        id: uuid.v4(),
        name: nameController.text,
        amount: double.parse(amountController.text),
        currency: selectedCurrency,
        tag: tag,
        note: note,
        accountId: selectedAccount?.id ?? '',
        enableCounting: enableCounting,
      );

      await dbHelper.insertAsset(newAsset.toMap());
      await accountPageLogic.refreshAccount();
      await accountDetailLogic
          .refreshAccountAndAssets(selectedAccount?.id ?? '');
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

      await dbHelper.updateAsset(asset.id!, asset.toMap());
      await accountPageLogic.refreshAccount();
      await accountDetailLogic.refreshAccountAndAssets(asset.accountId);
      Get.back(); // Close the dialog or page
    } catch (e) {
      debugPrint('Error updating asset: $e');
      Get.snackbar('Error', 'Failed to update asset. Please try again.');
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      await dbHelper.deleteAsset(asset.id!);
      await accountPageLogic.refreshAccount();
      await accountDetailLogic.refreshAccountAndAssets(asset.accountId);
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
