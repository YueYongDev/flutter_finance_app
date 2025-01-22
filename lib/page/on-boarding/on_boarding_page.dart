import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/app_styles.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_finance_app/page/account_page/account_page.dart';
import 'package:flutter_finance_app/widget/wallet.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_finance_app/main.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> rotationAnimation;
  late final PageController pageController;
  static const viewportFraction = 0.7;
  int activeIndex = 0;
  static const double _sizedBoxHeight = 40;
  static const double _walletSideLeftPosition = -210;
  static const double _borderRadius = 25;

  @override
  void initState() {
    pageController = PageController(viewportFraction: viewportFraction);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    rotationAnimation =
        Tween<double>(begin: 0, end: 30 * pi / 180).animate(curvedAnimation);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = screenSize.width * viewportFraction;

    return Theme(
      data: AppThemes.darkTheme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _sizedBoxHeight),
              Center(
                child: Text(
                  FinanceLocales.onboarding_finance_app.tr,
                  style: const TextStyle(fontSize: 35),
                ),
              ),
              const SizedBox(height: _sizedBoxHeight),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      left: _walletSideLeftPosition,
                      width: 250,
                      top: -32,
                      bottom: -32,
                      child: WalletSide(),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTapDown: (_) => animationController.forward(),
                        onTapUp: (_) => animationController.reverse(),
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: onBoardingItems.length,
                          onPageChanged: (int index) {
                            setState(() {
                              activeIndex = index;
                            });
                            animationController.forward().then(
                                  (value) => animationController.reverse(),
                                );
                          },
                          itemBuilder: (context, index) {
                            return AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              scale: index == activeIndex ? 1 : 0.8,
                              curve: Curves.easeOut,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.onBlack,
                                  borderRadius:
                                      BorderRadius.circular(_borderRadius),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      onBoardingItems[index].image,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: -250 + 35,
                      width: 250,
                      top: -30,
                      bottom: -30,
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotationAnimation.value),
                            alignment: Alignment.center,
                            child: const WalletSide(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: (screenSize.width - itemWidth) / 2,
                  right: (screenSize.width - itemWidth) / 2,
                  top: 40,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._buildItemInfo(activeIndex: activeIndex),
                    PageIndicator(
                      length: onBoardingItems.length,
                      activeIndex: activeIndex,
                    ),
                    FilledButton(
                      onPressed: () {
                        GetStorage().write(kFirstLaunchKey, false);
                        Get.offAll(() => AccountPage());
                      },
                      child: Text(
                        FinanceLocales.onboarding_get_started.tr,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItemInfo({int activeIndex = 0}) {
    return [
      Center(
        child: Text(
          onBoardingItems[activeIndex].title.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: Text(
          onBoardingItems[activeIndex].subtitle.tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ];
  }
}

class PageIndicator extends StatelessWidget {
  static const double _borderRadius = 10;

  const PageIndicator({
    super.key,
    this.length = 1,
    this.activeIndex = 0,
    this.activeColor = AppColors.primary,
  });

  final int length;
  final int activeIndex;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.smallest;
            final activeWidth = size.width * 0.5;
            final inActiveWidth =
                (size.width - activeWidth - (2 * length * 2)) / (length - 1);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: index == activeIndex ? 8 : 5,
                    width: index == activeIndex ? activeWidth : inActiveWidth,
                    decoration: BoxDecoration(
                      color: index == activeIndex
                          ? activeColor
                          : AppColors.onBlack,
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
