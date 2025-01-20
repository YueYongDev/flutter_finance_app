import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/service/balance_history_service.dart';

class AccountPanelController extends GetxController {
  var isExpanded = false.obs;
  var currentBalance = 0.0.obs;
  var balanceChange = 0.0.obs;
  var changePercentage = 0.0.obs;
  var isPositiveChange = true.obs;
  var balanceHistories = <BalanceHistory>[].obs;

  final BalanceHistoryService _balanceService = Get.find();
  String? accountId; // 如果为null，则显示总余额

  AccountPanelController({this.accountId});

  @override
  void onInit() {
    super.onInit();
    loadBalanceHistory();
  }

  Future<void> loadBalanceHistory() async {
    List<BalanceHistory> historyData;
    if (accountId != null) {
      historyData =
          await _balanceService.getAccountHistory(accountId!, limit: 30);
    } else {
      historyData = await _balanceService.getTotalHistory(limit: 30);
    }

    // historyData =
    //     await _balanceService.getAccountHistory("mock_account_id", limit: 30);

    if (historyData.isEmpty) {
      // 如果没有历史数据，记录当前余额
      if (accountId != null) {
        // 如果是单个账户，等待AccountPageLogic更新时会自动记录
        return;
      } else {
        await _balanceService.checkAndRecordTotalBalance(0.0);
      }
      // 重新加载数据
      loadBalanceHistory();
      return;
    }
    balanceHistories.value = historyData;
    calculateBalanceChanges();
  }

  void calculateBalanceChanges() {
    if (balanceHistories.length >= 2) {
      final currentValue = balanceHistories[0].totalBalance;
      final previousValue = balanceHistories[1].totalBalance;

      currentBalance.value = currentValue;
      balanceChange.value = currentValue - previousValue;
      changePercentage.value = (balanceChange.value / previousValue) * 100;
      isPositiveChange.value = balanceChange.value >= 0;
    } else if (balanceHistories.length == 1) {
      currentBalance.value = balanceHistories[0].totalBalance;
      balanceChange.value = 0.0;
      changePercentage.value = 0.0;
      isPositiveChange.value = true;
    }
  }

  String getFormattedBalanceChange() {
    return '${isPositiveChange.value ? "+" : "-"}¥${balanceChange.value.abs().toStringAsFixed(2)}';
  }

  String getFormattedPercentage() {
    return '${changePercentage.value.abs().toStringAsFixed(1)}%';
  }

  List<FlSpot> generateChartData() {
    final Map<DateTime, double> aggregatedData = {};

    for (var history in balanceHistories) {
      final date = DateTime.fromMillisecondsSinceEpoch(history.recordedAt);
      final day = DateTime(date.year, date.month, date.day);

      if (aggregatedData.containsKey(day)) {
        aggregatedData[day] = aggregatedData[day]! + history.totalBalance;
      } else {
        aggregatedData[day] = history.totalBalance;
      }
    }

    List<DateTime> sortedDates = aggregatedData.keys.toList()..sort();
    return List<FlSpot>.generate(sortedDates.length, (index) {
      DateTime date = sortedDates[index];
      debugPrint(
          'index: $index, date: $date, balance: ${aggregatedData[date]}');
      return FlSpot(index.toDouble(), aggregatedData[date]!);
    });
  }

  String getFormattedDate(int index) {
    int reversedIndex = balanceHistories.length - 1 - index;
    if (reversedIndex >= 0 && reversedIndex < balanceHistories.length) {
      final date = DateTime.fromMillisecondsSinceEpoch(
          balanceHistories[reversedIndex].recordedAt);
      return DateFormat('MM/dd').format(date);
    }
    return '';
  }

  double get minY {
    if (balanceHistories.isEmpty) return 0;
    final minBalance = balanceHistories
        .map((e) => e.totalBalance)
        .reduce((min, value) => value < min ? value : min);
    return minBalance * 0.9;
  }

  double get maxY {
    if (balanceHistories.isEmpty) return 0;
    final maxBalance = balanceHistories
        .map((e) => e.totalBalance)
        .reduce((max, value) => value > max ? value : max);
    return maxBalance * 1.1;
  }

  // 用于定期更新余额历史
  Future<void> updateBalanceHistory() async {
    await _balanceService.checkAndRecordTotalBalance(0.0);
    // 重新加载数据
    loadBalanceHistory();
  }
}
