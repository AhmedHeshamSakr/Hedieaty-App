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
      version: 2, // Increment the version to reflect schema changes
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON'); // Enable foreign key constraints
      },
      onCreate: (db, version) async {
        await createTables(db); // Create tables for the first time
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Apply schema updates for version 2
          await createTables(db);
        }
        // Add further conditions here for future schema changes
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

  Future<void> createTables(Database db) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      preferences TEXT
    );
  ''');

    await db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      date TEXT NOT NULL,
      location TEXT,
      description TEXT,
      userId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE gifts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      category TEXT,
      price REAL,
      status TEXT,
      eventId INTEGER NOT NULL,
      FOREIGN KEY (eventId) REFERENCES events(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE friends (
      userId INTEGER NOT NULL,
      friendId INTEGER NOT NULL,
      PRIMARY KEY (userId, friendId),
      FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (friendId) REFERENCES users(id) ON DELETE CASCADE
    );
  ''');
  }
}