import 'package:get_it/get_it.dart';
import '../../data/utils/firebase_auth_service.dart';
import '../../domain/repositories/user_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  // serviceLocator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  // serviceLocator.registerLazySingleton<EventRepository>(() => EventRepositoryImpl());
  serviceLocator.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Add other services and controllers here
}