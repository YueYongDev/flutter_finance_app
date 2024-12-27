import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/transfer_page/transfer_page_logic.dart';
import 'package:get/get.dart';

class TransferPage extends StatelessWidget {
  final TransferController controller = Get.put(TransferController());

  TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Transfer out'),
              subtitle: const Text('Account'),
              trailing: Text(controller.selectedFromAccount),
              onTap: () {
                // 实现账户选择逻辑
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Transfer in'),
              subtitle: const Text('Account'),
              trailing: Text(controller.selectedToAccount),
              onTap: () {
                // 实现账户选择逻辑
              },
            ),
            const Divider(),
            TextField(
              controller: controller.amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Transfer amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.performTransfer,
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
