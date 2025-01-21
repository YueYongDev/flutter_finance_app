import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page.dart';
import 'package:flutter_finance_app/page/settings_page/settings_page.dart';
import 'package:flutter_finance_app/page/transfer_page/transfer_page.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';

CupertinoSliverNavigationBar buildNavigationBar() {
  return CupertinoSliverNavigationBar(
    largeTitle: Text(
      FinanceLocales.home_title.tr,
      style: const TextStyle(color: Colors.white, fontSize: 22),
    ),
    stretch: true,
    backgroundColor: AppColors.blueSecondary,
    leading: buildLeadingMenu(),
    trailing: buildTrailingMenu(),
  );
}

Widget buildLeadingMenu() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      PullDownButton(
        itemBuilder: (context) => buildLeadingMenuItems(context),
        buttonBuilder: (context, showMenu) =>
            buildMenuButton(showMenu, icon: CupertinoIcons.ellipsis_circle),
      ),
    ],
  );
}

Widget buildTrailingMenu() {
  return GetBuilder<AccountPageLogic>(builder: (controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.animationController.value * 2.0 * math.pi,
              child: child,
            );
          },
          child: CupertinoButton(
            onPressed: () =>
                controller.fetchData(), // Trigger fetchData on press
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.arrow_2_circlepath,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // PullDownButton(
        //   itemBuilder: (context) => buildSortMenuItems(),
        //   buttonBuilder: (context, showMenu) =>
        //       buildMenuButton(showMenu, icon: CupertinoIcons.sort_down),
        // ),
        PullDownButton(
          itemBuilder: (context) => buildAddMenuItems(context),
          buttonBuilder: (context, showMenu) =>
              buildMenuButton(showMenu, icon: CupertinoIcons.add),
        ),
        const SizedBox(width: 10),
      ],
    );
  });
}

List<PullDownMenuEntry> buildSortMenuItems() {
  return [
    PullDownMenuItem(
      onTap: () {},
      title: 'Expand All Account',
      icon: CupertinoIcons.arrow_up_left_arrow_down_right,
    ),
    PullDownMenuItem(
      title: 'Collapse All Account',
      onTap: () {},
      icon: CupertinoIcons.arrow_down_right_arrow_up_left,
    ),
    const PullDownMenuDivider.large(),
    PullDownMenuItem(
      onTap: () {},
      title: 'Sort By',
    ),
    PullDownMenuActionsRow.medium(
      items: [
        PullDownMenuItem(
          onTap: () {},
          title: 'Time',
          icon: CupertinoIcons.time,
        ),
        PullDownMenuItem(
          onTap: () {},
          title: 'Assets',
          icon: CupertinoIcons.money_dollar_circle,
        ),
        PullDownMenuItem(
          onTap: () {},
          title: 'Lable',
          icon: CupertinoIcons.tag,
        ),
      ],
    ),
  ];
}

List<PullDownMenuEntry> buildAddMenuItems(BuildContext context) {
  return [
    PullDownMenuItem(
      onTap: () {
        showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          enableDrag: false,
          builder: (context) => EditAccountPage(
            account: null,
          ),
        );
      },
      title: FinanceLocales.item_add_account.tr,
      icon: CupertinoIcons.rectangle_stack_badge_plus,
    ),
    PullDownMenuItem(
      title: FinanceLocales.item_add_assets.tr,
      onTap: () {
        showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          enableDrag: false,
          builder: (context) => EditAssetPage(
            account: null,
            asset: null,
          ),
        );
      },
      icon: CupertinoIcons.bag_badge_plus,
    ),
    const PullDownMenuDivider.large(),
    PullDownMenuItem(
      onTap: () {
        showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          enableDrag: false,
          builder: (context) => TransferPage(),
        );
      },
      title: FinanceLocales.item_transfer.tr,
      icon: CupertinoIcons.arrow_right_arrow_left_square,
    ),
    const PullDownMenuDivider.large(),
    if (kDebugMode)
      PullDownMenuItem(
        title: "insert history mock data",
        onTap: () {
          BalanceHistoryRepository().insertMockData();
        },
        icon: CupertinoIcons.bag_badge_plus,
      ),
    if (kDebugMode)
      PullDownMenuItem(
        title: "delete history mock data",
        onTap: () {
          BalanceHistoryRepository().cleanupMockData();
        },
        icon: CupertinoIcons.bag_badge_plus,
      ),
  ];
}

List<PullDownMenuEntry> buildLeadingMenuItems(BuildContext context) {
  return [
    PullDownMenuItem(
      onTap: () {},
      title: 'OpenAI',
      icon: CupertinoIcons.lock_open,
    ),
    PullDownMenuItem(
      title: FinanceLocales.item_app_setting.tr,
      onTap: () async {
        await showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          enableDrag: false,
          builder: (context) => SettingsPage(),
        );
      },
      icon: CupertinoIcons.settings,
    ),
  ];
}

Widget buildMenuButton(VoidCallback showMenu, {required IconData icon}) {
  return CupertinoButton(
    onPressed: showMenu,
    padding: EdgeInsets.zero,
    child: Icon(
      icon,
      size: 24,
      color: Colors.white,
    ),
  );
}
