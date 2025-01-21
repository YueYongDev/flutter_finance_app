import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff1A77FF);
  static const Color secondary = Color(0xffFFBB05);
  static const Color accent = Color(0xffF5C3D2);
  static const Color border = Color(0xff505254);
  static const Color danger = Color(0xffF70000);
  static const Color success = Color(0xff04B616);
  static const Color black = Color(0xff1A1A1A);
  static const Color onBlack = Color(0xff353535);
  static const Color onWhite = Color(0xffEBEBEB);
  static const Color white = Color(0xffF2F2F2);
  static const Color grey = Color.fromRGBO(177, 179, 185, 1.0);
  static const Color whiteSecondary = Color.fromRGBO(83, 85, 155, 0.18);
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

class AppBorderRadius {
  static const double sm = 5;
  static const double md = 10;
  static const double lg = 15;
  static const double xl = 20;
  static const double xxl = 25;
}

class AppThemes {
  static ThemeData getTheme({bool isDark = true}) {
    return ThemeData(
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: AppColors.black,
      dividerColor: AppColors.border,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.black,
        onBackground: AppColors.onBlack,
        shadow: AppColors.black,
      ),
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          fixedSize: const Size.fromHeight(50),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 0, color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 0, color: AppColors.border),
          ),
          fillColor: AppColors.black,
        ),
        menuStyle: MenuStyle(
          backgroundColor:
              const MaterialStatePropertyAll<Color>(AppColors.black),
          elevation: const MaterialStatePropertyAll<double>(0),
          shape: MaterialStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.border),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 0, color: Colors.transparent),
        ),
        fillColor: AppColors.black,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 0, color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 0, color: AppColors.border),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => getTheme();
}
