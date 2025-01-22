import 'package:flutter/material.dart';

class AccountCardConstants {
  static const double appHPadding = 16;
  static const double walletStrapWidth = 85;
  static const double walletStrapHeight = 100;
  static const double perspectiveSm = 0.0005;
  static const double perspective = 0.001;
  static const double perspectiveLg = 0.002;
  static const dragSnapDuration = Duration(milliseconds: 200);
  static const pageTransitionDuration = Duration(milliseconds: 800);
  static var dragThreshold = const Offset(70, 70);
  static const minCardScale = 0.6;
  static const maxCardScale = 1.0;
  static const cardsOffset = 12.0;
  static const minThrowDistance = 300.0;
  static const defaultAssetIconBasePath = 'assets/icons/choose_asset_icon';
  static const defaultAssetIcon =
      '$defaultAssetIconBasePath/asset-default-icon.png';
}
