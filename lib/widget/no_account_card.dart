import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NoAccountCard extends StatelessWidget {
  const NoAccountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFFF7F6FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 220.h,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg_ticket_card.png"),
                    fit: BoxFit.cover)),
            child: Container(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FinanceLocales.home_title_welcome.tr,
                  style: TextStyle(
                    color: AppColors.onBlack,
                    fontSize: 22.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: -0.96,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  FinanceLocales.home_subtitle_welcome.tr,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.64,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                color: index == 4
                                    ? const Color(0xFFE2DEE9)
                                    : const Color(0xFFF5BE2E),
                              )),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          context: context,
                          enableDrag: false,
                          builder: (context) => EditAccountPage(
                            account: null,
                          ),
                        );
                      },
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      borderRadius: BorderRadius.circular(4),
                      child: const Text(
                        'Add Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    // const Icon(
                    //   Icons.bookmark_border,
                    //   color: Colors.black,
                    //   size: 24,
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
