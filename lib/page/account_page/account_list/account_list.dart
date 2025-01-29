import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/helper/common_helper.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/widget/account_card.dart';
import 'package:flutter_finance_app/widget/account_card_small.dart';
import 'package:flutter_finance_app/widget/no_account_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'account_list_logic.dart';

class AccountListWidget extends StatelessWidget {
  final logic = Get.put(AccountListLogic());

  AccountListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
          bottom: true,
          top: false,
          child: GetBuilder<AccountPageLogic>(builder: (controller) {
            if (controller.state.accounts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: NoAccountCard(),
              );
            }
            return MediaQuery.removePadding(
              removeTop: true,
              removeBottom: true,
              context: context,
              child: _buildAccountCardGrid(),
            );
          })),
    );
  }

  Widget _buildAccountCardList() {
    final screenSize = MediaQuery.of(Get.context!).size;
    final cardHeight = screenSize.width * 0.75;
    final cardWidth = cardHeight * accountCardAspectRatio;
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
                            child: AccountCard(
                              width: cardWidth,
                              data: generateAccountCardData(accounts)[index],
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
                                        child: AccountCard(
                                          width: cardWidth,
                                          data: generateAccountCardData(
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

  Widget _buildAccountCardGrid() {
    final screenSize = MediaQuery.of(Get.context!).size;
    final cardHeight = screenSize.width * 0.75;
    final cardWidth = cardHeight * accountCardSmallAspectRatio;
    return SingleChildScrollView(
      child: GetBuilder<AccountPageLogic>(
        builder: (controller) {
          List<Account> accounts = controller.state.accounts;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 20.h,
                childAspectRatio:
                    cardWidth / 300.h, // Adjust the aspect ratio as needed
              ),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                Account account = accounts[index];
                return GestureDetector(
                  onTap: () {
                    debugPrint(
                        'onTap|Account: ${account.name}, index: $index,Assets: ${account.assets.length}');
                    toAccountDetailPage(account, index);
                  },
                  child: Hero(
                    tag: 'card_${accounts[index].id}',
                    child: AccountCardSmall(
                      width: cardWidth,
                      data: generateAccountCardData(accounts)[index],
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
                                child: AccountCardSmall(
                                  width: cardWidth,
                                  data:
                                      generateAccountCardData(accounts)[index],
                                  isFront: true,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  toAccountDetailPage(Account account, int index) {
    pushFadeInRoute(
      Get.context!,
      pageBuilder: (context, animation, __) => AccountDetailPage(
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
