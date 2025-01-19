import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/data.dart';
import 'package:flutter_finance_app/page/credit_card_page/core/utils.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_card.dart';
import 'package:flutter_finance_app/page/credit_card_page/credit_card_page.dart';
import 'package:flutter_finance_app/widget/credit_cards_stack.dart';

const dragSnapDuration = Duration(milliseconds: 200);
const pageTransitionDuration = Duration(milliseconds: 800);
const dragThreshold = Offset(70, 70);
const minCardScale = 0.6;
const maxCardScale = 1.0;
const cardsOffset = 12.0;
const minThrowDistance = 300.0;

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({
    super.key,
    this.onCardPagePush,
    this.onCardPagePop,
  });

  final VoidCallback? onCardPagePush;
  final VoidCallback? onCardPagePop;

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  int activeCard = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.width * 0.75;
    final cardWidth = cardHeight * creditCardAspectRatio;

    return Center(
      child: SizedBox(
        width: cardHeight,
        height: cardWidth + (cardsOffset * (cards.length - 1)),
        child: CreditCardsStack(
          itemCount: cards.length,
          initialActiveCard: activeCard,
          onCardTap: (index) {
            pushFadeInRoute(
              context,
              pageBuilder: (context, animation, __) => CreditCardPage(
                initialIndex: index,
                pageTransitionAnimation: animation,
              ),
            ).then((value) {
              if (value != null && value is int) {
                setState(() {
                  activeCard = value;
                });
              }
            });
          },
          itemBuilder: (context, index) {
            return Align(
              widthFactor: cardHeight / cardWidth,
              heightFactor: cardWidth / cardHeight,
              child: Hero(
                tag: 'card_${cards[index].id}',
                flightShuttleBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  _,
                  __,
                  ___,
                ) {
                  final rotationAnimation =
                      Tween<double>(begin: -pi / 2, end: pi).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  );

                  final flipAnimation =
                      Tween<double>(begin: 0, end: pi).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0.3,
                        1,
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
                            ..rotateX(flipAnimation.value),
                          alignment: Alignment.center,
                          child: Transform.flip(
                            flipX: animation.value > 0.5,
                            child: CreditCard(
                              width: cardWidth,
                              data: cards[index],
                              isFront: animation.value > 0.5,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: CreditCard(
                    width: cardWidth,
                    data: cards[index],
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

Future<dynamic> pushFadeInRoute(
  BuildContext context, {
  required RoutePageBuilder pageBuilder,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: pageBuilder,
      transitionDuration: pageTransitionDuration,
      reverseTransitionDuration: pageTransitionDuration,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        _,
        Widget child,
      ) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    ),
  );
}
