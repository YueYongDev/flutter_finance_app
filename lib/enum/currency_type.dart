import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';

enum CurrencyType {
  // CNY,
  CNY;
  // USD,
  // HKD;

  Icon get icon {
    switch (this) {
      case CurrencyType.CNY:
        return const Icon(CupertinoIcons.money_yen, color: Colors.red);
      // case CurrencyType.USD:
      //   return const Icon(CupertinoIcons.money_dollar, color: Colors.green);
      // case CurrencyType.HKD:
      //   return const Icon(CupertinoIcons.money_dollar, color: Colors.redAccent);
    }
  }

  String get displayName {
    switch (this) {
      case CurrencyType.CNY:
        return FinanceLocales.l_currency_cny.tr;
      // case CurrencyType.USD:
      //   return FinanceLocales.l_currency_us_dollar.tr;
      // case CurrencyType.HKD:
      //   return FinanceLocales.l_currency_hk_dollar.tr;
    }
  }

  String? get currencySymbol {
    switch (this) {
      case CurrencyType.CNY:
        return '¥';
      // case CurrencyType.HKD:
      //   return 'HK\$';
      // case CurrencyType.USD:
      //   return '\$';
    }
  }
}
