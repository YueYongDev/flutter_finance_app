import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'account_list_logic.dart';

class AccountListWidget extends StatelessWidget {
  final logic = Get.put(AccountListLogic());

  AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return GetBuilder<AccountPageLogic>(builder: (controller) {
      return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverMasonryGrid.extent(
          maxCrossAxisExtent: isTablet ? 300 : 200,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childCount: controller.state.accounts.length,
          itemBuilder: (context, index) {
            final account = controller.state.accounts[index];
            return _buildAccountCard(account, index);
          },
        ),
      );
    });
  }

  Widget _buildAccountCard(Account account, int index) {
    debugPrint(
        '_buildAccountCard|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
    return GestureDetector(
      onTap: () {
        debugPrint(
            'onTap|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => AccountDetailsPage(account: account),
          ),
        );
      },
      onLongPress: () {
        debugPrint(
            'onLongPress|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
        showCupertinoModalBottomSheet(
          context: Get.context!,
          builder: (context) => EditAccountPage(account: account),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0,
          color: Color(int.parse(account.color)),
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
                  account.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  '余额: ${account.balance}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  '上次更新: ${TimelineUtil.formatA(
                    account.lastUpdateTime,
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
