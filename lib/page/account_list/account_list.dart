import 'package:animations/animations.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/account_detail/account_detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AccountListWidget extends StatelessWidget {
  const AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> accounts = _generateAccounts();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverMasonryGrid.extent(
          maxCrossAxisExtent: isTablet ? 300 : 200,
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
        'color': Colors.lightBlue[400],
        'change': '+125.78',
        'lastUpdateTime': 1735385741312,
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
        'color': Colors.lightGreen[400],
        'change': '-320.45',
        'lastUpdateTime': 1735385741312,
        'assets': [
          {'name': '零钱通', 'amount': 8483.54},
          {'name': '理财通', 'amount': 15084.23},
        ],
      },
      {
        'name': '招商银行',
        'balance': -29862.25,
        'color': Colors.orangeAccent[200],
        'change': '+430.67',
        'lastUpdateTime': 1735385741312,
        'assets': [
          {'name': '存款', 'amount': 14206.47},
          {'name': '贷款', 'amount': -44068.72},
        ],
      },
    ];
  }

  Widget _buildAccountCard(Map<String, dynamic> account, int index) {
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      openBuilder: (context, _) => AccountDetailsPage(account: account),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      openShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Card(
          elevation: 0,
          color: account['color'], // Set card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['name'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  '余额: ${account['balance']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  '上次更新: ${TimelineUtil.formatA(
                    account['lastUpdateTime'],
                    languageCode: 'zh',
                    short: true,
                  )}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
