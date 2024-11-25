import '../../domain/repositories/event_repository.dart';
import '../local/datasources/sqlite_event_datasource.dart';
import '../local/models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final SqliteEventDatasource localDatasource;

  EventRepositoryImpl(this.localDatasource);

  @override
  Future<List<EventModel>> getAllEvents() async {
    return await localDatasource.getAllEvents();
  }

  @override
  Future<void> createEvent(EventModel event) async {
    await localDatasource.insertEvent(event);
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    await localDatasource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    await localDatasource.deleteEvent(eventId);
  }
}
