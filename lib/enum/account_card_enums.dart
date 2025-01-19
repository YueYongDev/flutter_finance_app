import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_styles.dart';

enum CreditCardType {
  cash,
  visa,
  masterCard,
  unionPay;

  String get label {
    switch (this) {
      case cash:
        return 'Cash';
      case visa:
        return 'Visa';
      case masterCard:
        return 'MasterCard';
        case unionPay:
      return 'unionPay';
    }
  }
}

enum CreditCardStyle {
  primary,
  secondary,
  accent,
  onBlack,
  onWhite;

  Color get color {
    switch (this) {
      case primary:
        return AppColors.primary;
      case secondary:
        return AppColors.secondary;
      case accent:
        return AppColors.accent;
      case onBlack:
        return AppColors.onBlack;
      case onWhite:
        return AppColors.onWhite;
    }
  }

  Color get textColor {
    return color.computeLuminance() > 0.3 ? AppColors.black : AppColors.white;
  }

  String get frontBg => '$name-pattern-front.png';

  String get backBg => '$name-pattern-back.png';
}
