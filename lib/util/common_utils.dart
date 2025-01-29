import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';

getCurrencyIconByName(String currencyName) {
  for (var currency in CurrencyType.values) {
    if (currency.name == currencyName) {
      return currency.icon;
    }
  }
  return null;
}

String? getCurrencySymbolByName(String currencyName) {
  for (var currency in CurrencyType.values) {
    if (currency.name == currencyName) {
      return currency.currencySymbol;
    }
  }
  return null;
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


AccountCardStyle? getCardStyleByName(String cardStyle) {
  for (var style in AccountCardStyle.values) {
    if (style.name== cardStyle) {
      return style;
    }
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
