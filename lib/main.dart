import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finance_app/page/account_page/account_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
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
            title: 'Account App',
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
                bodyLarge: TextStyle(color: Colors.black.withOpacity(0.87)),
                bodyMedium: TextStyle(color: Colors.black.withOpacity(0.54)),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            home: AccountPage(),
          );
        });
  }
}
