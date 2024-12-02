import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  String selectedFromAccount = "Select account";
  String selectedToAccount = "Select account";
  final amountController = TextEditingController();

  void performTransfer() {
    // 在这里实现转账逻辑
    if (selectedFromAccount != "Select account" &&
        selectedToAccount != "Select account" &&
        amountController.text.isNotEmpty) {
      double amount = double.parse(amountController.text);

      // 假设账户余额和更新逻辑
      print(
          'Transferring $amount from $selectedFromAccount to $selectedToAccount');

      // 完成后关闭页面或显示确认信息
      Get.back();
    } else {
      // 将错误消息显示给用户
      Get.snackbar("Error", "Please select accounts and enter amount.");
    }
  }
}
