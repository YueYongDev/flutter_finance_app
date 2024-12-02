import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/transfer_page/transfer_page_logic.dart';
import 'package:get/get.dart';

class TransferPage extends StatelessWidget {
  final TransferController controller = Get.put(TransferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Transfer out'),
              subtitle: Text('Account'),
              trailing: Text(controller.selectedFromAccount),
              onTap: () {
                // 实现账户选择逻辑
              },
            ),
            Divider(),
            ListTile(
              title: Text('Transfer in'),
              subtitle: Text('Account'),
              trailing: Text(controller.selectedToAccount),
              onTap: () {
                // 实现账户选择逻辑
              },
            ),
            Divider(),
            TextField(
              controller: controller.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Transfer amount',
              ),
              keyboardType: TextInputType.number,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: controller.performTransfer,
              child: Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
