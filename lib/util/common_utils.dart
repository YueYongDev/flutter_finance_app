import 'dart:math';

import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/enum/account_asset_type.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';

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

CreditCardType getCardTypeByName(String cardType) {
  switch (cardType) {
    case 'CASH':
      return CreditCardType.cash;
    case 'visa':
      return CreditCardType.visa;
    case 'masterCard':
      return CreditCardType.masterCard;
  }
  return CreditCardType.visa;
}

CreditCardStyle? getCardStyleByName(String cardStyle) {
  switch (cardStyle) {
    case 'primary':
      return CreditCardStyle.primary;
    case 'secondary':
      return CreditCardStyle.secondary;
    case 'accent':
      return CreditCardStyle.accent;
    case 'onBlack':
      return CreditCardStyle.onBlack;
    case 'onWhite':
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
