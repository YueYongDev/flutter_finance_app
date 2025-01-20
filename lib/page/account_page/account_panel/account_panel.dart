import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/colors.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_panel/account_panel_logic.dart';
import 'package:get/get.dart';

class AccountPanel extends StatelessWidget {
  const AccountPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _buildPanel(size);
  }

  Widget _buildPanel(Size size) {
    return GetBuilder<AccountPageLogic>(
      builder: (logic) {
        return Container(
          width: size.width,
          constraints: BoxConstraints(minHeight: size.height * .28),
          decoration: const BoxDecoration(
            color: AppColors.blueSecondary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopSection(logic),
              _buildChartSection(),
              _buildBottomSection(logic),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopSection(AccountPageLogic logic) {
    return Column(
      children: [
        Text(
          "¥ ${logic.state.netAssets}",
          style: const TextStyle(
            color: AppTextColors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildGrowthInfo(),
        Text(
          FinanceLocales.l_account_balance_uppercase.tr,
          style: const TextStyle(color: AppTextColors.white54),
        ),
      ],
    );
  }

  Widget _buildGrowthInfo() {
    final AccountPanelController controller = Get.put(AccountPanelController());
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
                controller.getFormattedBalanceChange(),
                style:
                    const TextStyle(color: AppTextColors.white, fontSize: 18),
              )),
          const SizedBox(width: 20),
          Obx(() => _GrowthIndicator(
                percentage: controller.getFormattedPercentage(),
                isPositive: controller.isPositiveChange.value,
              )),
          _buildExpandButton(controller),
        ],
      ),
    );
  }

  Widget _buildExpandButton(AccountPanelController controller) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          controller.isExpanded.value ? Icons.expand_less : Icons.expand_more,
          color: Colors.white,
        ),
        onPressed: () => controller.isExpanded.toggle(),
      );
    });
  }

  Widget _buildChartSection() {
    final AccountPanelController controller =
        Get.put(AccountPanelController(accountId: "mock_account_id"));
    return Obx(() {
      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: controller.isExpanded.value
            ? _buildChart(controller)
            : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildChart(AccountPanelController controller) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(right: 20),
      child: LineChart(
        _createChartData(controller),
      ),
    );
  }

  LineChartData _createChartData(AccountPanelController controller) {
    final spots = controller.generateChartData();
    final displaySpots =
        spots.length > 10 ? spots.skip(spots.length - 10).toList() : spots;
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: displaySpots,
          isCurved: true,
          color: Colors.white,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
      minY: controller.minY,
      maxY: controller.maxY,
      minX: 0,
      maxX: 8,
      titlesData: _createTitlesData(controller, displaySpots.length),
      borderData: _createBorderData(),
      gridData: _createGridData(),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot spot) {
              return LineTooltipItem(
                '¥${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: AppColors.blueSecondary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  FlTitlesData _createTitlesData(
      AccountPanelController controller, int spotsLength) {
    return FlTitlesData(
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
          reservedSize: 46,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() < spotsLength) {
              return Text(
                controller.getFormattedDate(value.toInt()),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            } else {
              return const Text('xxx');
            }
          },
          reservedSize: 22,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlBorderData _createBorderData() {
    return FlBorderData(
      show: true,
      border: const Border(
        left: BorderSide(color: Colors.white, width: 2),
        bottom: BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  FlGridData _createGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (value) => const FlLine(
        color: Colors.white54,
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (value) => const FlLine(
        color: Colors.white54,
        strokeWidth: 1,
      ),
    );
  }

  Widget _buildBottomSection(AccountPageLogic logic) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoBlock(
            "${logic.state.totalDebt}",
            FinanceLocales.l_debt_label.tr,
          ),
          const _VerticalDivider(),
          _buildInfoBlock(
            "${logic.state.totalAssets}",
            FinanceLocales.l_asset_label.tr,
          ),
          const _VerticalDivider(),
          _buildInfoBlock(
            "${logic.state.accounts.length}",
            FinanceLocales.l_account_label.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTextColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: AppTextColors.white54),
        ),
      ],
    );
  }
}

class _GrowthIndicator extends StatelessWidget {
  final String percentage;
  final bool isPositive;

  const _GrowthIndicator({
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward_sharp : Icons.arrow_downward_sharp,
          color: isPositive ? AppTextColors.green : AppTextColors.red,
        ),
        Text(
          percentage,
          style: TextStyle(
            color: isPositive ? AppTextColors.green : AppTextColors.red,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: AppTextColors.white54,
    );
  }
}
