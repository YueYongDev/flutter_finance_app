import 'package:flutter_finance_app/constant/common_constant.dart';
import 'package:flutter_finance_app/constant/settings_page_key.dart';
import 'package:flutter_finance_app/enum/currency_type.dart';
import 'package:flutter_finance_app/helper/finance_ui_manager.dart';
import 'package:flutter_finance_app/intl/finance_internation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPageLogic extends GetxController {
  String selectedLanguage = FinanceInternation.localeMap[financeUI.appLocale]!;
  String selectedCurrency = CurrencyType.CNY.name;
  bool icloudSyncEnable = false;
  final box = GetStorage();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    selectedCurrency = box.read(currencyKey) ?? CurrencyType.CNY.name;
    icloudSyncEnable = box.read(iCloudSyncKey) ?? false;
  }

  String getCurrencyDisplayName() {
    return CurrencyType.values
        .firstWhere((type) => type.name == selectedCurrency)
        .displayName;
  }

  changeDefaultCurrency(String defaultCurrency) {
    box.write(currencyKey, defaultCurrency);
  }

  void toggleIcloudSync(bool value) {
    icloudSyncEnable = value;
    changeIcloudSyncEnable(value);
    update(); // 通知 GetBuilder 更新
  }

  changeIcloudSyncEnable(bool enable) {
    box.write(iCloudSyncKey, enable);
  }

  Future<void> launchToFeedback() async {
    final Uri url = Uri.parse(feedbackUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
