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
    return topPanel(size);
  }

  Widget topPanel(Size size) {
    final AccountPanelController controller = Get.put(AccountPanelController());

    return GetBuilder<AccountPageLogic>(builder: (logic) {
      return Container(
        width: size.width,
        constraints: BoxConstraints(
          minHeight: size.height * .28,
        ),
        decoration: const BoxDecoration(
            color: AppColors.blueSecondary,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "¥${logic.state.netAssets}",
                  style: const TextStyle(
                      color: AppTextColors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("+\$9,736",
                          style: TextStyle(
                              color: AppTextColors.white, fontSize: 18)),
                      SizedBox(
                        width: size.width * .05,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.arrow_upward_sharp,
                            color: AppTextColors.green,
                          ),
                          Text(
                            "2.3%",
                            style: TextStyle(
                                color: AppTextColors.green, fontSize: 18),
                          )
                        ],
                      ),
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
                ),
                 Text(
                  FinanceLocales.l_account_balance_uppercase.tr,
                  style: const TextStyle(color: AppTextColors.white54),
                )
              ],
            ),
            Obx(() {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: controller.isExpanded.value
                    ? Container(
                        height: 200,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(right: 20),
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
                                left: BorderSide(color: Colors.white, width: 2),
                                bottom:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                            gridData: FlGridData(
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
                            ),
                            lineTouchData: const LineTouchData(enabled: true),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                panelBottomBlock("${logic.state.totalDebt}", FinanceLocales.l_debt_label.tr),
                Container(
                  height: 50,
                  width: 1,
                  color: AppTextColors.white54,
                ),
                panelBottomBlock("${logic.state.totalAssets}", FinanceLocales.l_asset_label.tr),
                Container(
                  height: 50,
                  width: 1,
                  color: AppTextColors.white54,
                ),
                panelBottomBlock("${logic.state.accounts.length}", FinanceLocales.l_account_label.tr),
              ],
            ),
            const SizedBox(height: 20)
          ],
        ),
      );
    });
  }

  Column panelBottomBlock(String title, String subTitle) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(title,
              style: const TextStyle(
                  color: AppTextColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        Text(subTitle,
            style: const TextStyle(color: AppTextColors.white54, fontSize: 13))
      ],
    );
  }
}
