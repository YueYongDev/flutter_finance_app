import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page_logic.dart';
import 'package:get/get.dart';

class AccountDetailController extends GetxController {
  AccountPageState accountPageState = Get.find<AccountPageLogic>().state;

  // 检查是否已经注册了 AccountDetailController
  final editAccountController = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : null;

  var activeIndex = 0.obs;
  late PageController pageController;

  List<AccountCardData> cards = [];
  List<AssetItemData> assetItemData = [];

  AccountDetailController(int initialIndex) {
    activeIndex.value = initialIndex;
    pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void onInit() {
    super.onInit();
    cards = generateAccountCardData(accountPageState.accounts);
  }

  @override
  void onClose() {
    pageController.dispose();
    if (editAccountController != null) {
      editAccountController!.clearInputFields();
    }

    super.onClose();
  }

  refreshCardData() {
    cards.clear();
    cards.addAll(generateAccountCardData(accountPageState.accounts));
    update();
  }

  void setActiveIndex(int index) {
    activeIndex.value = index;
    update();
  }

  List<AssetItemData> generateAssetItemDataList(List<Asset> assets) {
    return assets.map((asset) {
      return AssetItemData(
          title: asset.name,
          date:
              DateUtil.formatDateMs(asset.createdAt, format: DateFormats.full),
          amount: asset.amount,
          icon: 'assets/icons/twitter.png');
    }).toList();
  }
}
