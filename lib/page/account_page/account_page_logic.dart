import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/model/homeScreenModel.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:get/get.dart';

class AccountPageLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final AccountPageState state = AccountPageState();

  RxList<TypesOfDataItem> dataItemList = RxList<TypesOfDataItem>([
    TypesOfDataItem(title: "CARDS", icons: "assets/icons/ic_creditcard.png", isSelected: true),
    TypesOfDataItem(title: "BANK", icons: "assets/icons/ic_bank.png", isSelected: false),
    TypesOfDataItem(title: "ID’S", icons: "assets/icons/ic_id.png", isSelected: false),
    TypesOfDataItem(title: "BUSINESS", icons: "assets/icons/ic_business.png", isSelected: false),
    TypesOfDataItem(title: "PASSWORDS", icons: "assets/icons/ic_key.png", isSelected: false),
  ]);

  RxList<ChallengesDataBasedOnSelectionOfItem> cardDataList = RxList<ChallengesDataBasedOnSelectionOfItem>();

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    await refreshAccount();
  }

  void startRotation() {
    animationController.repeat();
  }

  void stopRotation() {
    animationController.stop(canceled: false);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    startRotation();
    try {
      await refreshAccount();
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      stopRotation();
    }
  }

  Future<void> refreshAccount() async {
    List<Account> list = await fetchAllAccountsWithAssets();
    state.accounts.clear();
    state.accounts.addAll(list);

    state.totalAssets = double.parse(list.fold(0.0, (previousValue, account) {
      return previousValue +
          account.assets
              .where((asset) => asset.enableCounting && asset.amount > 0)
              .fold(0.0, (sum, asset) => sum + asset.amount);
    }).toStringAsFixed(2));

    state.totalDebt = double.parse(list.fold(0.0, (previousValue, account) {
      return previousValue +
          account.assets
              .where((asset) => asset.enableCounting && asset.amount < 0)
              .fold(0.0, (sum, asset) => sum + asset.amount);
    }).toStringAsFixed(2));

    state.netAssets = double.parse((state.totalAssets + state.totalDebt).toStringAsFixed(2));

    // Map state.accounts to cardDataList
    cardDataList.value = state.accounts.map((account) {
      return ChallengesDataBasedOnSelectionOfItem(
        id: account.id,
        title: account.name,
        type: account.type,
        content: "¥ ${account.balance}",
        cardIcon: "assets/icons/ic_visaCard.png", // Replace with appropriate icon
        cardBGColor: Color(int.parse(account.color)), // Replace with appropriate color
      );
    }).toList();

    update();
  }

  Future<List<Account>> fetchAllAccountsWithAssets() async {
    final accountRepository = AccountRepository();
    final assetRepository = AssetRepository();
    List<Account> accounts = await accountRepository.retrieveAccounts();
    for (var account in accounts) {
      account.assets = await assetRepository.retrieveAssetsByAccountId(account.id!);
      account.balance = account.assets
          .where((asset) => asset.enableCounting)
          .fold(0.0, (sum, asset) => sum + asset.amount);

      debugPrint("${account.name} has ${account.assets.length} assets with a total balance of ${account.balance}");
    }
    return accounts;
  }
}