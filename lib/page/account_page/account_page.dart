import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/colors.dart';
import 'package:flutter_finance_app/navigation_bar.dart';
import 'package:flutter_finance_app/page/account_page/account_list/account_list.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/net_assets_section/net_assets_section.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  final logic = Get.put(AccountPageLogic());

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          buildNavigationBar(),
          // buildNetAssetsSection(context),
          topPanel(size),
          const NetAssetsSection(),
          AccountListWidget(),
        ],
      ),
    );
  }

  Widget topPanel(Size size) {
    return GetBuilder<AccountPageLogic>(builder: (logic) {
      return SliverToBoxAdapter(
        child: Container(
          width: size.width,
          height: size.height * .32,
          decoration: const BoxDecoration(
              color: AppColors.blueSecondary,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "¥${logic.state.netAssets}",
                    style: const TextStyle(
                        color: AppTextColors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("+\$9,736",
                            style: TextStyle(
                                color: AppTextColors.white, fontSize: 18)),
                        SizedBox(
                          width: size.width * .05,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_sharp,
                              color: AppTextColors.green,
                            ),
                            Text(
                              "2.3%",
                              style: TextStyle(
                                  color: AppTextColors.green, fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "ACCOUNT BALANCE",
                    style: TextStyle(color: AppTextColors.white54),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  panelBottomBlock("${logic.state.totalDebt}", "负债"),
                  Container(
                    height: 50,
                    width: 1,
                    color: AppTextColors.white54,
                  ),
                  panelBottomBlock("${logic.state.totalAssets}", "资产"),
                  Container(
                    height: 50,
                    width: 1,
                    color: AppTextColors.white54,
                  ),
                  panelBottomBlock("${logic.state.accounts.length}", "账户"),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Column panelBottomBlock(
    String title,
    String subTitle,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(title,
              style: const TextStyle(
                  color: AppTextColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        Text(subTitle,
            style: const TextStyle(color: AppTextColors.white54, fontSize: 13))
      ],
    );
  }
}
