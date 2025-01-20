import 'package:flutter_finance_app/intl/locales/intl_en_us.dart';
import 'package:flutter_finance_app/intl/locales/intl_zh_cn.dart';
import 'package:get/get.dart';

class FinanceInternation extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'zh': intlZhCN, //对应的中文翻译
      'en': intlEnUS, //对应英文翻译
    };
  }

  static const localeMap = {
    "en": "English",
    "zh": "中文",
  };
}
