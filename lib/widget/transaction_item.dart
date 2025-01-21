import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/model/data.dart';

class AssetItem extends StatelessWidget {
  const AssetItem(this.assetItemData, {super.key});

  final AssetItemData assetItemData;

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
              assetItemData.icon,
              width: 50,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assetItemData.title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  assetItemData.date,
                  style: const TextStyle(color: AppColors.onBlack),
                ),
              ],
            ),
          ),
          Text(
            (assetItemData.amount < 0 ? '' : '+') +
                assetItemData.amount.toString(),
            style: TextStyle(
              color: assetItemData.amount < 0
                  ? AppColors.danger
                  : AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
