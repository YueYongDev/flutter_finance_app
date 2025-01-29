import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/page/account_page/account_panel/account_panel_logic.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/service/balance_history_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccountPageLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final AccountPageState state = AccountPageState();
  final BalanceHistoryService _balanceHistoryService = Get.find();
  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    await refreshAccount();
    loadAccountOrder();
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

    // Record total balance change
    await _balanceHistoryService.checkAndRecordTotalBalance(state.netAssets);

    // Record each account's balance change
    for (var account in list) {
      await _balanceHistoryService.checkAndRecordAccountBalance(
          account.id!, account.balance);
    }

    // Check if AccountPanelController is registered
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

  void loadAccountOrder() {
    List<dynamic>? savedOrderDynamic = box.read<List<dynamic>>('accountOrder');
    List<String> savedOrder = savedOrderDynamic?.map((e) => e as String).toList() ?? [];
    if (savedOrder.isNotEmpty) {
      state.accounts.sort((a, b) =>
          savedOrder.indexOf(a.id!).compareTo(savedOrder.indexOf(b.id!)));
    }
  }

  void saveAccountOrder() {
    List<String> accountOrder =
        state.accounts.map((account) => account.id!).toList();
    box.write('accountOrder', accountOrder);
  }

  void updateAccountOrder(int oldIndex, int newIndex) {
    debugPrint(
        "oldIndex: $oldIndex, newIndex: $newIndex, accounts: ${state.accounts}");
    if (state.accounts.isEmpty ||
        oldIndex < 0 ||
        oldIndex >= state.accounts.length ||
        newIndex < 0 ||
        newIndex >= state.accounts.length) {
      return;
    }
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Account account = state.accounts.removeAt(oldIndex);
    state.accounts.insert(newIndex, account);
    saveAccountOrder();
    update();
  }
}
