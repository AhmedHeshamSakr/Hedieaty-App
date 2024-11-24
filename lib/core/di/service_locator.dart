import 'package:get_it/get_it.dart';
import 'package:hedieaty/data/repositories/user_repository_impl.dart';
import 'package:hedieaty/data/repositories/event_repository_impl.dart';
import 'package:hedieaty/domain/repositories/user_repository.dart';
import 'package:hedieaty/domain/repositories/event_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  serviceLocator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  serviceLocator.registerLazySingleton<EventRepository>(() => EventRepositoryImpl());

  // Add other services and controllers here
}