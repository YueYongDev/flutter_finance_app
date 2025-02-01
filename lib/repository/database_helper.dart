import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_app.db');
    if (GetPlatform.isDesktop) {
      debugPrint("DB Path:$path");
    }
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE account(
      id TEXT PRIMARY KEY,
      name TEXT,
      color TEXT,
      currency TEXT,
      balance REAL,
      change TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      type TEXT,
      extra TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE asset(
      id TEXT PRIMARY KEY,
      name TEXT,
      amount REAL,
      currency TEXT,
      tag TEXT,
      note TEXT,
      accountId TEXT,
      enableCounting INTEGER,
      createdAt INTEGER,
      updatedAt INTEGER,
      type TEXT,
      extra TEXT,
      FOREIGN KEY (accountId) REFERENCES account (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE balance_history(
      id TEXT PRIMARY KEY,
      account_id TEXT,
      total_balance REAL,
      recorded_at INTEGER,
      created_at INTEGER,
      FOREIGN KEY (account_id) REFERENCES account (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE operation_log(
      id TEXT PRIMARY KEY,
      operation_type TEXT,
      account_id TEXT,
      asset_id TEXT,
      key TEXT,
      value TEXT,
      extra TEXT,
      created_at INTEGER,
      updated_at INTEGER
    )
  ''');

    // Insert initial record with total balance 0 and recorded_at as now - 1 day
    final now = DateTime.now();
    final oneDayAgo =
        now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    await db.insert('balance_history', {
      'id': oneDayAgo.toString(),
      'account_id': null,
      'total_balance': 0.0,
      'recorded_at': oneDayAgo,
      'created_at': now.millisecondsSinceEpoch,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from $oldVersion to $newVersion');
    if (oldVersion < 2) {
      // Add the new table if it doesn't exist
      await db.execute('''
    CREATE TABLE IF NOT EXISTS balance_history(
      id TEXT PRIMARY KEY,
      account_id TEXT,
      total_balance REAL,
      recorded_at INTEGER,
      created_at INTEGER,
      FOREIGN KEY (account_id) REFERENCES account (id)
    )
  ''');
      // Insert initial record with total balance 0 and recorded_at as now - 1 day
      final now = DateTime.now();
      final oneDayAgo =
          now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      await db.insert('balance_history', {
        'id': oneDayAgo.toString(),
        'account_id': null,
        'total_balance': 0.0,
        'recorded_at': oneDayAgo,
        'created_at': now.millisecondsSinceEpoch,
      });
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS operation_log(
          id TEXT PRIMARY KEY,
          operation_type TEXT,
          account_id TEXT,
          asset_id TEXT,
          key TEXT,
          value TEXT,
          extra TEXT,
          created_at INTEGER,
          updated_at INTEGER
        )
      ''');
    }
  }
  // ---- Account CRUD Operations ----

  // Create
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert('account', account);
  }

  Future<Map<String, dynamic>> getAccount(String id) async {
    final db = await database;
    final result = await db.query('account', where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  // Read
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return await db.query('account');
  }

  // Update
  Future<int> updateAccount(String id, Map<String, dynamic> account) async {
    final db = await database;
    return await db
        .update('account', account, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> deleteAccount(String id) async {
    final db = await database;
    return await db.delete('account', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Asset CRUD Operations ----

  // Create
  Future<void> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    await db.insert('asset', asset);
  }

  // Read
  Future<List<Map<String, dynamic>>> getAssets() async {
    final db = await database;
    return await db.query('asset');
  }

  // Update
  Future<int> updateAsset(String id, Map<String, dynamic> asset) async {
    final db = await database;
    return await db.update('asset', asset, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> deleteAsset(String id) async {
    final db = await database;
    return await db.delete('asset', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Balance History CRUD Operations ----

  // Create
  Future<void> insertBalanceHistory(Map<String, dynamic> history) async {
    final db = await database;
    await db.insert('balance_history', history);
  }

  // Read all balance history ordered by recorded_at
  Future<List<Map<String, dynamic>>> getBalanceHistory({int? limit}) async {
    final db = await database;
    return await db.query(
      'balance_history',
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
  }

  // Get balance history for a specific date range
  Future<List<Map<String, dynamic>>> getBalanceHistoryRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    return await db.query(
      'balance_history',
      where: 'recorded_at BETWEEN ? AND ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch
      ],
      orderBy: 'recorded_at ASC',
    );
  }

  // Calculate total balance from all accounts
  Future<double> calculateTotalBalance() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(balance) as total FROM account',
    );
    return result.first['total'] as double? ?? 0.0;
  }

  // Record current balance in history
  Future<void> recordCurrentBalance() async {
    final totalBalance = await calculateTotalBalance();
    final now = DateTime.now();

    await insertBalanceHistory({
      'id': now.millisecondsSinceEpoch.toString(),
      'account_id': '', // Add account_id field
      'total_balance': totalBalance,
      'recorded_at': now.millisecondsSinceEpoch,
      'created_at': now.millisecondsSinceEpoch,
    });
  }

  // ---- Operation Log CRUD Operations ----

  // Create
  Future<void> insertOperationLog(Map<String, dynamic> log) async {
    final db = await database;
    await db.insert('operation_log', log);
  }

  // Read all logs
  Future<List<Map<String, dynamic>>> getOperationLogs({int? limit}) async {
    final db = await database;
    return await db.query(
      'operation_log',
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  // Read logs by account
  Future<List<Map<String, dynamic>>> getOperationLogsByAccount(
    String accountId, {
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      'operation_log',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  // Update
  Future<int> updateOperationLog(String id, Map<String, dynamic> log) async {
    final db = await database;
    return await db.update(
      'operation_log',
      log,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete
  Future<int> deleteOperationLog(String id) async {
    final db = await database;
    return await db.delete(
      'operation_log',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
