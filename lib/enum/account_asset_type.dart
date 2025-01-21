import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';

enum AccountType {
  /// 现金
  CASH,

  /// 信用卡
  CREDIT_CARD,

  /// 借记卡
  DEBIT_CARD;

  String get displayName {
    switch (this) {
      case AccountType.CASH:
        return FinanceLocales.account_type_cash.tr;
      case AccountType.CREDIT_CARD:
        return FinanceLocales.account_type_credit_card.tr;
      case AccountType.DEBIT_CARD:
        return FinanceLocales.account_type_debit_card.tr;
    }
  }
}

enum AccountAssetType {
  /// 现金
  CASH,

  /// 股票
  STOCK,

  /// 基金
  FUND;
}

enum BankType {
  VISA,
  MASTERCARD,
  AMERICAN_EXPRESS,
  UNIONPAY;

  String get displayName {
    switch (this) {
      case BankType.VISA:
        return FinanceLocales.bank_type_visa.tr;
      case BankType.MASTERCARD:
        return FinanceLocales.bank_type_mastercard.tr;
      case BankType.AMERICAN_EXPRESS:
        return FinanceLocales.bank_type_american_express.tr;
      case BankType.UNIONPAY:
        return FinanceLocales.bank_type_unionpay.tr;
    }
  }
}
