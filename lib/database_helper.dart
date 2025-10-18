import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'user.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'geeksforgeeks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gfg_users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return db.insert('gfg_users', user.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await database;
    return db.query('gfg_users');
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      'gfg_users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      'gfg_users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> initializeUsers() async {
    final db = await database;
    final existing = await db.query(
      'gfg_users',
      columns: ['id'],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return;
    }

    final usersToAdd = [
      const User(username: 'John', email: 'john@example.com'),
      const User(username: 'Jane', email: 'jane@example.com'),
      const User(username: 'Alice', email: 'alice@example.com'),
      const User(username: 'Bob', email: 'bob@example.com'),
      const User(username: 'Charlie', email: 'charlie@example.com'),
      const User(username: 'Diana', email: 'diana@example.com'),
      const User(username: 'Eve', email: 'eve@example.com'),
      const User(username: 'Frank', email: 'frank@example.com'),
      const User(username: 'Grace', email: 'grace@example.com'),
      const User(username: 'Hank', email: 'hank@example.com'),
      const User(username: 'Ivy', email: 'ivy@example.com'),
      const User(username: 'Jack', email: 'jack@example.com'),
      const User(username: 'Kathy', email: 'kathy@example.com'),
      const User(username: 'Leo', email: 'leo@example.com'),
    ];

    for (final user in usersToAdd) {
      await insertUser(user);
    }
  }
}
