import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page.dart';
import 'package:flutter_finance_app/page/settings_page/settings_page.dart';
import 'package:flutter_finance_app/page/transfer_page/transfer_page.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';

CupertinoSliverNavigationBar buildNavigationBar() {
  return CupertinoSliverNavigationBar(
    largeTitle: const Text('Account'),
    backgroundColor: Colors.white,
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
              size: 28,
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
          builder: (context) => EditAccountPage(account: null,),
        );
      },
      title: 'Add Account',
      icon: CupertinoIcons.rectangle_stack_badge_plus,
    ),
    PullDownMenuItem(
      title: 'Add Assets',
      subtitle: 'Share in different channel',
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
      title: 'Transfer',
      icon: CupertinoIcons.arrow_right_arrow_left_square,
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
      title: 'App Settings',
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
    child: Icon(icon),
  );
}
