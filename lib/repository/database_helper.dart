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
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
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
      lastUpdateTime INTEGER,
      createTime INTEGER
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
      FOREIGN KEY (accountId) REFERENCES account (id)
    )
  ''');
  }

  // ---- Account CRUD Operations ----

  // Create
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert('account', account);
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
}
