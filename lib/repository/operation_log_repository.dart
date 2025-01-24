import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/enum/operation_log_enum.dart';
import 'package:flutter_finance_app/util/common_utils.dart';

import '../entity/operation_log.dart';
import 'database_helper.dart';

class OperationLogRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> recordAccountCreate(Account account) async {
    final log = OperationLog(
      id: generateShortId(),
      accouId: account.id!,
      operationType: OperationLogTypeEnum.ADD_ACCOUNT.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.NAME.name,
      value: account.name,
    );
    await create(log);
  }

  Future<void> recordAccountUpdate(Account account) async {
    final log = OperationLog(
      id: generateShortId(),
      accouId: account.id!,
      operationType: OperationLogTypeEnum.UPDATE_ACCOUNT.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.NAME.name,
      value: account.name,
    );
    await create(log);
  }

  Future<void> recordAccountDelete(Account account) async {
    final log = OperationLog(
      id: generateShortId(),
      accouId: account.id!,
      operationType: OperationLogTypeEnum.DELETE_ACCOUNT.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.NAME.name,
      value: account.name,
    );
    await create(log);
  }

  Future<void> recordAssetCreate(Asset asset) async {
    final log1 = OperationLog(
      id: generateShortId(),
      accouId: asset.accountId,
      assetId: asset.id!,
      operationType: OperationLogTypeEnum.ADD_ASSET.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.NAME.name,
      value: asset.name,
    );
    final log2 = OperationLog(
      id: generateShortId(),
      accouId: asset.accountId,
      assetId: asset.id!,
      operationType: OperationLogTypeEnum.UPDATE_ACCOUNT.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.AMOUNT.name,
      value: asset.amount.toString(),
    );
    await create(log1);
    await create(log2);
  }

  Future<void> recordAssetUpdate(Asset asset) async {
    final log = OperationLog(
      id: generateShortId(),
      accouId: asset.accountId,
      assetId: asset.id!,
      operationType: OperationLogTypeEnum.UPDATE_ASSET.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.AMOUNT.name,
      value: asset.amount.toString(),
    );
    await create(log);
  }

  Future<void> recordAssetDelete(Asset asset) async {
    final log = OperationLog(
      id: generateShortId(),
      accouId: asset.accountId,
      assetId: asset.id!,
      operationType: OperationLogTypeEnum.DELETE_ASSET.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      key: OperationLogKeyEnum.NAME.name,
      value: asset.name,
    );
    await create(log);
  }

  Future<void> create(OperationLog log) async {
    await _dbHelper.insertOperationLog(log.toMap());
  }

  Future<List<OperationLog>> getAll({int? limit}) async {
    final maps = await _dbHelper.getOperationLogs(limit: limit);
    return maps.map((map) => OperationLog.fromMap(map)).toList();
  }

  Future<List<OperationLog>> getByAccount(String accouId, {int? limit}) async {
    final maps =
        await _dbHelper.getOperationLogsByAccount(accouId, limit: limit);
    return maps.map((map) => OperationLog.fromMap(map)).toList();
  }

  Future<void> update(OperationLog log) async {
    await _dbHelper.updateOperationLog(log.id, log.toMap());
  }

  Future<void> delete(String id) async {
    await _dbHelper.deleteOperationLog(id);
  }
}
