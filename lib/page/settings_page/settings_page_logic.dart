import 'package:flutter_finance_app/helper/finance_ui_manager.dart';
import 'package:flutter_finance_app/intl/finance_internation.dart';
import 'package:get/get.dart';

class SettingsPageLogic extends GetxController {
  String selectedLanguage = FinanceInternation.localeMap[financeUI.appLocale]!;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
