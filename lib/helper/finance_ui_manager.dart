import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final financeUI = FinanceUIManager();

class FinanceUIManager {
  static const localeKey = "financeLocal";

  var appLocale = Get.deviceLocale?.languageCode ?? "en";

  set localeSet(String locale) {
    if (locale.isEmpty) {
      locale = Get.deviceLocale?.languageCode ?? "en";
    }
    appLocale = locale;
  }

  changeLocal(String local) {
    if (local == appLocale) {
      return false;
    }
    shareSetStringData(localeKey, local);
    localeSet = local;
    Locale temLocal = currentLocale;
    Get.updateLocale(temLocal);
  }

  Locale get currentLocale {
    String localeInAppSetting = shareGetStringData(localeKey);
    if (localeInAppSetting.isNotEmpty) {
      appLocale = localeInAppSetting;
    } else {
      appLocale = Get.deviceLocale?.languageCode ?? "en";
    }
    if (appLocale == "en") {
      return const Locale("en", "US");
    } else {
      return const Locale("zh", "CN");
    }
  }

  shareSetIntData(String key, int data) {
    final box = GetStorage();
    box.write(key, data);
  }

  shareGetIntData(String key) {
    final box = GetStorage();
    return box.read(key) ?? 0;
  }

  shareSetStringData(String key, String data) {
    final box = GetStorage();
    box.write(key, data);
  }

  String shareGetStringData(String key) {
    final box = GetStorage();
    return box.read(key) ?? "";
  }
}
