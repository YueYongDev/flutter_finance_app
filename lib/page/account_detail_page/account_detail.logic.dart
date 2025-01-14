import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:get/get.dart';

class AccountDetailLogic extends GetxController {
  var assets = <Asset>[].obs;

  refreshAccountAndAssets(String accountId) async {
    // Fetch account and assets from database
    final assetRepository = AssetRepository();
    List<Asset> newAssets =
        await assetRepository.retrieveAssetsByAccountId(accountId);
    updateAssets(newAssets);
    update();
  }

  void updateAssets(List<Asset> newAssets) {
    assets.assignAll(newAssets);
  }
}
