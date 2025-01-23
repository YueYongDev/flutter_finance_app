import 'package:flutter_finance_app/entity/asset_operation.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';

class AssetOperationRepository {
  final _databaseHelper = DatabaseHelper();

  // Create a new asset operation record
  Future<void> recordAssetOperation(String accountId, String assetId,
      double amount, String description) async {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;

    await _databaseHelper.insertAssetOperation(
      timestamp.toString(),
      accountId,
      assetId,
      amount,
      description,
      timestamp,
      timestamp,
    );
  }

  // Get asset operations for a specific account
  Future<List<AssetOperation>> getAssetOperationsForAccount(String accountId,
      {int? limit}) async {
    final maps = await _databaseHelper.queryAssetOperations(
        accountId: accountId, limit: limit);
    return maps.map((map) => AssetOperation.fromMap(map)).toList();
  }
}
