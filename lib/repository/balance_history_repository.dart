import 'dart:math';

import 'package:flutter_finance_app/entity/balance_history.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';

class BalanceHistoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> recordTotalBalance(double totalBalance) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();
    final todayStart =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    // Check if a record for today already exists
    final result = await db.query(
      'balance_history',
      where: 'account_id IS NULL AND recorded_at >= ?',
      whereArgs: [todayStart],
    );

    if (result.isNotEmpty) {
      // Update the existing record
      await db.update(
        'balance_history',
        {
          'total_balance': totalBalance,
          'recorded_at': now.millisecondsSinceEpoch
        },
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );
    } else {
      // Insert a new record
      await db.insert('balance_history', {
        'id': now.millisecondsSinceEpoch.toString(),
        'account_id': null,
        'total_balance': totalBalance,
        'recorded_at': now.millisecondsSinceEpoch,
        'created_at': now.millisecondsSinceEpoch,
      });
    }
  }

  Future<void> recordAccountBalance(String accountId, double balance) async {
    final db = await _databaseHelper.database;

    // Insert a new record
    await db.insert('balance_history', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'account_id': accountId,
      'total_balance': balance,
      'recorded_at': DateTime.now().millisecondsSinceEpoch,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // 获取最新的总余额记录
  Future<BalanceHistory?> getLatestTotal() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balance_history',
      where: 'account_id IS NULL',
      orderBy: 'recorded_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return BalanceHistory.fromMap(maps.first);
  }

  // 获取最新的账户余额记录
  Future<BalanceHistory?> getLatestForAccount(String accountId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balance_history',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'recorded_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return BalanceHistory.fromMap(maps.first);
  }

  // 获取总余额历史记录
  Future<List<BalanceHistory>> getTotalHistory({int? limit}) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balance_history',
      where: 'account_id IS NULL',
      orderBy: 'recorded_at DESC',
      limit: limit,
    );

    return maps.map((map) => BalanceHistory.fromMap(map)).toList();
  }

  // 获取账户余额历史记录
  Future<List<BalanceHistory>> getAccountHistory(String accountId,
      {int? limit}) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balance_history',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'recorded_at DESC',
      limit: limit,
    );

    return maps.map((map) => BalanceHistory.fromMap(map)).toList();
  }

  // 清理旧记录
  Future<void> cleanupOldRecords() async {
    final db = await _databaseHelper.database;
    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
    await db.delete(
      'balance_history',
      where: 'recorded_at < ?',
      whereArgs: [sixMonthsAgo.millisecondsSinceEpoch],
    );
  }

  Future<void> insertMockData() async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();
    final random = Random();

    // Insert mock data for the past 10 days
    for (int i = 0; i < 20; i++) {
      final date = now.subtract(Duration(days: i));
      final timestamp =
          date.millisecondsSinceEpoch; // Get the timestamp for i days ago

      double randomBalance = 500 + random.nextDouble() * 1000;
      await db.insert('balance_history', {
        'id': timestamp.toString(),
        'account_id': "mock_account_id", // or specify an account_id if needed
        'total_balance': randomBalance, // Mock balance
        'recorded_at': timestamp, // Use the timestamp from i days ago
        'created_at': timestamp, // Use the timestamp from i days ago
      });
    }
  }

  Future<void> cleanupMockData() async {
    final db = await _databaseHelper.database;

    // Delete all mock data entries
    await db.delete('balance_history',
        where: 'account_id = ?', whereArgs: ["mock_account_id"]);
  }
}
