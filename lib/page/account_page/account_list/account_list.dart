import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/colors.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/enum/font_family.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_finance_app/widget/custom_text_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'account_list_logic.dart';

class AccountListWidget extends StatelessWidget {
  final logic = Get.put(AccountListLogic());

  AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return SliverToBoxAdapter(
      child: SafeArea(bottom: true, top: false, child: _buildAccountCardList()),
    );
  }

  Widget _buildAccountCardList() {
    return GetBuilder<AccountPageLogic>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Stack(
              children: controller.cardDataList
                  .mapIndexed((index, item) => GestureDetector(
                        onTap: () {
                          Account account = controller.state.accounts[index];
                          debugPrint(
                              'onTap|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
                          toAccountDetailPage(account);
                        },
                        onLongPress: () {
                          Account account = controller.state.accounts[index];
                          debugPrint(
                              'onLongPress|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
                          showCupertinoModalBottomSheet(
                            context: Get.context!,
                            builder: (context) =>
                                EditAccountPage(account: account),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: index * 70.sp),
                          child: SizedBox(
                              height: 220.h,
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Image.asset(
                                    "assets/images/img_card.png",
                                    fit: BoxFit.fill,
                                    color: item.cardBGColor,
                                    width: double.infinity,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 4.sp,
                                          width: 30.sp,
                                          decoration: BoxDecoration(
                                              color: item.cardBGColor,
                                              borderRadius:
                                                  BorderRadius.circular(2.sp)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text: item.title ?? '',
                                                    textSize: 12.sp,
                                                    fontFamily: FontFamily
                                                        .oswaldSemiBold,
                                                    color: MyAppColors
                                                        .primaryWhiteColor,
                                                  ),
                                                  if (item.title !=
                                                      "My Profile") ...[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      child: Container(
                                                        height: 10.sp,
                                                        width: 1.5.sp,
                                                        decoration: BoxDecoration(
                                                            color: MyAppColors
                                                                .primaryWhiteColor
                                                                .withOpacity(
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        1.sp)),
                                                      ),
                                                    ),
                                                    CustomText(
                                                      text: 'CREDIT',
                                                      textSize: 12.sp,
                                                      fontFamily: FontFamily
                                                          .oswaldSemiBold,
                                                      color: MyAppColors
                                                          .primaryWhiteColor,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              if (item.title == "My Profile")
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        CustomText(
                                                            text: "Welcome",
                                                            textSize: 10.sp,
                                                            fontFamily: FontFamily
                                                                .robotoRegular,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: MyAppColors
                                                                .primaryWhiteColor),
                                                        CustomText(
                                                          text: "Dedo Ray",
                                                          textSize: 14.sp,
                                                          fontFamily: FontFamily
                                                              .robotoBold,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: MyAppColors
                                                              .primaryWhiteColor,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Image.asset(
                                                      item.cardIcon ?? '',
                                                      height: 40.sp,
                                                      width: 40.sp,
                                                    )
                                                  ],
                                                )
                                              else if (item.title == "ONE CARD")
                                                Image.asset(
                                                  item.cardIcon ?? '',
                                                  height: 18.sp,
                                                  width: 40.sp,
                                                )
                                              else
                                                Image.asset(
                                                  item.cardIcon ?? '',
                                                  height: 17.h,
                                                  width: 70.w,
                                                )
                                            ],
                                          ),
                                        ),
                                        if (index + 1 ==
                                            controller.cardDataList.length) ...[
                                          const Expanded(child: Center()),
                                          Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  bottom: 20.sp),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                      text: "${item.content}",
                                                      textSize: 22.sp,
                                                      fontFamily: FontFamily
                                                          .oswaldSemiBold,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: MyAppColors
                                                          .primaryWhiteColor),
                                                  CustomText(
                                                      text: "${item.id}",
                                                      textSize: 15.sp,
                                                      fontFamily: FontFamily
                                                          .oswaldSemiBold,
                                                      color: MyAppColors
                                                          .primaryLightGreenColor),
                                                ],
                                              )),
                                        ]
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  toAccountDetailPage(Account account) {
    Navigator.push(
      Get.context!,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AccountDetailsPage(account: account),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var scaleTween =
              Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: Curves.ease));
          var fadeTween =
              Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));

          var scaleAnimation = animation.drive(scaleTween);
          var fadeAnimation = animation.drive(fadeTween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
