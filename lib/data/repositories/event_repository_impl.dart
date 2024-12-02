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

  /// New functionality: Filter events by status (Upcoming/Current/Past)
  @override
  Future<List<EventModel>> getEventsByStatus(String status) async {
    final allEvents = await getAllEvents();
    final now = DateTime.now();

    if (status == 'Upcoming') {
      return allEvents.where((event) => event.date.isAfter(now)).toList();
    } else if (status == 'Current') {
      return allEvents.where((event) =>
      event.date.isAtSameMomentAs(now) ||
          (event.date.isBefore(now) && event.date.add(Duration(hours: 24)).isAfter(now))).toList();
    } else if (status == 'Past') {
      return allEvents.where((event) => event.date.isBefore(now)).toList();
    } else {
      throw Exception('Invalid status provided');
    }
  }
}