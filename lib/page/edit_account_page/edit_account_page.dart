import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page_logic.dart';
import 'package:get/get.dart';

class EditAccountPage extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Account')),
      body: GetBuilder<AccountController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Account Name (e.g. Alipay)',
                    prefixIcon: CircleAvatar(
                      backgroundColor:
                          Color(int.parse("0xFF${controller.selectedColor}")),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Color'),
                SizedBox(height: 8.0),
                // Implement color selection here
                SizedBox(height: 16.0),
                Text('Currency'),
                DropdownButton<String>(
                  value: controller.selectedCurrency,
                  onChanged: (value) {
                    controller.selectedCurrency = value!;
                    controller.update(); // Trigger a rebuild
                  },
                  items: ['CNY', 'USD', 'EUR'].map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: controller.addAccount,
                  child: Text('Add Account'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
