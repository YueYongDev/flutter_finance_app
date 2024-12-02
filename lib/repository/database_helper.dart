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
      CREATE TABLE accounts(
        id TEXT PRIMARY KEY,
        name TEXT,
        color TEXT,
        currency TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE assets(
        id TEXT PRIMARY KEY,
        name TEXT,
        amount REAL,
        currency TEXT,
        tag TEXT,
        note TEXT,
        accountId TEXT,
        countInfo TEXT,
        FOREIGN KEY (accountId) REFERENCES accounts (id)
      )
    ''');
  }

  // ---- Account CRUD Operations ----

  // Create
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert('accounts', account);
  }

  // Read
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return await db.query('accounts');
  }

  // Update
  Future<int> updateAccount(String id, Map<String, dynamic> account) async {
    final db = await database;
    return await db
        .update('accounts', account, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> deleteAccount(String id) async {
    final db = await database;
    return await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Asset CRUD Operations ----

  // Create
  Future<void> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    await db.insert('assets', asset);
  }

  // Read
  Future<List<Map<String, dynamic>>> getAssets() async {
    final db = await database;
    return await db.query('assets');
  }

  // Update
  Future<int> updateAsset(String id, Map<String, dynamic> asset) async {
    final db = await database;
    return await db.update('assets', asset, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> deleteAsset(String id) async {
    final db = await database;
    return await db.delete('assets', where: 'id = ?', whereArgs: [id]);
  }
}
