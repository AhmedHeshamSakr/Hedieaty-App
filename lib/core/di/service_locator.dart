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
        () => SqliteUserDatasource(db: database),
  );

  serviceLocator.registerLazySingleton<SQLiteEventDataSource>(
        () => SQLiteEventDataSource(database: dp),
  );

  serviceLocator.registerLazySingleton<SqliteFriendDatasource>(
        () => SqliteFriendDatasource(database: database),
  );

  serviceLocator.registerLazySingleton<SqliteGiftDatasource>(
        () => SqliteGiftDatasource(database: database),
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
        () => RepositoryImpl._(
      serviceLocator<SQLiteEventDatasource>(),
      serviceLocator<SqliteFriendDatasource>(),
      serviceLocator<SqliteGiftDatasource>(),
      serviceLocator<SqliteUserDatasource>(),
      serviceLocator<RealTimeDatabaseHelper>(),
    ),
  );

  // You can add more services and controllers here as needed
}