import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/entity/operation_log.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:flutter_finance_app/repository/operation_log_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  final OperationLogRepository operationLogRepository =
      OperationLogRepository();

  final Account account;

  AccountTrendPage({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text("账户走势"),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.onBlack,
                size: 24.sp,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<dynamic>?>(
              future: Future.wait([
                balanceHistoryRepository.getAccountHistory(account.id!),
                // balanceHistoryRepository.getAccountHistory("mock_account_id"),
                operationLogRepository.getByAccount(account.id!),
                // operationLogRepository.getByAccount("mock_account_id"),
              ]).then((results) {
                final balanceHistory = results[0] as List<BalanceHistory>;
                final operationLogs = results[1] as List<OperationLog>;

                // Combine both lists and sort by timestamp
                final combined = [
                  ...balanceHistory.map((h) => _TimelineItem(
                        timestamp: h.recordedAt,
                        type: 'balance',
                        data: h,
                      )),
                  ...operationLogs.map((o) => _TimelineItem(
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
                  return errorWidget();
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<_TimelineItem> timelineItems =
                      snapshot.data! as List<_TimelineItem>;
                  return buildTrendPage(timelineItems);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget errorWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(Icons.error_outline, size: 50, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Oops!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
  }

  buildTrendPage(List<_TimelineItem> timelineItems) {
    List<BalanceHistory> balanceHistory = timelineItems
        .where((item) => item.type == 'balance')
        .map((item) => item.data as BalanceHistory)
        .toList();
    List<OperationLog> assetOperation = timelineItems
        .where((item) => item.type == 'operation')
        .map((item) => item.data as OperationLog)
        .toList();

    // 用 SliverList 来支持上下滑动
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              child: SizedBox(
                height: 300,
                child: LineChart(mainData(balanceHistory)),
              ),
            ),
            const Text("变更记录",
                style: TextStyle(
                  color: Color(0xFF29272E),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.96,
                )),
            SafeArea(
              bottom: true,
              top: false,
              child: MediaQuery.removePadding(
                context: Get.context!,
                removeTop: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemCount: assetOperation.length,
                  itemBuilder: (context, index) {
                    return buildTimelineTile(assetOperation, index);
                  },
                ),
              ),
            ),
          ],
        ),
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

    DateTime endDate;
    DateTime startDate;
    if (balanceHistoryList.length > 10) {
      endDate = DateTime.fromMillisecondsSinceEpoch(
          balanceHistoryList.last.recordedAt);
      startDate = endDate.add(const Duration(days: -10));
    } else {
      startDate = DateTime.fromMillisecondsSinceEpoch(
          balanceHistoryList.first.recordedAt);

      endDate = startDate.add(const Duration(days: 10));
    }

    DateTime startDateOnly =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endDateOnly =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    List<BalanceHistory> selectedHistoryList =
        balanceHistoryList.where((history) {
      DateTime recordedDate =
          DateTime.fromMillisecondsSinceEpoch(history.recordedAt);
      return recordedDate.isAfter(startDateOnly) &&
          recordedDate.isBefore(endDateOnly);
    }).toList();

    // debugPrint("startDate:$startDate,endDate:$endDate");
    // selectedHistoryList.forEach((e) => debugPrint(
    //     "${e.totalBalance},${DateTime.fromMillisecondsSinceEpoch(e.recordedAt)}"));
    // 将选中的记录转换为点
    final List<FlSpot> spots = selectedHistoryList.map((history) {
      final double x = history.recordedAt.toDouble();
      final double y = history.totalBalance;
      return FlSpot(x, y);
    }).toList();

    // 计算 Y 轴的最小值和最大值，并添加一定的边距
    double minY = (selectedHistoryList
            .map((history) => history.totalBalance)
            .reduce((a, b) => a < b ? a : b)) *
        0.95;
    double maxY = (selectedHistoryList
            .map((history) => history.totalBalance)
            .reduce((a, b) => a > b ? a : b)) *
        1.05;

    // 确保最大值和最小值不相等
    if (maxY == minY) {
      maxY += 1;
    }

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blueAccent,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withValues(alpha: 0.3),
                Colors.blueAccent.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      titlesData: const FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        // horizontalInterval: (maxY - minY) / 5,
        // getDrawingHorizontalLine: (value) {
        //   return FlLine(
        //     color: Colors.grey.withOpacity(0.3),
        //     strokeWidth: 1,
        //   );
        // },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
          right: BorderSide.none, // 不显示右边
          top: BorderSide.none, // 不显示上边
        ),
      ),
      minX: startDate.millisecondsSinceEpoch.toDouble(),
      maxX: endDate.millisecondsSinceEpoch.toDouble(),
      minY: minY > 0 ? minY : 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                  '${date.toLocal().toIso8601String().substring(0, 10)}\n\$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
            fitInsideVertically: true,
            fitInsideHorizontally: true),
        handleBuiltInTouches: true,
      ),
    );
  }

  buildTimelineTile(List<OperationLog> operationLogList, int index) {
    final operation = operationLogList[index];
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: index == 0,
      isLast: index == operationLogList.length - 1,
      indicatorStyle: IndicatorStyle(
        width: 24,
        color: Colors.black,
        indicator: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.black,
            size: 14,
          ),
        ),
      ),
      afterLineStyle: const LineStyle(
        color: AppColors.onBlack,
        thickness: 2.0,
      ),
      beforeLineStyle: const LineStyle(
        color: AppColors.onBlack,
        thickness: 2.0,
      ),
      endChild: ListTile(
        title: Text(
          '${operation.getDisplayOperationType()} - ${operation.getDisplayOperationKey()}: ${operation.value}',
        ),
        subtitle: Text(
          DateUtil.formatDateMs(operation.createdAt),
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
