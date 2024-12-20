
import '../../models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUserDatasource {
  final Database db;
  SqliteUserDatasource({required this.db});

  Future<UserModel?> getUser(String id) async {
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> insertUser(UserModel user) async {
    await db.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertOrUpdateUser(Map<String, dynamic> userData) async {
    await db.insert(
      'users',
      {
        'id': userData['id'],
        'name': userData['name'] ?? 'Unknown',
        'email': userData['email'] ?? '',
        'preferences': userData['preferences'] ?? '{}',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> updateUser(UserModel user) async {
    await db.update('users', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }
  Future<void> deleteUser(String id) async {
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }


}




