import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';

Future<dynamic> pushFadeInRoute(
  BuildContext context, {
  required RoutePageBuilder pageBuilder,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: pageBuilder,
      transitionDuration: AccountCardConstants.pageTransitionDuration,
      reverseTransitionDuration: AccountCardConstants.pageTransitionDuration,
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
