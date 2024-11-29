import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

CupertinoSliverNavigationBar buildNavigationBar() {
  return CupertinoSliverNavigationBar(
    largeTitle: const Text('Account'),
    backgroundColor: Colors.white,
    leading: buildLeadingMenu(),
    trailing: buildTrailingMenu(),
  );
}

Row buildLeadingMenu() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      PullDownButton(
        itemBuilder: (context) => buildLeadingMenuItems(),
        buttonBuilder: (context, showMenu) =>
            buildMenuButton(showMenu, icon: CupertinoIcons.ellipsis_circle),
      ),
    ],
  );
}

Row buildTrailingMenu() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CupertinoButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        child: Icon(
          CupertinoIcons.arrow_2_circlepath,
          size: 28,
        ),
      ),
      const SizedBox(width: 8),
      PullDownButton(
        itemBuilder: (context) => buildSortMenuItems(),
        buttonBuilder: (context, showMenu) =>
            buildMenuButton(showMenu, icon: CupertinoIcons.sort_down),
      ),
      PullDownButton(
        itemBuilder: (context) => buildAddMenuItems(),
        buttonBuilder: (context, showMenu) =>
            buildMenuButton(showMenu, icon: CupertinoIcons.add),
      ),
      const SizedBox(width: 10),
    ],
  );
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

List<PullDownMenuEntry> buildAddMenuItems() {
  return [
    PullDownMenuItem(
      onTap: () {},
      title: 'Add Account',
      icon: CupertinoIcons.rectangle_stack_badge_plus,
    ),
    PullDownMenuItem(
      title: 'Add Assets',
      subtitle: 'Share in different channel',
      onTap: () {},
      icon: CupertinoIcons.bag_badge_plus,
    ),
    const PullDownMenuDivider.large(),
    PullDownMenuItem(
      onTap: () {},
      title: 'Transfer',
      icon: CupertinoIcons.arrow_right_arrow_left_square,
    ),
  ];
}

List<PullDownMenuEntry> buildLeadingMenuItems() {
  return [
    PullDownMenuItem(
      onTap: () {},
      title: 'OpenAI',
      icon: CupertinoIcons.lock_open,
    ),
    PullDownMenuItem(
      title: 'App Settings',
      onTap: () {},
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
