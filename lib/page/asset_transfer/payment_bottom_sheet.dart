import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/mock/mock_data.dart';
import 'package:flutter_finance_app/page/asset_transfer/payment_button.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController sendingCardsController = TextEditingController();
  final TextEditingController receivingCardsController =
      TextEditingController();
  final TextEditingController accountsController = TextEditingController();
  String? selectedSendingCard = "0";
  String? selectedReceivingCard = "0";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardsEntries = <DropdownMenuEntry<String>>[];
    for (final card in mockAccountCards) {
      cardsEntries.add(
        DropdownMenuEntry<String>(
          value: card.id,
          label: '${card.type.label} - ${card.name}',
        ),
      );
    }
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Theme(
      data: AppThemes.darkTheme,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + bottomInset + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu<String>(
              controller: sendingCardsController,
              width: MediaQuery.of(context).size.width - 20 * 2,
              leadingIcon: const Icon(Icons.credit_card),
              label: const Text('Sending Card'),
              initialSelection: selectedSendingCard,
              dropdownMenuEntries: cardsEntries,
              onSelected: (String? index) {
                setState(() {
                  selectedSendingCard = index;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownMenu<String>(
              controller: receivingCardsController,
              leadingIcon: const Icon(Icons.credit_card),
              label: const Text('Receiving Card'),
              width: MediaQuery.of(context).size.width - 20 * 2,
              initialSelection: selectedReceivingCard,
              dropdownMenuEntries: cardsEntries,
              onSelected: (String? index) {
                setState(() {
                  selectedReceivingCard = index;
                });
              },
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Amount',
              ),
            ),
            const SizedBox(height: 20),
            PaymentButton(
              enabled: true,
              width: screenSize.width - 20 * 2,
            ),
          ],
        ),
      ),
    );
  }
}
