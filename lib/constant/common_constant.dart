import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// List<Map<String, dynamic>> fetchAccounts() {
//   return [
//     {
//       'name': '支付宝',
//       'balance': 84290.45,
//       'color': Colors.lightBlue[400],
//       'change': '+125.78',
//       'lastUpdateTime': 1735385741312,
//       'assets': [
//         {'name': '余额宝', 'amount': 1758.08},
//         {'name': '花呗', 'amount': -2019.29},
//         {'name': '基金', 'amount': 65408.66},
//         {'name': '余利宝', 'amount': 37.50},
//         {'name': '黄金', 'amount': 6591.58},
//         {'name': '网商银行', 'amount': 0.00},
//       ],
//     },
//     {
//       'name': '微信钱包',
//       'balance': 23567.77,
//       'color': Colors.lightGreen[400],
//       'change': '-320.45',
//       'lastUpdateTime': 1735385741312,
//       'assets': [
//         {'name': '零钱通', 'amount': 8483.54},
//         {'name': '理财通', 'amount': 15084.23},
//       ],
//     },
//     {
//       'name': '招商银行',
//       'balance': -29862.25,
//       'color': Colors.orangeAccent[200],
//       'change': '+430.67',
//       'lastUpdateTime': 1735385741312,
//       'assets': [
//         {'name': '存款', 'amount': 14206.47},
//         {'name': '贷款', 'amount': -44068.72},
//       ],
//     },
//   ];
// }

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

const currencyList = [
  {
    'CNY': const Icon(
      CupertinoIcons.money_yen,
      color: Colors.red,
    )
  },
  {
    'HKD': const Icon(
      CupertinoIcons.money_dollar,
      color: Colors.redAccent,
    )
  },
  {
    'USD': const Icon(
      CupertinoIcons.money_dollar,
      color: Colors.green,
    )
  },
  {
    'EUR': const Icon(
      CupertinoIcons.money_euro,
      color: Colors.blue,
    )
  },
];
