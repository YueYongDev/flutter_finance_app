import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/net_assets_section/net_assets_section_logic.dart';
import 'package:get/get.dart';

class NetAssetsSection extends StatelessWidget {
  const NetAssetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final NetAssetsController controller = Get.put(NetAssetsController());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepPurpleAccent[200],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<AccountPageLogic>(
                        builder: (controller) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Assets (CNY)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  controller.state.netAssets.toStringAsFixed(2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total Assets: ${controller.state.totalAssets.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total Debt: ${controller.state.totalDebt.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                )
                              ],
                            )),
                  ),
                  Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: controller.isExpanded.value
                          ? const SizedBox.shrink()
                          : Container(
                              key: const ValueKey('sideChart'),
                              margin: const EdgeInsets.only(left: 15),
                              width: 80,
                              height: 50,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: controller.generateSampleData(),
                                      isCurved: true,
                                      color: Colors.white,
                                      dotData: const FlDotData(show: false),
                                    ),
                                  ],
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  gridData: const FlGridData(show: false),
                                  lineTouchData:
                                      const LineTouchData(enabled: false),
                                ),
                              ),
                            ),
                    );
                  }),
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller.isExpanded.toggle();
                      },
                    );
                  }),
                ],
              ),
              Obx(() {
                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: controller.isExpanded.value
                      ? Container(
                          height: 200,
                          margin: const EdgeInsets.only(top: 10),
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.generateSampleData(),
                                  isCurved: true,
                                  color: Colors.white,
                                  dotData: const FlDotData(show: false),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) => Text(
                                      '\$${value.toInt()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    reservedSize: 40,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        controller
                                            .getFormattedDate(value.toInt()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      );
                                    },
                                    reservedSize: 22,
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  left:
                                      BorderSide(color: Colors.white, width: 2),
                                  bottom:
                                      BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) =>
                                    const FlLine(
                                  color: Colors.white30,
                                  strokeWidth: 1,
                                ),
                                getDrawingVerticalLine: (value) => const FlLine(
                                  color: Colors.white30,
                                  strokeWidth: 1,
                                ),
                              ),
                              lineTouchData: const LineTouchData(enabled: true),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
