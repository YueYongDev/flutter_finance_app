import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/page/on-boarding/on_boarding_page.dart';
import 'package:get/get.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_trend_page/account_trend_page.dart';
import 'package:flutter_finance_app/widget/transaction_item.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/widget/account_card.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_finance_app/page/account_detail_page/account_detail_page_logic.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';

class AccountDetailPage extends StatelessWidget {
  final int initialIndex;
  final Animation<double> pageTransitionAnimation;

  const AccountDetailPage({
    required this.initialIndex,
    required this.pageTransitionAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AccountPageState accountPageState = Get.find<AccountPageLogic>().state;

    final AccountDetailController controller =
        Get.put(AccountDetailController(initialIndex));

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: pageTransitionAnimation,
        curve: Curves.easeOut,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: Obx(() => Text(
              accountPageState.accounts[controller.activeIndex.value].name,
              style: const TextStyle(color: Colors.white),
            )),
        leading: IconButton(
          onPressed: () {
            Get.delete<AccountDetailController>();
            Navigator.of(context).pop(controller.activeIndex.value);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                _buildCardsPageView(),
                SlideTransition(
                  position: slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Obx(() => PageIndicator(
                              length: controller.cards.length,
                              activeIndex: controller.activeIndex.value,
                              activeColor: controller
                                  .cards[controller.activeIndex.value]
                                  .style
                                  .color,
                            )),
                        Obx(() => _buildButtons(accountPageState
                            .accounts[controller.activeIndex.value])),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SlideTransition(
                position: slideAnimation,
                child: GetBuilder<AccountDetailController>(
                  builder: (controller) {
                    return _buildLatestTransactionsSection(
                      accountPageState.accounts[controller.activeIndex.value],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Account account =
              accountPageState.accounts[controller.activeIndex.value];
          if (account != null) {
            Get.to(() => AccountTrendPage(account: account));
          } else {
            // Handle the case where account is null
            Get.snackbar("Error", "No account selected");
          }
        },
        child: Icon(Icons.trending_up),
      ),
    );
  }

  Widget _buildCardsPageView() {
    final screenSize = MediaQuery.of(Get.context!).size;
    final cardWidth = screenSize.width - AccountCardConstants.appHPadding * 2;
    AccountPageState accountPageState = Get.find<AccountPageLogic>().state;

    return GetBuilder<AccountDetailController>(builder: (controller) {
      return SizedBox(
        height: cardWidth / creditCardAspectRatio,
        child: PageView.builder(
          controller: controller.pageController,
          itemCount: accountPageState.accounts.length,
          onPageChanged: (index) => controller.setActiveIndex(index),
          itemBuilder: (context, index) {
            return AnimatedScale(
              scale: index == controller.activeIndex.value ? 1 : 0.85,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: HeroMode(
                enabled: index == controller.activeIndex.value,
                child: Hero(
                  tag: 'card_${accountPageState.accounts[index].id}',
                  child: AccountCard(
                    width: cardWidth,
                    data: controller.cards[index],
                    isFront: true,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildButtons(Account account) {
    return Row(
      children: [
        Expanded(
          child: _Button(
            label: FinanceLocales.l_edit_account.tr,
            icon: Icons.edit,
            onTap: () {
              showCupertinoModalBottomSheet(
                context: Get.context!,
                builder: (context) => EditAccountPage(account: account),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Button(
            label: FinanceLocales.l_add_asset.tr,
            icon: Icons.add,
            onTap: () async {
              // Open asset edit page (add new asset)
              await showCupertinoModalBottomSheet(
                expand: true,
                context: Get.context!,
                enableDrag: false,
                builder: (context) => EditAssetPage(account: account),
              );
              // Clear input fields after modal is closed
              final assetController = Get.find<AssetController>();
              assetController.clearInputFields();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestTransactionsSection(Account account) {
    AccountDetailController controller = Get.find<AccountDetailController>();

    List<Asset> assets = account.assets;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          FinanceLocales.l_asset_list.tr,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        ...List.generate(
          assets.length,
          (index) => GestureDetector(
            child: AssetItem(
              controller.generateAssetItemDataList(assets)[index],
            ),
            onTap: () async {
              await showCupertinoModalBottomSheet(
                expand: true,
                context: Get.context!,
                enableDrag: false,
                builder: (context) =>
                    EditAssetPage(account: account, asset: assets[index]),
              );
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.onBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
