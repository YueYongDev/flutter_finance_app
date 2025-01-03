import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccountDetailsPage extends StatelessWidget {
  final Map<String, dynamic> account;

  const AccountDetailsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final assets = account['assets'] as List<Map<String, dynamic>>;

    // 计算总资产和净资产
    final totalAssets =
        assets.fold<double>(0, (sum, item) => sum + item['amount']);
    final netAssets = totalAssets; // 假设无额外债务

    return Scaffold(
      appBar: AppBar(
        title: Text(account['name']),
        backgroundColor: account['color'],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAccountSummary(account, totalAssets, netAssets),
            const SizedBox(height: 16),
            _buildAssetList(context, assets),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 打开资产编辑页面（新增资产）
          showCupertinoModalBottomSheet(
            expand: true,
            context: context,
            enableDrag: false,
            builder: (context) => EditAssetPage(account: account),
          );
        },
        backgroundColor: account['color'],
        child: const Icon(Icons.add),
      ),
    );
  }

  // 账户概览
  Widget _buildAccountSummary(
      Map<String, dynamic> account, double totalAssets, double netAssets) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: account['color'],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '账户总览',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '总资产',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalAssets.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '净资产',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    netAssets.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 资产清单
  Widget _buildAssetList(
      BuildContext context, List<Map<String, dynamic>> assets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '资产清单',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...assets.map((asset) {
            return GestureDetector(
              onTap: () {
                // 打开资产编辑页面（编辑现有资产）
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  enableDrag: false,
                  builder: (context) =>
                      EditAssetPage(account: account, asset: asset),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    size: 32,
                    color: Colors.blue,
                  ),
                  title: Text(
                    asset['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${asset['amount']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: asset['amount'] >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
