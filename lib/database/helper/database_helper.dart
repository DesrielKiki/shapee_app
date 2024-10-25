import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /**
   * Initialize Database
   */
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(
      path,
      version: 2, // Pastikan ini sesuai
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            quantity INTEGER,
            totalPrice REAL, 
            image TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE chat_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_name TEXT,
            message TEXT,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE cart ADD COLUMN sold INTEGER; // Menambahkan kolom sold saat upgrade
          ''');
        }
      },
    );
  }

  /**
   * Cart Data Methods
   */
  
  Future<void> insertCartItem(Map<String, dynamic> cartItem) async {
    final db = await database;
    print('Menyimpan item ke keranjang: $cartItem');

    await db.insert(
      'cart',
      cartItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  /**
   * Chat History Data Methods
   */

  Future<void> saveChatHistory(String productName, String message) async {
    final db = await database;
    await db.insert('chat_history', {
      'product_name': productName,
      'message': message,
      'timestamp': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final db = await database;
    return await db.query('chat_history', orderBy: 'timestamp DESC');
  }
}