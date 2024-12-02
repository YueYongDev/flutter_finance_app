import 'package:flutter_finance_app/entity/assets.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';

class AssetsRepository {
  final dbHelper = DatabaseHelper();

  Future<void> createAsset(Asset asset) async {
    await dbHelper.insertAsset(asset.toMap());
  }

  Future<List<Asset>> retrieveAssets() async {
    final result = await dbHelper.getAssets();
    return result.map((map) => Asset.fromMap(map)).toList();
  }

  Future<void> updateAsset(Asset asset) async {
    if (asset.id != null) {
      await dbHelper.updateAsset(asset.id!, asset.toMap());
    }
  }

  Future<void> deleteAsset(String id) async {
    await dbHelper.deleteAsset(id);
  }
}
