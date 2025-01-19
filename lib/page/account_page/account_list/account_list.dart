import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_card.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_card_page.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_cards_page.dart';
import 'package:flutter_finance_app/widget/no_account_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'account_list_logic.dart';

class AccountListWidget extends StatelessWidget {
  final logic = Get.put(AccountListLogic());

  AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return SliverToBoxAdapter(
      child: SafeArea(
          bottom: true,
          top: false,
          child: GetBuilder<AccountPageLogic>(builder: (controller) {
            if (controller.cardDataList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: NoAccountCard(),
              );
            }
            return _buildAccountCardList();
          })),
    );
  }

  Widget _buildAccountCardList() {
    final screenSize = MediaQuery.of(Get.context!).size;
    final cardHeight = screenSize.width * 0.75;
    final cardWidth = cardHeight * creditCardAspectRatio;
    return GetBuilder<AccountPageLogic>(
      builder: (controller) {
        List<Account> accounts = controller.state.accounts;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Stack(children: <Widget>[
              for (int index = 0; index < accounts.length; index++)
                GestureDetector(
                  onTap: () {
                    Account account = accounts[index];
                    debugPrint(
                        'onTap|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
                    toAccountDetailPage(account, index);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: index * 70.sp),
                    child: SizedBox(
                      height: 220.h,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Hero(
                            tag: 'card_${accounts[index].id}',
                            child: CreditCard(
                              width: cardWidth,
                              data: generateCreditCardData(accounts)[index],
                              isFront: true,
                            ),
                            flightShuttleBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              _,
                              __,
                              ___,
                            ) {
                              final rotationAnimation =
                                  Tween<double>(begin: -pi, end: pi).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              );

                              final flipAnimation =
                                  Tween<double>(begin: pi, end: pi).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(
                                    0.3,
                                    0.5,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              );

                              return Material(
                                color: Colors.transparent,
                                child: AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) {
                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateZ(rotationAnimation.value)
                                        ..rotateX(-flipAnimation.value),
                                      alignment: Alignment.center,
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(pi),
                                        child: CreditCard(
                                          width: cardWidth,
                                          data: generateCreditCardData(
                                              accounts)[index],
                                          isFront: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ]),
          ),
        );
      },
    );
  }

  toAccountDetailPage(Account account, int index) {
    pushFadeInRoute(
      Get.context!,
      pageBuilder: (context, animation, __) => CreditCardPage(
        initialIndex: index,
        pageTransitionAnimation: animation,
      ),
    ).then((value) {
      if (value != null && value is int) {
        debugPrint("toAccountDetailPage return:$value");
      }
    });
  }
}
