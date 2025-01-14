import 'package:flutter_finance_app/constant/common_constant.dart';

getCurrencyIconByName(String currencyName) {
  for (var currency in currencyList) {
    if (currency.containsKey(currencyName)) {
      return currency[currencyName];
    }
  }
  return null;
}
