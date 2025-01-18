import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();
  final accountRepository = AccountRepository();
  final nameController = TextEditingController();
  String selectedCurrency = CurrencyType.CNY.name;
  String selectedAccountType = AccountType.CASH.name;
  String selectedAccountCardStyle = CreditCardStyle.primary.name;
  String selectedColor = "0xFFFFABAB";
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;

  @override
  void onClose() {
    super.onClose();
    clearInputFields();
  }

  void clearInputFields() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Clear input fields
    nameController.clear();
  }

  void setAccount(Account account) {
    nameController.text = account.name;
    selectedCurrency = account.currency;
    selectedColor = account.color;
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
      }, // Store as a Map
    );
    await accountRepository.createAccount(newAccount);
    await accountPageLogic.refreshAccount();
  }

  Future<void> updateAccount(Account account) async {
    account.name = nameController.text;
    account.color = selectedColor;
    account.currency = selectedCurrency;
    account.extra = {
      'cardStyle': selectedAccountCardStyle,
    }; // Update extra with Map
    await accountRepository.updateAccount(account);
    await accountPageLogic.refreshAccount();
  }

  Future<void> deleteAccount(String accountId) async {
    await accountRepository.deleteAccount(accountId);
    await accountPageLogic.refreshAccount();
  }
}
