import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/operation_log_repository.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();

  // 检查是否已经注册了 AccountDetailController
  final accountDetailController = Get.isRegistered<AccountDetailController>()
      ? Get.find<AccountDetailController>()
      : null;

  final accountRepository = AccountRepository();
  final operationLogRepository = OperationLogRepository();

  final nameController = TextEditingController();

  String selectedCurrency = CurrencyType.CNY.name;
  String selectedAccountType = AccountType.CASH.name;
  String selectedAccountCardStyle = CreditCardStyle.primary.name;
  String selectedBankType = "";

  String selectedColor = "0xFFFFABAB";
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;

  @override
  void onClose() {
    super.onClose();
    clearInputFields();
  }

  String getAccountTypeDisplayName() {
    return AccountType.values
        .firstWhere((type) => type.name == selectedAccountType)
        .displayName;
  }

  String getBankTypeDisplayName() {
    return BankType.values
        .firstWhere((type) => type.name == selectedBankType)
        .displayName;
  }

  String getCurrencyDisplayName() {
    return CurrencyType.values
        .firstWhere((type) => type.name == selectedCurrency)
        .displayName;
  }

  void clearInputFields() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Clear input fields
    nameController.clear();
  }

  void setAccount(Account account) {
    debugPrint('setAccount: ${account.toMap()}');
    nameController.text = account.name;
    selectedCurrency = account.currency;
    selectedColor = account.color;
    selectedAccountType = account.type;
    selectedAccountCardStyle = account.extra['cardStyle'];
    if (account.extra.containsKey('bankType')) {
      selectedBankType = account.extra['bankType'];
    }
    updateRemainingCharacters(account.name);
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

  Future<void> addAccount() async {
    var newAccount = Account(
      id: generateShortId(),
      name: nameController.text,
      color: selectedColor,
      currency: selectedCurrency,
      balance: 0.0,
      change: '0',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      assets: [],
      type: selectedAccountType,
      extra: {
        'cardStyle': selectedAccountCardStyle,
      },
    );
    if (selectedBankType.isNotEmpty) {
      newAccount.extra['bankType'] = selectedBankType;
    }

    await accountRepository.createAccount(newAccount);
    await operationLogRepository.recordAccountCreate(newAccount);

    await accountPageLogic.refreshAccount();
    if (accountDetailController != null) {
      accountDetailController!.refreshCardData();
      accountDetailController!.refresh();
    }
  }

  Future<void> updateAccount(Account account) async {
    account.name = nameController.text;
    account.color = selectedColor;
    account.currency = selectedCurrency;
    account.type = selectedAccountType;
    account.extra = {'cardStyle': selectedAccountCardStyle};
    if (selectedBankType.isNotEmpty) {
      account.extra['bankType'] = selectedBankType;
    }
    await accountRepository.updateAccount(account);
    await operationLogRepository.recordAccountUpdate(account);
    await accountPageLogic.refreshAccount();
    if (accountDetailController != null) {
      accountDetailController!.refreshCardData();
      accountDetailController!.refresh();
    }
  }

  Future<void> deleteAccount(String accountId) async {
    Account account = await accountRepository.retrieveAccount(accountId);
    await operationLogRepository.recordAccountDelete(account);

    await accountRepository.deleteAccount(accountId);
    await accountPageLogic.refreshAccount();
  }
}
