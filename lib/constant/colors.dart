import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color whiteSecondary = Color.fromRGBO(83, 85, 155, 0.18);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color grey = Color.fromRGBO(177, 179, 185, 1.0);
  static const Color greySecondary = Color.fromRGBO(124, 130, 138, 1);
  static const Color greyLite = Colors.black12;
  static const Color blue = Color.fromRGBO(8, 127, 232, 1.0);
  static const Color red = Color.fromRGBO(227, 24, 24, 1.0);
  static const Color greenAccent = Colors.greenAccent;
  static const Color blueSecondary = Color.fromRGBO(0, 21, 44, 1.0);
}

class AppTextColors {
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color green = Colors.green;
  static const Color red = Color.fromRGBO(227, 24, 24, 1.0);

  static const Color white54 = Colors.white54;
  static const Color black26 = Colors.black26;
}

class MyAppColors {
  static Color primaryWhiteColor = const Color(0xffFFFFFF);
  static Color primaryBlackColor = const Color(0xFF1C232D);
  static Color primaryBlueColor = const Color(0xFF6E69F7);
  static Color primaryExtraLightGreenColor = const Color(0xFFECEADC);
  static Color primaryYellowColor = const Color(0xFFFFD12B);
  static Color primarySkyBlueColor = const Color(0xFFC1F8FF);
  static Color primaryLightGreenColor = const Color(0xFFF8EBB8);
  static Color primaryGreenColor = const Color(0xFFB9FCB5);
  static Color primaryLightBlueColor = const Color(0xFFCDE6FA);
  static Color primaryDarkGreyColor = const Color(0xFF52ADA2);
  static Color primaryExtraDarkGreyColor = const Color(0xFF5F5E63);
  static Color primaryLightBlackColor = const Color(0xFF2E343D);
  static Color primaryLightThemeColor = const Color(0xFF1C232D);
  static Color primaryDarkThemeColor = const Color(0xff232930);
  static Color primaryRedColor = const Color(0xFFFF224B);

  static LinearGradient customAppLinearColor = LinearGradient(colors: [
    primaryLightThemeColor,
    primaryDarkThemeColor,
  ]);
}
