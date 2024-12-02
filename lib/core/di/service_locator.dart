import 'package:get_it/get_it.dart';
import '../../data/local/database_helper.dart';
import '../../data/local/datasources/sqlite_user_datasource.dart';
import '../../data/utils/firebase_auth_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {

  final database = await DatabaseHelper.instance.database;
  serviceLocator.registerLazySingleton<SqliteUserDatasource>(
        () => SqliteUserDatasource(database: database),
  );

  // Register Services
  serviceLocator.registerLazySingleton<FirebaseAuthService>(
        () => FirebaseAuthService(
      sqliteUserDatasource: serviceLocator<SqliteUserDatasource>(),
    ),
  );
  // Add other services and controllers here
}
