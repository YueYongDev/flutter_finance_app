import 'package:flutter/material.dart';
import 'package:flutter_finance_app/navigation_bar.dart';
import 'package:flutter_finance_app/page/account_page/account_list/account_list.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_panel/account_panel.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  final logic = Get.put(AccountPageLogic());

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          buildNavigationBar(),
          const SliverToBoxAdapter(child: AccountPanel()),
          // const SliverToBoxAdapter(child: NetAssetsSection()),
          AccountListWidget(),
        ],
      ),
    );
  }
}
