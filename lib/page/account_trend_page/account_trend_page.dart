import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:timeline_tile/timeline_tile.dart'; // Import timeline_tile

class AccountTrendPage extends StatelessWidget {
  final BalanceHistoryRepository balanceHistoryRepository =
      BalanceHistoryRepository();
  final Account account;

  AccountTrendPage({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Trends for ${account.name}'),
      ),
      body: FutureBuilder<List<BalanceHistory>?>(
        future:
            balanceHistoryRepository.getAccountHistory(account.id!, limit: 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<BalanceHistory> balanceHistoryList = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: LineChart(
                    mainData(balanceHistoryList),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: balanceHistoryList.length,
                  itemBuilder: (context, index) {
                    BalanceHistory history = balanceHistoryList[index];
                    return TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      isFirst: index == 0,
                      isLast: index == balanceHistoryList.length - 1,
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.blue,
                      ),
                      endChild: ListTile(
                        title: Text(
                            'Date: ${DateTime.fromMillisecondsSinceEpoch(history.recordedAt).toString().substring(0, 10)}'),
                        subtitle: Text(
                            'Amount: ${history.totalBalance.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  LineChartData mainData(List<BalanceHistory> balanceHistoryList) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: balanceHistoryList.map((history) {
            return FlSpot(
              DateTime.fromMillisecondsSinceEpoch(history.recordedAt)
                  .difference(DateTime.now())
                  .inDays
                  .toDouble(),
              history.totalBalance.toDouble(),
            );
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
    );
  }
}
