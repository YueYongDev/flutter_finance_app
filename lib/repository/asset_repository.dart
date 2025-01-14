import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';

class AssetRepository {
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

  Future<List<Asset>> retrieveAssetsByAccountId(String accountId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'asset',
      where: 'accountId = ?',
      whereArgs: [accountId],
    );
    return result.map((map) => Asset.fromMap(map)).toList();
  }
}
