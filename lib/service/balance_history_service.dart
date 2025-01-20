import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:get/get.dart';

class BalanceHistoryService extends GetxService {
  static BalanceHistoryService get to => Get.find();

  final BalanceHistoryRepository _repository = BalanceHistoryRepository();
  final _lastRecordedTotalBalance = 0.0.obs;
  final _lastRecordedAccountBalances = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // 初始化时获取最新的余额记录
    _loadLastRecordedBalances();
  }

  Future<void> _loadLastRecordedBalances() async {
    final latestTotal = await _repository.getLatestTotal();
    if (latestTotal != null) {
      _lastRecordedTotalBalance.value = latestTotal.totalBalance;
    }
  }

  // 检查并记录总余额变化
  Future<void> checkAndRecordTotalBalance(double currentBalance) async {
    if (_lastRecordedTotalBalance.value != currentBalance) {
      await _repository.recordTotalBalance(currentBalance);
      _lastRecordedTotalBalance.value = currentBalance;
      // await _repository.cleanupOldRecords();
    }
  }

  // 检查并记录单个账户余额变化
  Future<void> checkAndRecordAccountBalance(
      String accountId, double currentBalance) async {
    final lastBalance = _lastRecordedAccountBalances[accountId] ?? 0.0;
    if (lastBalance != currentBalance) {
      await _repository.recordAccountBalance(accountId, currentBalance);
      _lastRecordedAccountBalances[accountId] = currentBalance;
      // await _repository.cleanupOldRecords();
    }
  }

  // 获取账户的余额历史
  Future<List<BalanceHistory>> getAccountHistory(String accountId,
      {int? limit}) {
    return _repository.getAccountHistory(accountId, limit: limit);
  }

  // 获取总余额历史
  Future<List<BalanceHistory>> getTotalHistory({int? limit}) {
    return _repository.getTotalHistory(limit: limit);
  }

  // 获取账户最新余额记录
  Future<BalanceHistory?> getLatestForAccount(String accountId) {
    return _repository.getLatestForAccount(accountId);
  }

  // 获取最新总余额记录
  Future<BalanceHistory?> getLatestTotal() {
    return _repository.getLatestTotal();
  }
}
