import 'package:get_it/get_it.dart';
import '../../data/local/database_helper.dart';
import '../../data/local/datasources/sqlite_event_datasource.dart';
import '../../data/local/datasources/sqlite_friend_datasource.dart';
import '../../data/local/datasources/sqlite_gift_datasource.dart';
import '../../data/local/datasources/sqlite_user_datasource.dart';
import '../../data/remote/realtime_database_helper.dart';
import '../../data/repositories/repository_impl.dart';
import '../../data/utils/firebase_auth_service.dart';
import '../../domain/repositories/main_repository.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize Database
  final database = await DatabaseHelper.instance.database;

  // Register Local Datasources
  serviceLocator.registerLazySingleton<SqliteUserDatasource>(
        () => SqliteUserDatasource(db: database), // Pass `db` parameter here
  );

  serviceLocator.registerLazySingleton<SQLiteEventDataSource>(
        () => SQLiteEventDataSource(db: database), // Ensure parameter matches constructor
  );

  serviceLocator.registerLazySingleton<SQLiteFriendDataSource>(
        () => SQLiteFriendDataSource(db: database), // Pass correct parameter
  );

  serviceLocator.registerLazySingleton<SQLiteGiftDataSource>(
        () => SQLiteGiftDataSource(db: database), // Pass correct parameter
  );

  // Register Remote Datasources
  serviceLocator.registerLazySingleton<RealTimeDatabaseHelper>(
        () => RealTimeDatabaseHelper.instance,
  );

  // Register Services
  serviceLocator.registerLazySingleton<FirebaseAuthService>(
        () => FirebaseAuthService(
      sqliteUserDatasource: serviceLocator<SqliteUserDatasource>(),
    ),
  );

  // Register Repository
  serviceLocator.registerLazySingleton<Repository>(
        () => RepositoryImpl(
      serviceLocator<SQLiteEventDataSource>(),
      serviceLocator<SQLiteFriendDataSource>(),
      serviceLocator<SQLiteGiftDataSource>(),
      serviceLocator<SqliteUserDatasource>(),
      serviceLocator<RealTimeDatabaseHelper>(),
    ),
  );
}
