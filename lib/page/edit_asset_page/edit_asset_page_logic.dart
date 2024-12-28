import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/assets.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AssetController extends GetxController {
  final dbHelper = DatabaseHelper();
  var assets = <Asset>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  String selectedAccount = "Select Account";
  String selectedCurrency = "CNY";
  CountSummaryType selectedCountType = CountSummaryType.SummaryAccount;
  String selectedCountTypeString = 'Summart Account';
  Icon selectedCurrencyIcon = const Icon(
    CupertinoIcons.money_yen,
    color: Colors.red,
  );
  var remainingCharacters = 20.obs;
  Color remainingCharactersColor = Colors.grey;
  bool enableCounting = false;

  String tag = "None";
  String note = "";
  String countInfo = "Summary Account";

  var currencyList = [
    {
      'CNY': const Icon(
        CupertinoIcons.money_yen,
        color: Colors.red,
      )
    },
    {
      'HKD': const Icon(
        CupertinoIcons.money_dollar,
        color: Colors.redAccent,
      )
    },
    {
      'USD': const Icon(
        CupertinoIcons.money_dollar,
        color: Colors.green,
      )
    },
    {
      'EUR': const Icon(
        CupertinoIcons.money_euro,
        color: Colors.blue,
      )
    },
  ];

  getCurrencyIconByName(String currencyName) {
    for (var currency in currencyList) {
      if (currency.containsKey(currencyName)) {
        return currency[currencyName];
      }
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();

    fetchAssets();
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
    var uuid = const Uuid();
    var newAsset = Asset(
      id: uuid.v4(),
      name: nameController.text,
      amount: double.parse(amountController.text),
      currency: selectedCurrency,
      tag: tag,
      note: note,
      accountId: selectedAccount, // Modify to get actual account ID
      countInfo: countInfo,
    );
    await dbHelper.insertAsset(newAsset.toMap());
    fetchAssets();
    Get.back(); // Close the dialog or page
  }
}
