import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/styles.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(this.transaction, {super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              transaction.icon,
              width: 60,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  transaction.date,
                  style: const TextStyle(color: AppColors.onBlack),
                ),
              ],
            ),
          ),
          Text(
            (transaction.amount < 0 ? '' : '+') + transaction.amount.toString(),
            style: TextStyle(
              color:
                  transaction.amount < 0 ? AppColors.danger : AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
