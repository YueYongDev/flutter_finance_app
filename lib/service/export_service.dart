import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/entity/asset.dart';
import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/entity/operation_log.dart';
import 'package:flutter_finance_app/repository/account_repository.dart';
import 'package:flutter_finance_app/repository/asset_repository.dart';
import 'package:flutter_finance_app/repository/balance_history_repository.dart';
import 'package:flutter_finance_app/repository/operation_log_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExportService {
  final AccountRepository _accountRepository = AccountRepository();
  final AssetRepository _assetRepository = AssetRepository();
  final BalanceHistoryRepository _balanceHistoryRepository =
      BalanceHistoryRepository();
  final OperationLogRepository _operationLogRepository =
      OperationLogRepository();

  Future<File> exportData() async {
    // 1. 从数据库中获取数据
    final accounts = await _accountRepository.retrieveAccounts(); // 方法名已修正
    final assets = await _assetRepository.retrieveAssets(); // 方法名已修正
    final balanceHistories =
        await _balanceHistoryRepository.getTotalHistory(); // 方法名已修正
    final operationLogs = await _operationLogRepository.getAll(); // 方法名已修正

    // 2. 准备临时目录和子目录
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // 定义导出目录名称，比如 export_20250202123456
    final String timestamp = DateUtil.formatDateMs(
      DateTime.now().millisecondsSinceEpoch,
      format: "yyyyMMddHHmmss",
    );
    final String exportFolderName = "export_$timestamp";

    // 在临时目录下创建一个导出目录
    final Directory exportDir = Directory(p.join(tempPath, exportFolderName));
    await exportDir.create(recursive: true);

    // 在导出目录下创建各个子目录
    final Directory accountDir = Directory(p.join(exportDir.path, 'account'));
    final Directory assetDir = Directory(p.join(exportDir.path, 'asset'));
    final Directory balanceHistoryDir =
        Directory(p.join(exportDir.path, 'balance_history'));
    final Directory operationLogDir =
        Directory(p.join(exportDir.path, 'operation_log'));

    await accountDir.create(recursive: true);
    await assetDir.create(recursive: true);
    await balanceHistoryDir.create(recursive: true);
    await operationLogDir.create(recursive: true);

    // 3. 将数据写入 JSON 文件（分批，每批20条记录）

    // 写入 account 数据
    int accountFileIndex = 0;
    for (int i = 0; i < accounts.length; i += 20) {
      final List<Account> batch = accounts.sublist(
          i, i + 20 > accounts.length ? accounts.length : i + 20);
      final String jsonContent =
          jsonEncode(batch.map((e) => e.toJson()).toList());

      final File accountFile = File(
        p.join(accountDir.path, 'account_${accountFileIndex++}.json'),
      );
      await accountFile.writeAsString(jsonContent);
    }

    // 写入 asset 数据
    int assetFileIndex = 0;
    for (int i = 0; i < assets.length; i += 20) {
      final List<Asset> batch =
          assets.sublist(i, i + 20 > assets.length ? assets.length : i + 20);
      final String jsonContent =
          jsonEncode(batch.map((e) => e.toJson()).toList());

      final File assetFile = File(
        p.join(assetDir.path, 'asset_${assetFileIndex++}.json'),
      );
      await assetFile.writeAsString(jsonContent);
    }

    // 写入 balance history 数据
    int balanceHistoryFileIndex = 0;
    for (int i = 0; i < balanceHistories.length; i += 20) {
      final List<BalanceHistory> batch = balanceHistories.sublist(i,
          i + 20 > balanceHistories.length ? balanceHistories.length : i + 20);
      final String jsonContent =
          jsonEncode(batch.map((e) => e.toJson()).toList());

      final File balanceHistoryFile = File(
        p.join(balanceHistoryDir.path,
            'balance_history_${balanceHistoryFileIndex++}.json'),
      );
      await balanceHistoryFile.writeAsString(jsonContent);
    }

    // 写入 operation log 数据
    int operationLogFileIndex = 0;
    for (int i = 0; i < operationLogs.length; i += 20) {
      final List<OperationLog> batch = operationLogs.sublist(
          i, i + 20 > operationLogs.length ? operationLogs.length : i + 20);
      final String jsonContent =
          jsonEncode(batch.map((e) => e.toJson()).toList());

      final File operationLogFile = File(
        p.join(operationLogDir.path,
            'operation_log_${operationLogFileIndex++}.json'),
      );
      await operationLogFile.writeAsString(jsonContent);
    }

    // 4. 创建 ZIP 压缩包
    final Archive archive = Archive();

    // 递归遍历 exportDir 并将文件添加到 Archive 中，
    // 这里使用 p.relative 计算相对于 exportDir 的相对路径，然后在 ZIP 内以 exportFolderName 为根目录
    void addDirectoryToArchive(Directory dir) {
      final List<FileSystemEntity> entities = dir.listSync();
      for (final entity in entities) {
        if (entity is File) {
          // 计算 entity.path 相对于 exportDir.path 的相对路径
          final String relativePath =
              p.relative(entity.path, from: exportDir.path);
          // 拼接上 exportFolderName，形成 ZIP 内的目录结构
          final String zipPath = p.join(exportFolderName, relativePath);
          final Uint8List fileBytes = entity.readAsBytesSync();
          archive.addFile(ArchiveFile(zipPath, fileBytes.length, fileBytes));
        } else if (entity is Directory) {
          addDirectoryToArchive(entity);
        }
      }
    }

    addDirectoryToArchive(exportDir);

    // 将压缩数据写入 ZIP 文件（保存在 tempPath 下）
    final List<int> zipData = ZipEncoder().encode(archive);
    final File zipFile = File(p.join(tempPath, '$exportFolderName.zip'));
    await zipFile.writeAsBytes(zipData);

    return zipFile;
  }
}
