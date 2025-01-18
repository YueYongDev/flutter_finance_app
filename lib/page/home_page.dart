import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/constants.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/styles.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/widgets/wallet.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_cards_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  final List<TabItem> tabItems = [
    const TabItem(
      title: 'Cards',
      view: CreditCardsPage(),
    ),
    TabItem(view: Container()),
    const TabItem(
      title: 'Notifications',
      view: _NotificationsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(tabItems[currentPageIndex].title),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            left: Constants.appHPadding / 2,
            right: Constants.appHPadding / 2,
            height: 500,
            child: Wallet(
              width: screenSize.width,
              height: 500,
            ),
          ),
          NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            indicatorColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: Image.asset(
                  'assets/icons/cards-active.png',
                  width: 35,
                  height: 35,
                ),
                icon: Image.asset(
                  'assets/icons/cards.png',
                  width: 35,
                  height: 35,
                ),
                label: 'Cards',
              ),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(
                      Constants.walletStrapWidth * 0.6,
                      Constants.walletStrapWidth * 0.6,
                    ),
                  ),
                  onPressed: () {
                    // showModalBottomSheet<void>(
                    //   context: context,
                    //   backgroundColor: AppColors.onBlack,
                    //   elevation: 0,
                    //   useRootNavigator: true,
                    //   isScrollControlled: true,
                    //   showDragHandle: true,
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(25),
                    //       topLeft: Radius.circular(25),
                    //     ),
                    //   ),
                    //   builder: (context) => const PaymentBottomSheet(),
                    // );
                  },
                ),
              ),
              NavigationDestination(
                selectedIcon: Image.asset(
                  'assets/icons/notifications-active.png',
                  width: 30,
                  height: 30,
                ),
                icon: Image.asset(
                  'assets/icons/notifications.png',
                  width: 30,
                  height: 30,
                ),
                label: 'Notifications',
              ),
            ],
          ),
        ],
      ),
      body: tabItems[currentPageIndex].view,
    );
  }
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/empty.png'),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Empty as a wallet after a vacation',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
