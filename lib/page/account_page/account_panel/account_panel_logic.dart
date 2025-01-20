import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AccountPanelController extends GetxController {
  var isExpanded = false.obs;

  List<Map<String, dynamic>> dataWithDates = [
    {'date': DateTime(2023, 1, 1), 'value': 300.0},
    {'date': DateTime(2023, 2, 1), 'value': 315.0},
    {'date': DateTime(2023, 3, 1), 'value': 295.0},
    {'date': DateTime(2023, 4, 1), 'value': 310.0},
    {'date': DateTime(2023, 5, 1), 'value': 320.0},
  ];

  List<FlSpot> generateSampleData() {
    return dataWithDates
        .asMap()
        .entries
        .map((entry) =>
        FlSpot(entry.key.toDouble(), entry.value['value'] as double))
        .toList();
  }

  String getFormattedDate(int index) {
    if (index >= 0 && index < dataWithDates.length) {
      return DateFormat.Md().format(dataWithDates[index]['date']);
    }
    return '';
  }
}
