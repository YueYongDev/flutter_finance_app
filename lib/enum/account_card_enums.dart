import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';

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

enum AccountCardStyle {
  primary,
  secondary,
  accent,
  onBlack,
  onWhite,
  lightCoral,
  plum,
  lightSalmon,
  lightSkyBlue,
  seaGreen,
  ;

  String get displayName {
    switch (this) {
      case primary:
        return FinanceLocales.l_primary_style.tr;
      case secondary:
        return FinanceLocales.l_secondary_style.tr;
      case accent:
        return FinanceLocales.l_accent_style.tr;
      case onBlack:
        return FinanceLocales.l_on_black_style.tr;
      case onWhite:
        return FinanceLocales.l_on_white_style.tr;
      case lightCoral:
        return FinanceLocales.l_light_coral_style.tr;
      case plum:
        return FinanceLocales.l_plum_style.tr;
      case lightSalmon:
        return FinanceLocales.l_light_salmon_style.tr;
      case lightSkyBlue:
        return FinanceLocales.l_light_sky_blue_style.tr;
      case seaGreen:
        return FinanceLocales.l_sea_green_style.tr;
    }
  }

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
      case lightCoral:
        return AppColors.lightCoral;
      case plum:
        return AppColors.plum;
      case lightSalmon:
        return AppColors.lightSalmon;
      case lightSkyBlue:
        return AppColors.lightSkyBlue;
      case seaGreen:
        return AppColors.seaGreen;
    }
  }

  Color get textColor {
    return color.computeLuminance() > 0.5 ? AppColors.black : AppColors.white;
  }

  String get frontBg => '$name-pattern-front.png';

  String get backBg => '$name-pattern-back.png';
}
