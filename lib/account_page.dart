import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class AccountPage extends StatelessWidget {
  final List<Map<String, dynamic>> accounts = List.generate(
    20,
    (index) => {
      'name': '账户 ${index + 1}',
      'count': index + 1,
      'color': Colors.primaries[index % Colors.primaries.length],
    },
  );

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
              largeTitle: Text('Account'),
              backgroundColor: Colors.white,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PullDownButton(
                    itemBuilder: (context) => [
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
                    ],
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.add,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        onTap: () {},
                        title: 'OpenAI',
                        icon: CupertinoIcons.lock_open,
                      ),
                      PullDownMenuItem(
                        title: 'App Settings',
                        // subtitle: 'Share in different channel',
                        onTap: () {},
                        icon: CupertinoIcons.settings,
                      ),
                    ],
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.ellipsis_circle,
                      ),
                    ),
                  ),
                ],
              )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Assets (CNY)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    const SizedBox(height: 10),
                    Text('300,782.45',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    const SizedBox(height: 10),
                    Text('Total Assets: 334,629.24'),
                    Text('Total Debt: -33,846.79'),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= accounts.length) return null;
                  final account = accounts[index];
                  return _buildAccountTile(
                      account['name'], account['count'], account['color']);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Add Account'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Add Asset'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Import from Screenshot'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Transfer'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildAccountTile(String name, int count, Color color) {
    return ListTile(
      title: Text(name),
      trailing: Text(count.toString()),
      tileColor: color.withOpacity(0.1),
      onTap: () {
        // Handle tap event, e.g., navigate to a detailed view
      },
    );
  }
}
