import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SliverList buildAccountList(List<Map<String, dynamic>> accounts) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        final account = accounts[index];
        return buildAccountTile(account, context);
      },
      childCount: accounts.length,
    ),
  );
}

Widget buildAccountTile(Map<String, dynamic> account, BuildContext context) {
  final assets = _generateAssets();
  final Color backgroundColor =
      CupertinoTheme.of(Get.context!).barBackgroundColor;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 18.0),
    child: ExpansionTile(
      backgroundColor: account['color'].withOpacity(0.2),
      collapsedBackgroundColor: Colors.grey[200],
      shape: _buildShape(),
      collapsedShape: _buildShape(),
      controlAffinity: ListTileControlAffinity.leading,
      title: _buildTitle(account),
      trailing: _buildTrailing(account, context),
      children: [
        _buildExpandedContent(backgroundColor, account, assets),
      ],
    ),
  );
}

List<Map<String, String>> _generateAssets() {
  return [
    {'name': '资产1', 'balance': '0.00', 'debt': '-1.00'},
    {'name': '资产2', 'balance': '500.00', 'debt': '-50.00'},
    // 更多资产项...
  ];
}

RoundedRectangleBorder _buildShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    side: const BorderSide(color: Colors.transparent, width: 0),
  );
}

Widget _buildTitle(Map<String, dynamic> account) {
  return Row(
    children: [
      CircleAvatar(
        radius: 8,
        backgroundColor: account['color'],
      ),
      const SizedBox(width: 15),
      Text(account['name']),
    ],
  );
}

Widget _buildTrailing(Map<String, dynamic> account, BuildContext context) {
  return GestureDetector(
    onTap: () => _showDialog(context),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(account['count'].toString()),
        const SizedBox(width: 8),
        const Icon(Icons.add),
      ],
    ),
  );
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('添加新项目'),
        content: Text('这里是对话框的内容...'),
        actions: <Widget>[
          TextButton(
              child: Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}

Widget _buildExpandedContent(
  Color backgroundColor,
  Map<String, dynamic> account,
  List<Map<String, String>> assets,
) {
  return Container(
    color: backgroundColor,
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
    child: Column(
      children: [
        _buildSingleListTile(account),
        const SizedBox(height: 2.0),
        _buildAssetsList(assets),
      ],
    ),
  );
}

Widget _buildSingleListTile(Map<String, dynamic> account) {
  return Container(
    decoration: BoxDecoration(
      color: account['color'].withOpacity(0.3),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListTile(
      title: Text(account['name']),
      subtitle: Text('Assets ${account['balance']}  Debt ${account['debt']}'),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

Widget _buildAssetsList(List<Map<String, String>> assets) {
  return Column(
    children: assets.map((asset) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(asset['name']!),
          subtitle: Text('Assets ${asset['balance']}  Debt ${asset['debt']}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
    }).toList(),
  );
}
