import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  final accountPageLogic = Get.find<AccountPageLogic>();
  final dbHelper = DatabaseHelper();
  var accounts = <Account>[].obs;
  final nameController = TextEditingController();
  String selectedCurrency = "CNY";
  String selectedColor = "0xFFFFABAB";
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;

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
}
