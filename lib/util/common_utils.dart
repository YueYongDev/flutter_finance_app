import 'dart:math';

import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';

getCurrencyIconByName(String currencyName) {
  for (var currency in currencyList) {
    if (currency.containsKey(currencyName)) {
      return currency[currencyName];
    }
  }
  return null;
}

String? getCurrencySymbolByName(String currencyName) {
  switch (currencyName) {
    case 'CNY':
      return '¥';
    case 'HKD':
      return 'HK\$';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    default:
      return null;
  }
}

CreditCardType getAccountCardType(Account account) {
  if (account.type == 'CASH') {
    return CreditCardType.cash;
  }
  String accountBankType = account.extra['bankType'];
  if (accountBankType == BankType.VISA.name) {
    return CreditCardType.visa;
  }
  if (accountBankType == BankType.MASTERCARD.name) {
    return CreditCardType.masterCard;
  }
  if (accountBankType == BankType.UNIONPAY.name) {
    return CreditCardType.unionPay;
  }
  return CreditCardType.visa;
}

CreditCardStyle? getCardStyleByName(String cardStyle) {
  switch (cardStyle) {
    case 'PRIMARY':
      return CreditCardStyle.primary;
    case 'SECONDARY':
      return CreditCardStyle.secondary;
    case 'ACCENT':
      return CreditCardStyle.accent;
    case 'ON_BLACK':
      return CreditCardStyle.onBlack;
    case 'ON_WHITE':
      return CreditCardStyle.onWhite;
  }
  return null;
}

String generateShortId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rnd = Random();
  final buffer = StringBuffer();
  for (int i = 0; i < 16; i++) {
    if (i > 0 && i % 4 == 0) {
      buffer.write('-');
    }
    buffer.write(chars[rnd.nextInt(chars.length)]);
  }
  return buffer.toString();
}
