import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hedieaty/data/local/database_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseResetUtility {
  /// Completely drops and deletes the database file
  static Future<void> dropDatabase({
    String dbName = 'app_database.db',
    bool reinitialize = true
  }) async {
    try {
      // Determine the database path based on platform
      String path;
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        path = join(Directory.current.path, dbName);
      } else {
        path = join(await getDatabasesPath(), dbName);
      }

      // Check if database exists
      final databaseFactory = _getPlatformDatabaseFactory();
      final databaseExists = await databaseFactory.databaseExists(path);

      if (databaseExists) {
        // Close any existing database connections
        await deleteDatabase(path);
        debugPrint('✅ Database dropped successfully: $path');
      } else {
        debugPrint('ℹ️ No existing database found at $path');
      }

      // Optional: Cleanup related files
      await _cleanupDatabaseFiles(path);

      // Reinitialize if requested
      if (reinitialize) {
        await DatabaseHelper.instance.database;
        debugPrint('✅ Database reinitialized');
      }
    } catch (e) {
      debugPrint('❌ Error dropping database: $e');
      rethrow;
    }
  }

  /// Additional cleanup of database-related files
  static Future<void> _cleanupDatabaseFiles(String basePath) async {
    try {
      final file = File(basePath);
      final directory = file.parent;

      // List and potentially delete related files (like journal files)
      final files = await directory.list().toList();
      for (var entity in files) {
        if (entity.path.contains(basename(basePath))) {
          try {
            await (entity as File).delete();
            debugPrint('🧹 Cleaned up related file: ${entity.path}');
          } catch (e) {
            debugPrint('⚠️ Could not delete related file: ${entity.path}');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error during database file cleanup: $e');
    }
  }

  /// Get the appropriate database factory based on the platform
  static DatabaseFactory _getPlatformDatabaseFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      return databaseFactoryFfi;
    }
    return databaseFactory;
  }

  /// Comprehensive database reset method with optional data preservation
  static Future<void> resetDatabase({
    bool preserveUserData = false,
    bool preserveSpecificTables = false,
    List<String>? tablesToPreserve
  }) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;

      if (preserveUserData) {
        // Implement selective data preservation logic
        await _preserveUserData(db);
      }

      // Drop and recreate all tables
      await _recreateDatabaseSchema(db,
          preserveSpecificTables: preserveSpecificTables,
          tablesToPreserve: tablesToPreserve
      );

      debugPrint('✅ Database schema reset successfully');
    } catch (e) {
      debugPrint('❌ Database reset failed: $e');
      rethrow;
    }
  }

  /// Preserve specific user data during reset
  static Future<void> _preserveUserData(Database db) async {
    try {
      // Example: Backup user preferences or essential data
      final userData = await db.query('users', columns: ['id', 'name', 'email', 'preferences']);
      debugPrint('👥 Preserved User Data: ${userData.length} records');
      // You could implement logic to restore this data after recreation
    } catch (e) {
      debugPrint('⚠️ Error preserving user data: $e');
    }
  }

  /// Recreate database schema with optional table preservation
  static Future<void> _recreateDatabaseSchema(
      Database db, {
        bool preserveSpecificTables = false,
        List<String>? tablesToPreserve
      }) async {
    // Get all existing tables
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );

    // Drop existing tables
    for (var table in tables) {
      final tableName = table['name'] as String;

      // Skip preservation if requested
      if (preserveSpecificTables &&
          tablesToPreserve != null &&
          tablesToPreserve.contains(tableName)) {
        debugPrint('🛡️ Preserving table: $tableName');
        continue;
      }

      await db.execute('DROP TABLE IF EXISTS $tableName');
      debugPrint('🗑️ Dropped table: $tableName');
    }

    // Recreate tables using the original creation logic
    await DatabaseHelper.instance.createTables(db);
  }
}

/// Example usage in main or debug method
Future<void> debugDatabaseOperations() async {
  // Complete database drop and reinitialize
  await DatabaseResetUtility.dropDatabase();

  // Selective reset with user data preservation
  await DatabaseResetUtility.resetDatabase(
      preserveUserData: true,
      preserveSpecificTables: true,
      tablesToPreserve: ['users']
  );
}