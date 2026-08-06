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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
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
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('customers', row);
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
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete(
      'customers',
      where: 'id=?',
      whereArgs: [id],
    );
    Future<int> insertStockHistory(Map<String, dynamic> row) async {
      final db = await database;
      return await db.insert('stock_history', row);
    }

    Future<List<Map<String, dynamic>>> getStockHistory(int productId) async {
      final db = await database;

      return await db.query(
        'stock_history',
        where: 'productId = ?',
        whereArgs: [productId],
        orderBy: 'id DESC',
      );
    }
  }
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await instance.database;
    return await db.insert('products', product);
  }
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }
  Future<int> updateProduct(
      int id,
      Map<String, dynamic> product,
      ) async {
    final db = await instance.database;

    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future close() async {
    final db = await database;
    db.close();
  }
}