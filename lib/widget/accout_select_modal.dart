import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccountSelectModal extends StatelessWidget {
  final List<Account> accounts;

  const AccountSelectModal({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
          middle: Text('Select Account',
              style: TextStyle(color: CupertinoColors.label, fontSize: 18))),
      body: SafeArea(
        // bottom: false,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            physics: const ClampingScrollPhysics(),
            children: accounts.map((account) {
              return Column(
                children: [
                  CupertinoListTile(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 5, bottom: 5),
                    title: Text(account.name),
                    onTap: () {
                      Navigator.of(context).pop(account);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: CupertinoColors.systemGrey6,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
