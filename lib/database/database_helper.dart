import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('dairy_management.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // =========================
  // CREATE DATABASE
  // =========================

  Future<void> _createDB(Database db, int version) async {
    // Customers Table
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        businessName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Products Table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT NOT NULL,
        category TEXT NOT NULL,
        unit TEXT NOT NULL,
        purchasePrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        stock INTEGER NOT NULL,
        notes TEXT
      )
    ''');

    // Stock History Table
    await db.execute('''
      CREATE TABLE stock_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Bills Table
    await db.execute('''
      CREATE TABLE bills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        billDate TEXT NOT NULL,
        totalAmount REAL NOT NULL
      )
    ''');
  }

  // =========================
  // DATABASE UPGRADE
  // =========================

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE bills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        billDate TEXT NOT NULL,
        totalAmount REAL NOT NULL
      )
    ''');
    }

    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE bills ADD COLUMN productName TEXT NOT NULL DEFAULT ""',
      );

      await db.execute(
        'ALTER TABLE bills ADD COLUMN quantity REAL NOT NULL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE bills ADD COLUMN rate REAL NOT NULL DEFAULT 0',
      );
    }
  }

  // =========================
  // CUSTOMER METHODS
  // =========================

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    final db = await database;

    return await db.insert(
      'customers',
      row,
    );
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;

    return await db.query(
      'customers',
      orderBy: 'customerName ASC',
    );
  }

  Future<int> updateCustomer(
      int id,
      Map<String, dynamic> row,
      ) async {
    final db = await database;

    return await db.update(
      'customers',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;

    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // PRODUCT METHODS
  // =========================

  Future<int> insertProduct(
      Map<String, dynamic> product,
      ) async {
    final db = await database;

    return await db.insert(
      'products',
      product,
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;

    return await db.query(
      'products',
      orderBy: 'productName ASC',
    );
  }

  Future<int> updateProduct(
      int id,
      Map<String, dynamic> product,
      ) async {
    final db = await database;

    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // STOCK HISTORY METHODS
  // =========================

  Future<int> insertStockHistory(
      Map<String, dynamic> row,
      ) async {
    final db = await database;

    return await db.insert(
      'stock_history',
      row,
    );
  }

  Future<List<Map<String, dynamic>>> getStockHistory(
      int productId,
      ) async {
    final db = await database;

    return await db.query(
      'stock_history',
      where: 'productId = ?',
      whereArgs: [productId],
      orderBy: 'id DESC',
    );
  }

  // =========================
  // BILL METHODS
  // =========================

  Future<int> insertBill(
      Map<String, dynamic> bill,
      ) async {
    final db = await database;

    return await db.insert(
      'bills',
      bill,
    );
  }

  Future<List<Map<String, dynamic>>> getBills() async {
    final db = await database;

    return await db.query(
      'bills',
      orderBy: 'id DESC',
    );
  }

  Future<int> updateBill(
      int id,
      Map<String, dynamic> bill,
      ) async {
    final db = await database;

    return await db.update(
      'bills',
      bill,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBill(int id) async {
    final db = await database;

    return await db.delete(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // CLOSE DATABASE
  // =========================

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}