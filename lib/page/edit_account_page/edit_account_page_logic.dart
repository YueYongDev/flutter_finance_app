import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();
  final dbHelper = DatabaseHelper();
  final nameController = TextEditingController();
  String selectedCurrency = "CNY";
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
    var uuid = const Uuid();
    var newAccount = Account(
      id: uuid.v4(),
      name: nameController.text,
      color: selectedColor,
      currency: selectedCurrency,
      balance: 0.0,
      change: '0',
      lastUpdateTime: DateTime.now().millisecondsSinceEpoch,
      createTime: DateTime.now().millisecondsSinceEpoch,
      assets: [],
    );
    await dbHelper.insertAccount(newAccount.toMap());
    await accountPageLogic.refreshAccount();
  }

  Future<void> updateAccount(Account account) async {
    account.name = nameController.text;
    account.color = selectedColor;
    account.currency = selectedCurrency;
    await dbHelper.updateAccount(account.id!, account.toMap());
    await accountPageLogic.refreshAccount();
  }

  Future<void> deleteAccount(String accountId) async {
    await dbHelper.deleteAccount(accountId);
    await accountPageLogic.refreshAccount();
  }
}
