import 'package:flutter/material.dart';

import 'account_list.dart';
import 'navigation_bar.dart';
import 'net_assets_section.dart';

class AccountPage extends StatelessWidget {
  final List<Map<String, dynamic>> accounts = List.generate(
    20,
    (index) => {
      'name': '账户 ${index + 1}',
      'count': index + 1,
      'color': Colors.primaries[index % Colors.primaries.length],
    },
  );

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          buildNavigationBar(),
          buildNetAssetsSection(context),
          buildAccountList(accounts),
        ],
      ),
    );
  }
}
