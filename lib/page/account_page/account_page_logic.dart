import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/page/account_page/account_panel/account_panel_logic.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/service/balance_history_service.dart';
import 'package:get/get.dart';

class AccountPageLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final AccountPageState state = AccountPageState();
  final BalanceHistoryService _balanceHistoryService = Get.find();

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

    state.netAssets =
        double.parse((state.totalAssets + state.totalDebt).toStringAsFixed(2));

    // 记录总余额变化
    await _balanceHistoryService.checkAndRecordTotalBalance(state.netAssets);

    // 记录每个账户的余额变化
    for (var account in list) {
      await _balanceHistoryService.checkAndRecordAccountBalance(
          account.id!, account.balance);
    }

    // 检查是否已经注册了 AccountPanelController
    final accountPanelLogic = Get.isRegistered<AccountPanelController>()
        ? Get.find<AccountPanelController>()
        : null;
    if (accountPanelLogic != null) {
      accountPanelLogic.loadBalanceHistory();
      accountPanelLogic.update();
    }

    update();
  }

  Future<List<Account>> fetchAllAccountsWithAssets() async {
    final accountRepository = AccountRepository();
    final assetRepository = AssetRepository();
    List<Account> accounts = await accountRepository.retrieveAccounts();
    for (var account in accounts) {
      account.assets =
          await assetRepository.retrieveAssetsByAccountId(account.id!);
      account.balance = account.assets
          .where((asset) => asset.enableCounting)
          .fold(0.0, (sum, asset) => sum + asset.amount);

      debugPrint(
          "${account.name} has ${account.assets.length} assets with a total balance of ${account.balance}");
    }
    return accounts;
  }
}
