// ignore_for_file: slash_for_doc_comments

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
    String path = join(await getDatabasesPath(), 'chat.db');
    return await openDatabase(
      path,
      version: 2,
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
            is_user INTEGER,  -- Kolom untuk menandai apakah pesan berasal dari pengguna
            timestamp TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE purchase_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_name TEXT,
            quantity INTEGER,
            total_price REAL,
            image TEXT,
            payment_method TEXT,
            purchase_date TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE cart ADD COLUMN sold INTEGER; -- Menambahkan kolom sold saat upgrade
          ''');
          await db.execute('''
            ALTER TABLE chat_history ADD COLUMN is_user INTEGER; -- Menambahkan kolom is_user saat upgrade
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

  Future<void> deleteCartItem(String id) async {
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

  Future<void> saveChatHistory(
      String productName, String message, bool isUser) async {
    final db = await database;
    await db.insert('chat_history', {
      'product_name': productName,
      'message': message,
      'is_user': isUser ? 1 : 0,
      'timestamp': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final db = await database;
    return await db.query('chat_history', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getMessages(String productName) async {
    final db = await database;
    return await db.query(
      'chat_history',
      where: 'product_name = ?',
      whereArgs: [productName],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> insertMessage(
      String productName, String message, bool isUser) async {
    final db = await database;
    await db.insert('chat_history', {
      'product_name': productName,
      'message': message,
      'is_user': isUser ? 1 : 0,
      'timestamp': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> loadGroupedChats() async {
    List<Map<String, dynamic>> allChats = await getChatHistory();

    Map<String, Map<String, dynamic>> groupedChats = {};

    for (var chat in allChats) {
      String? productName = chat['product_name'];
      if (productName != null) {
        if (!groupedChats.containsKey(productName)) {
          groupedChats[productName] = chat;
        } else {
          if (DateTime.parse(chat['timestamp']).isAfter(
              DateTime.parse(groupedChats[productName]?['timestamp']))) {
            groupedChats[productName] = chat;
          }
        }
      }
    }

    return groupedChats.values.toList();
  }

  /**
   * Purchase History Data Methods
   */

  Future<void> insertPurchaseHistory(Map<String, dynamic> purchase) async {
    final db = await database;
    await db.insert(
      'purchase_history',
      purchase,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPurchaseHistory() async {
    final db = await database;
    return await db.query('purchase_history');
  }

  Future<void> confirmPayment({
    required String productName,
    required int quantity,
    required double totalPrice,
    required String image,
    required String paymentMethod,
  }) async {
    final db = await database;
    Map<String, dynamic> purchase = {
      'product_name': productName,
      'quantity': quantity,
      'total_price': totalPrice,
      'image': image,
      'payment_method': paymentMethod,
      'purchase_date': DateTime.now().toIso8601String(),
    };
    await db.insert(
      'purchase_history',
      purchase,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
