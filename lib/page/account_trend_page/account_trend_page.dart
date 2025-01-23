import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset_operation.dart';
import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/repository/asset_operation_repository.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart'; // Import timeline_tile

class _TimelineItem {
  final int timestamp;
  final String type;
  final dynamic data;

  _TimelineItem({
    required this.timestamp,
    required this.type,
    required this.data,
  });
}

class AccountTrendPage extends StatelessWidget {
  final BalanceHistoryRepository balanceHistoryRepository =
      BalanceHistoryRepository();
  final AssetOperationRepository assetOperationRepository =
      AssetOperationRepository();
  final Account account;

  AccountTrendPage({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Trends for ${account.name}'),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: Future.wait([
          balanceHistoryRepository.getAccountHistory(account.id!, limit: 30),
          assetOperationRepository.getAssetOperationsForAccount(account.id!),
        ]).then((results) {
          final balanceHistory = results[0] as List<BalanceHistory>;
          final assetOperations = results[1] as List<AssetOperation>;

          // Combine both lists and sort by timestamp
          final combined = [
            ...balanceHistory.map((h) => _TimelineItem(
                  timestamp: h.recordedAt,
                  type: 'balance',
                  data: h,
                )),
            ...assetOperations.map((o) => _TimelineItem(
                  timestamp: o.createdAt,
                  type: 'operation',
                  data: o,
                )),
          ];

          combined.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return combined;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error_outline, size: 50, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Oops!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Something went wrong. Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<_TimelineItem> timelineItems =
                snapshot.data! as List<_TimelineItem>;
            List<BalanceHistory> balanceHistory = timelineItems
                .where((item) => item.type == 'balance')
                .map((item) => item.data as BalanceHistory)
                .toList();
            List<AssetOperation> assetOperation = timelineItems
                .where((item) => item.type == 'operation')
                .map((item) => item.data as AssetOperation)
                .toList();
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: LineChart(mainData(balanceHistory)),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: assetOperation.length,
                      itemBuilder: (context, index) {
                        final operation = assetOperation[index];
                        return TimelineTile(
                          alignment: TimelineAlign.start,
                          isFirst: index == 0,
                          isLast: index == timelineItems.length - 1,
                          indicatorStyle: const IndicatorStyle(
                            width: 20,
                            color: Colors.green,
                          ),
                          endChild: ListTile(
                            title: Text(
                                'Asset Operation: ${DateTime.fromMillisecondsSinceEpoch(operation.createdAt).toString().substring(0, 10)}'),
                            subtitle: Text(
                                '${operation.description}: ${operation.amount.toStringAsFixed(2)}'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  LineChartData mainData(List<BalanceHistory> balanceHistoryList) {
    // 如果数据为空，返回一个空的图表配置
    if (balanceHistoryList.isEmpty) {
      return LineChartData(
        lineBarsData: [],
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      );
    }

    // 按 recordedAt 时间排序
    balanceHistoryList.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    // 将时间戳转换为 DateTime 对象
    final List<DateTime> dates = balanceHistoryList
        .where((history) {
          return history.recordedAt >= history.createdAt;
        })
        .map((history) =>
            DateTime.fromMillisecondsSinceEpoch(history.recordedAt))
        .toList();

    final DateTime earliestDate = dates.first;
    final DateTime latestDate = dates.last;

    // 横轴最小值和最大值使用时间戳
    final double minX = earliestDate.millisecondsSinceEpoch.toDouble();
    final double maxX = latestDate.millisecondsSinceEpoch.toDouble();

    // 准备图表数据点
    final List<FlSpot> spots = balanceHistoryList.map((history) {
      final double x = history.recordedAt.toDouble();
      final double y = history.totalBalance;
      return FlSpot(x, y);
    }).toList();

    // 计算 Y 轴的最小值和最大值，并添加一定的边距
    final double minY = (balanceHistoryList
            .map((history) => history.totalBalance)
            .reduce((a, b) => a < b ? a : b)) *
        0.95; // 下边距 5%
    final double maxY = (balanceHistoryList
            .map((history) => history.totalBalance)
            .reduce((a, b) => a > b ? a : b)) *
        1.05; // 上边距 5%

    // 使用 intl 包格式化日期
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withValues(alpha: .3),
                Colors.blue.withValues(alpha: .0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // 动态计算标签间隔，以避免标签重叠
            interval: (maxX - minX) / 5, // 大致 5 个标签
            getTitlesWidget: (value, meta) {
              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              final String formattedDate = dateFormat.format(date);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: (maxY - minY) / 5, // Y 轴 5 个标签
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // 可选：隐藏竖直网格线
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      minX: minX,
      maxX: maxX > minX ? maxX : minX + 1, // 防止 maxX 等于 minX
      minY: minY < 0 ? minY : 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
              final String formattedDate = dateFormat.format(date);
              return LineTooltipItem(
                '$formattedDate\n\$${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }
}
