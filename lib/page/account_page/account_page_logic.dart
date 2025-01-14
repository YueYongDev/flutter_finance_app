import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:get/get.dart';

class AccountPageLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  final AccountPageState state = AccountPageState();

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Correctly using the mixin for the vsync parameter
    );
    await refreshAccount();
  }

  void startRotation() {
    animationController.repeat(); // Use repeat to keep it spinning
  }

  void stopRotation() {
    animationController.stop(canceled: false); // Stop the animation
  }

  @override
  void onClose() {
    animationController.dispose(); // Dispose of animationController properly
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

  refreshAccount() async {
    List<Account> list = await fetchAllAccountsWithAssets();
    state.accounts.clear();
    state.accounts.addAll(list);
    update();
  }

  Future<List<Account>> fetchAllAccountsWithAssets() async {
    debugPrint('Fetching accounts with assets');
    final accountRepository = AccountRepository();
    final assetRepository = AssetRepository();
    List<Account> accounts = await accountRepository.retrieveAccounts();
    for (var account in accounts) {
      account.assets =
          await assetRepository.retrieveAssetsByAccountId(account.id!);
      print("${account.name} has ${account.assets.length} assets");
    }
    return accounts;
  }
}
