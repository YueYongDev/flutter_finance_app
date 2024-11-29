import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

SliverToBoxAdapter buildNetAssetsSection(BuildContext context) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Assets (CNY)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '300,782.45',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Total Assets: 334,629.24'),
                  const Text('Total Debt: -33,846.79'),
                ],
              ),
            ),
            Expanded(
              flex: 1, // Make sure the chart takes half the space
              child: Container(
                margin: EdgeInsets.only(left: 15),
                width: double.infinity, // Max width allowed by Expanded
                height: 100, // Set desired chart height
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: generateSampleData(),
                        isCurved: true,
                        // colors: [Colors.blue],
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineTouchData: LineTouchData(enabled: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<FlSpot> generateSampleData() {
  return [
    FlSpot(0, 300),
    FlSpot(1, 315),
    FlSpot(2, 295),
    FlSpot(3, 310),
    FlSpot(4, 320),
  ];
}
