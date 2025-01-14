import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail.logic.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccountDetailsPage extends StatelessWidget {
  final Account account;
  final AccountDetailLogic logic = Get.put(AccountDetailLogic());

  AccountDetailsPage({super.key, required this.account}) {
    logic.updateAssets(account.assets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        backgroundColor: Color(int.parse(account.color)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(int.parse(account.color)),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Obx(() => _buildAccountSummary(logic.assets)),
              ),
              const SizedBox(height: 16),
              Obx(() => _buildAssetList(context, logic.assets)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open asset edit page (add new asset)
          await showCupertinoModalBottomSheet(
            expand: true,
            context: context,
            enableDrag: false,
            builder: (context) => EditAssetPage(account: account),
          );
          // Clear input fields after modal is closed
          _clearInputFields();
        },
        backgroundColor: Color(int.parse(account.color)),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Account summary
  Widget _buildAccountSummary(List<Asset> assets) {
    final filteredAssets =
        assets.where((asset) => asset.enableCounting).toList();
    final totalAssets = filteredAssets
        .where((asset) => asset.amount >= 0)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final totalDebt = filteredAssets
        .where((asset) => asset.amount < 0)
        .fold<double>(0, (sum, item) => sum + item.amount.abs());
    final netAssets = totalAssets - totalDebt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Overview',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Assets',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      totalAssets.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Debt',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      totalDebt > 0
                          ? "-${totalDebt.toStringAsFixed(2)}"
                          : totalDebt.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Net Assets',
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
    );
  }

  // Asset list
  Widget _buildAssetList(BuildContext context, List<Asset> assets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Asset List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...assets.map((asset) {
            return GestureDetector(
              onTap: () async {
                print("onTap asset:${asset.toMap()}");
                // Open asset edit page (edit existing asset)
                await showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  enableDrag: false,
                  builder: (context) =>
                      EditAssetPage(account: account, asset: asset),
                );
                // Clear input fields after modal is closed
                _clearInputFields();
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
                    asset.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${asset.amount}',
                    style: TextStyle(
                      fontSize: 16,
                      color: asset.amount >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _clearInputFields() {
    final accountPageLogic = Get.find<AssetController>();
    accountPageLogic.clearInputFields();
  }
}
