import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:get/get.dart';

class CreditCardController extends GetxController {
  AccountPageState accountPageState = Get.find<AccountPageLogic>().state;

  var activeIndex = 0.obs;
  late PageController pageController;

  List<CreditCardData> cards = [];
  List<Transaction> transactions = [];

  CreditCardController(int initialIndex) {
    activeIndex.value = initialIndex;
    pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void onReady() {
    debugPrint("CreditCardController onReady, activeIndex: ${activeIndex.value}");
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint("CreditCardController onInit, activeIndex: ${activeIndex.value}");
    cards.addAll(generateCreditCardData());
  }

  void setActiveIndex(int index) {
    activeIndex.value = index;
    update();
  }

  List<CreditCardData> generateCreditCardData() {
    return accountPageState.accounts.map((account) {
      return CreditCardData(
        type: CreditCardType.visa,
        id: account.id!,
        name: account.name,
        number: account.id!,
        style: getCardStyleByName(account.extra['cardStyle'])!,
        balance:
        "${getCurrencySymbolByName(account.currency)} ${account.balance}",
      );
    }).toList();
  }

  List<Transaction> generateTransactions(List<Asset> assets) {
    return assets.map((asset) {
      return Transaction(
          title: asset.name,
          date:
          DateUtil.formatDateMs(asset.createdAt, format: DateFormats.full),
          amount: asset.amount,
          // icon: asset.iconPath,
          icon: 'assets/icons/tiktok.png');
    }).toList();
  }
}