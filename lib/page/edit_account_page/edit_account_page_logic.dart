import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController {
  final dbHelper = DatabaseHelper();
  var accounts = <Account>[].obs;
  final nameController = TextEditingController();
  String selectedCurrency = "CNY";
  String selectedColor = "FFABAB";
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

  void fetchAccounts() async {
    List<Account> retrievedAccounts = await dbHelper
        .getAccounts()
        .then((result) => result.map((map) => Account.fromMap(map)).toList());
    accounts.assignAll(retrievedAccounts);
  }

  Future<void> addAccount() async {
    var uuid = const Uuid();
    var newAccount = Account(
      id: uuid.v4(),
      name: nameController.text,
      color: selectedColor,
      currency: selectedCurrency,
    );
    await dbHelper.insertAccount(newAccount.toMap());
    fetchAccounts();
    Get.back(); // Close the dialog or page
  }
}
