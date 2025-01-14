import 'package:flutter_finance_app/entity/asset.dart';
import 'package:get/get.dart';

class AccountDetailLogic extends GetxController {
  var assets = <Asset>[].obs;

  void updateAssets(List<Asset> newAssets) {
    assets.assignAll(newAssets);
  }
}
