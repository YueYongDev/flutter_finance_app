import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/account_detail/account_detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AccountListWidget extends StatelessWidget {
  const AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> accounts = _generateAccounts();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverMasonryGrid.extent(
          maxCrossAxisExtent: isTablet ? 300 : 200, // 平板上更宽
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return _buildAccountCard(account, index);
          },
        ));
  }

  List<Map<String, dynamic>> _generateAccounts() {
    return [
      {
        'name': '支付宝',
        'balance': 84290.45,
        'color': Colors.purple,
        'change': '+125.78',
        'assets': [
          {'name': '余额宝', 'amount': 1758.08},
          {'name': '花呗', 'amount': -2019.29},
          {'name': '基金', 'amount': 65408.66},
          {'name': '余利宝', 'amount': 37.50},
          {'name': '黄金', 'amount': 6591.58},
          {'name': '网商银行', 'amount': 0.00},
        ],
      },
      {
        'name': '微信钱包',
        'balance': 23567.77,
        'color': Colors.blue,
        'change': '-320.45',
        'assets': [
          {'name': '零钱通', 'amount': 8483.54},
          {'name': '理财通', 'amount': 15084.23},
        ],
      },
      {
        'name': '招商银行',
        'balance': -29862.25,
        'color': Colors.green,
        'change': '+430.67',
        'assets': [
          {'name': '存款', 'amount': 14206.47},
          {'name': '贷款', 'amount': -44068.72},
        ],
      },
    ];
  }

  Widget _buildAccountCard(Map<String, dynamic> account, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => AccountDetailsPage(account: account),
          ),
        );
      },
      child: Card(
        color: account['color'].withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                '余额: ${account['balance']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '变化: ${account['change']}',
                style: TextStyle(
                  fontSize: 14,
                  color: account['change'].startsWith('+')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
