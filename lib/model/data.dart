import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/util/common_utils.dart';

class AccountCardData {
  const AccountCardData({
    required this.id,
    required this.name,
    required this.type,
    this.number = '1234567812345678',
    this.style = AccountCardStyle.primary,
    this.balance = '0.00',
    this.lastUpdate = 0,
  });

  final String id;
  final String name;
  final String number;
  final AccountCardStyle style;
  final CreditCardType type;
  final String balance;
  final int lastUpdate;
}

class TabItem {
  const TabItem({
    required this.view,
    this.title = '',
  });

  final String title;
  final Widget view;
}

class OnBoardingItem {
  const OnBoardingItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;
}

const List<OnBoardingItem> onBoardingItems = [
  OnBoardingItem(
    title: 'onboarding_title_1',
    subtitle: 'onboarding_subtitle_1',
    image: 'assets/images/on-boarding-1.png',
  ),
  OnBoardingItem(
    title: 'onboarding_title_2',
    subtitle: 'onboarding_subtitle_2',
    image: 'assets/images/on-boarding-2.png',
  ),
  OnBoardingItem(
    title: 'onboarding_title_3',
    subtitle: 'onboarding_subtitle_3',
    image: 'assets/images/on-boarding-3.png',
  ),
];

List<AccountCardData> generateAccountCardData(List<Account> accounts) {
  return accounts.map((account) {
    return AccountCardData(
        /// 优先取bankType，没有再取accountType
        type: getAccountCardType(account),
        id: account.id!,
        name: account.name,
        number: account.id!,
        style: getCardStyleByName(account.extra['cardStyle'] ?? 'primary') ??
            AccountCardStyle.primary,
        lastUpdate: account.updatedAt,
        balance:
            "${getCurrencySymbolByName(account.currency)} ${account.balance.toStringAsFixed(2)}");

  }).toList();
}

class AssetItemData {
  const AssetItemData({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
  });

  final String title;
  final String date;
  final double amount;
  final String icon;
}
