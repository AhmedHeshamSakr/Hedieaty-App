import 'dart:async';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize ffi loader for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Get the path to the database file
    String path = join(await _getDatabasePath(), 'app_database.db');

    // Open the database
    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) => _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Example schema update
        }
      },
    );
  }

  Future<String> _getDatabasePath() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return Directory.current.path; // Use current directory for desktop
    } else {
      return await getDatabasesPath(); // Use standard path for mobile
    }
  }

  Future<void> _createTables(Database db) async {
    // Creating tables
    await db.execute('''
      CREATE TABLE users_new (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firebase_uid TEXT NOT NULL,
      name TEXT,
      email TEXT,
      preferences TEXT
    );
    INSERT INTO users_new (id, firebase_uid, name, email, preferences)
    SELECT id, NULL, name, email, preferences FROM users;
    DROP TABLE users;
    ALTER TABLE users_new RENAME TO users;

    ''');

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