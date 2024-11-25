import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

class SqliteUserDatasource {
  final Database database;

  SqliteUserDatasource(this.database);

  Future<UserModel?> getUserById(int userId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> insertUser(UserModel user) async {
    await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteUser(String userId) async {
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
