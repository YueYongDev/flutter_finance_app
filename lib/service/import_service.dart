import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter_finance_app/entity/account.dart'; // Added import for Account model
import 'package:flutter_finance_app/entity/asset.dart'; // Added import for Asset model
import 'package:flutter_finance_app/entity/balance_history.dart'; // Added import for BalanceHistory model
import 'package:flutter_finance_app/entity/operation_log.dart'; // Added import for OperationLog model
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:flutter_finance_app/repository/operation_log_repository.dart';
import 'package:path/path.dart' as path;

class ImportService {
  final AccountRepository _accountRepository = AccountRepository();
  final AssetRepository _assetRepository = AssetRepository();
  final BalanceHistoryRepository _balanceHistoryRepository =
      BalanceHistoryRepository();
  final OperationLogRepository _operationLogRepository =
      OperationLogRepository();

  Future<void> importData(File zipFile) async {
    // Extract the ZIP archive
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Define directories within the ZIP file
    final accountDir = Directory(path.join(zipFile.parent.path, 'account'));
    final assetDir = Directory(path.join(zipFile.parent.path, 'asset'));
    final balanceHistoryDir =
        Directory(path.join(zipFile.parent.path, 'balance_history'));
    final operationLogDir =
        Directory(path.join(zipFile.parent.path, 'operation_log'));

    // Ensure directories exist
    await accountDir.create(recursive: true);
    await assetDir.create(recursive: true);
    await balanceHistoryDir.create(recursive: true);
    await operationLogDir.create(recursive: true);

    // Extract files into temporary directories
    for (final file in archive) {
      final filename = file.name;
      if (filename.isNotEmpty) {
        final data = file.content as Uint8List;
        final outFile = File(path.join(zipFile.parent.path, filename));
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(data);
      }
    }

    // Read and import account data
    final List<File> accountFiles =
        accountDir.listSync().whereType<File>().toList();
    for (final file in accountFiles) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonAccounts = jsonDecode(jsonString);
      final List<Account> accounts =
          jsonAccounts.map((json) => Account.fromJson(json)).toList();
      for (final account in accounts) {
        await _accountRepository.createAccount(account);
      }
    }

    // Read and import asset data
    final List<File> assetFiles =
        assetDir.listSync().whereType<File>().toList();
    for (final file in assetFiles) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonAssets = jsonDecode(jsonString);
      final List<Asset> assets =
          jsonAssets.map((json) => Asset.fromJson(json)).toList();
      for (final asset in assets) {
        await _assetRepository.createAsset(asset);
      }
    }

    // Read and import balance history data
    final List<File> balanceHistoryFiles =
        balanceHistoryDir.listSync().whereType<File>().toList();
    for (final file in balanceHistoryFiles) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonBalanceHistories = jsonDecode(jsonString);
      final List<BalanceHistory> balanceHistories = jsonBalanceHistories
          .map((json) => BalanceHistory.fromJson(json))
          .toList();
      for (final balanceHistory in balanceHistories) {
        await _balanceHistoryRepository
            .recordTotalBalance(balanceHistory.totalBalance);
      }
    }

    // Read and import operation log data
    final List<File> operationLogFiles =
        operationLogDir.listSync().whereType<File>().toList();
    for (final file in operationLogFiles) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonOperationLogs = jsonDecode(jsonString);
      final List<OperationLog> operationLogs =
          jsonOperationLogs.map((json) => OperationLog.fromJson(json)).toList();
      for (final operationLog in operationLogs) {
        await _operationLogRepository.create(operationLog);
      }
    }
  }
}
