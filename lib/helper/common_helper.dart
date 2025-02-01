import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

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

/// 获取分享位置的 Rect
Rect getSharePositionOrigin(BuildContext context) {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset position = box.localToGlobal(Offset.zero);
  final Size size = box.size;

  // 确保坐标在可见窗口范围内
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  final double dx = position.dx.clamp(0.0, screenWidth);
  final double dy = position.dy.clamp(0.0, screenHeight);

  return Rect.fromLTWH(dx, dy, size.width, size.height);
}

/// 分享导出的文件
Future<void> shareExportedFile(
    String filePath, Rect sharePositionOrigin) async {
  final File file = File(filePath);
  if (await file.exists()) {
    final XFile xFile = XFile(filePath);

    // 调用分享方法
    await Share.shareXFiles(
      [xFile],
      subject: '导出的账户',
      sharePositionOrigin: sharePositionOrigin, // 使用提前计算的 Rect
    );
  } else {
    debugPrint("文件不存在，无法保存");
    showErrorTips("文件不存在，无法保存");
  }
}
