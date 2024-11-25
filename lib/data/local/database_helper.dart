import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Private constructor to prevent multiple instances
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database when it's not already done
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the database file
    String path = join(await getDatabasesPath(), 'app_database.db');

    // Open the database and create tables
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) => _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Example: Add a new column or table
          // await db.execute('ALTER TABLE users ADD COLUMN age INTEGER');
        }
      },
      // onDowngrade: (db, oldVersion, newVersion) async {
      //   // Handle schema downgrades if needed
      // },
    );
  }

  Future<void> _createTables(Database db) async {
    // Creating the 'users' table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        preferences TEXT
      );
    ''');

    // Creating the 'events' table
    await db.execute('''
      CREATE TABLE events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        location TEXT,
        description TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      );
    ''');

    // Creating the 'gifts' table
    await db.execute('''
      CREATE TABLE gifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        eventId INTEGER,
        FOREIGN KEY (eventId) REFERENCES events(id)
      );
    ''');

    // Creating the 'friends' table
    await db.execute('''
      CREATE TABLE friends(
        userId INTEGER,
        friendId INTEGER,
        PRIMARY KEY (userId, friendId),
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (friendId) REFERENCES users(id)
      );
    ''');
  }
}
