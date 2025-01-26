import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';

Future<dynamic> pushFadeInRoute(
  BuildContext context, {
  required RoutePageBuilder pageBuilder,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: pageBuilder,
      transitionDuration: AccountCardConstants.pageTransitionDuration,
      reverseTransitionDuration: AccountCardConstants.pageTransitionDuration,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        _,
        Widget child,
      ) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    ),
  );
}

showSuccessTips(String msg) {
  Get.snackbar(
    FinanceLocales.snackbar_success.tr,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

showErrorTips(String msg) {
  Get.snackbar(
    FinanceLocales.snackbar_error.tr,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

showWarningTips(String msg) {
  Get.snackbar(
    FinanceLocales.snackbar_warning.tr,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
  );
}
