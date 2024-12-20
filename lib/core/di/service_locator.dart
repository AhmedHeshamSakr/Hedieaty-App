import 'package:get_it/get_it.dart';

import '../../data/local/database_helper.dart';
import '../../data/local/datasources/sqlite_event_datasource.dart';
import '../../data/local/datasources/sqlite_friend_datasource.dart';
import '../../data/local/datasources/sqlite_gift_datasource.dart';
import '../../data/local/datasources/sqlite_user_datasource.dart';
import '../../data/remote/datasources/firebase_user_datasource.dart';
import '../../data/remote/realtime_database_helper.dart';
import '../../data/repositories/repository_impl.dart';
import '../../data/utils/firebase_auth_service.dart';
import '../../data/utils/sync_database.dart';
import '../../domain/repositories/main_repository.dart';
import '../../presentation/pages/addFrinds/add_frinds_controller.dart';
final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize Database
  final database = await DatabaseHelper.instance.database;




  // Register Local Datasources
  serviceLocator.registerLazySingleton<SqliteUserDatasource>(
        () => SqliteUserDatasource(db: database),
  );

  serviceLocator.registerLazySingleton<SQLiteEventDataSource>(
        () => SQLiteEventDataSource(db: database),
  );

  serviceLocator.registerLazySingleton<SQLiteFriendDataSource>(
        () => SQLiteFriendDataSource(db: database),
  );

  serviceLocator.registerLazySingleton<SQLiteGiftDataSource>(
        () => SQLiteGiftDataSource(db: database),
  );

  // Register Remote Datasources
  serviceLocator.registerLazySingleton<RealTimeDatabaseHelper>(
        () => RealTimeDatabaseHelper.instance,
  );

  serviceLocator.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(),
  );

  serviceLocator.registerLazySingleton<SyncService>(
        () => SyncService(
       serviceLocator<SqliteUserDatasource>(), // Get from DI container
       serviceLocator<RealTimeDatabaseHelper>(), // Get from DI container
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

  // Register Services
  serviceLocator.registerLazySingleton<FirebaseAuthService>(
        () => FirebaseAuthService(
      sqliteUserDatasource: serviceLocator<SqliteUserDatasource>(),
    ),
  );

  // Register FriendsController
  serviceLocator.registerLazySingleton<FriendsController>(
        () => FriendsController(serviceLocator<Repository>()),
  );
}