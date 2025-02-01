import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finance_app/constant/settings_page_key.dart';
import 'package:flutter_finance_app/helper/finance_ui_manager.dart';
import 'package:flutter_finance_app/intl/finance_internation.dart';
import 'package:flutter_finance_app/page/account_page/account_page.dart';
import 'package:flutter_finance_app/page/on_boarding/on_boarding_page.dart';
import 'package:flutter_finance_app/service/balance_history_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  // 初始化服务
  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() async {
    final service = BalanceHistoryService();
    service.onInit();
    return service;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 设置iOS风格的状态栏
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Account App',
            translations: FinanceInternation(),
            //当前语言
            locale: financeUI.currentLocale,
            //本地语言发生变化后回调
            localeListResolutionCallback: (locales, supportedLocales) {
              debugPrint("当前系统语言环境$locales");
              return;
            },
            //当前语言不支持的语言类型时使用的默认语言
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              colorScheme: const ColorScheme.light(
                secondary: Colors.blueAccent,
              ),
              scaffoldBackgroundColor: Colors.grey[50],
              textTheme: TextTheme(
                titleLarge: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                bodyLarge:
                    TextStyle(color: Colors.black.withValues(alpha: .87)),
                bodyMedium:
                    TextStyle(color: Colors.black.withValues(alpha: .54)),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            home: GetStorage().read(kFirstLaunchKey) ?? true
                ? const OnBoardingPage()
                : AccountPage(),
          );
        });
  }
}
