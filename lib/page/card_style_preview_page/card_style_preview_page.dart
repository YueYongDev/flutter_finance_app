import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page_logic.dart';
import 'package:flutter_finance_app/util/common_utils.dart';
import 'package:flutter_finance_app/widget/account_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CardStylePreviewPage extends StatelessWidget {
  final AccountController accountController = Get.find<AccountController>();

  CardStylePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          FinanceLocales.title_card_style_preview.tr,
          style: TextStyle(color: CupertinoColors.label, fontSize: 14.sp),
        ),
      ),
      body: GetBuilder<AccountController>(builder: (controller) {
        AccountCardData previewAccountData = AccountCardData(
          id: "xxxx-sasd-aasd-1234",
          name: 'Central Bank',
          type: CreditCardType.visa,
          balance: "¥ 1234.56",
          style: getCardStyleByName(controller.selectedAccountCardStyle) ??
              AccountCardStyle.primary,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: AccountCard(
                  width: 0.9.sw,
                  data: previewAccountData,
                  isFront: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: AccountCardStyle.values.length,
                itemBuilder: (context, index) {
                  final style = AccountCardStyle.values[index];
                  return RadioListTile<String>(
                    title: Text(style.displayName),
                    value: style.name,
                    groupValue: controller.selectedAccountCardStyle,
                    onChanged: (value) {
                      controller.selectedAccountCardStyle = value!;
                      controller.update();
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
