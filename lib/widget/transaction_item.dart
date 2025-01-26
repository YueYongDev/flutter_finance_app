import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.all(13.sp),
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              assetItemData.icon,
              width: 44,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(width: 12.sp),
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
