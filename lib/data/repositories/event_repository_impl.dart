import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../local/datasources/sqlite_event_datasource.dart';
import '../remote/datasources/firebase_event_datasource.dart';
import '../local/models/event_model.dart';
import '../remote/models/event_dto.dart';

class EventRepositoryImpl implements EventRepository {
  final SqliteEventDatasource localDatasource;
  final FirebaseEventDataSource remoteDatasource;

  EventRepositoryImpl(this.localDatasource, this.remoteDatasource);

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      // Fetch from remote and sync to local
      final remoteEvents = await remoteDatasource.getAllEvents();
      for (var eventDTO in remoteEvents) {
        // Convert DTO to EventModel and insert into local database
        final eventModel = EventModel.fromEntity(eventDTO as Event);
        await localDatasource.insertEvent(eventModel);
      }
    } catch (e) {
      print("Error fetching remote events: $e");
    }

    // Retrieve from local and convert to domain entities
    final localEvents = await localDatasource.getAllEvents();
    return localEvents.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createEvent(Event event) async {
    try {
      // Convert Event entity to DTO for remote storage
      final eventDTO = EventDTO.fromEventModel(event as EventModel);
      await remoteDatasource.addEvent(eventDTO);
    } catch (e) {
      print("Error creating event in remote source: $e");
    }

    // Convert Event entity to Model for local storage
    final eventModel = EventModel.fromEntity(event);
    await localDatasource.insertEvent(eventModel);
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      // Convert Event entity to DTO for remote update
      final eventDTO = EventDTO.fromEventModel(event as EventModel);
      await remoteDatasource.updateEvent(event.id.toString(), eventDTO);
    } catch (e) {
      print("Error updating event in remote source: $e");
    }

    // Convert Event entity to Model for local update
    final eventModel = EventModel.fromEntity(event);
    await localDatasource.updateEvent(eventModel);
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    try {
      // Delete event from remote
      await remoteDatasource.deleteEvent(eventId.toString());
    } catch (e) {
      print("Error deleting event in remote source: $e");
    }

    // Delete event from local
    await localDatasource.deleteEvent(eventId);
  }

  @override
  Future<List<Event>> getEventsByStatus(String status) async {
    final allEvents = await getAllEvents();
    final now = DateTime.now();

    if (status == 'Upcoming') {
      return allEvents.where((event) => event.date.isAfter(now)).toList();
    } else if (status == 'Current') {
      return allEvents.where((event) =>
      event.date.isAtSameMomentAs(now) ||
          (event.date.isBefore(now) && event.date.add(const Duration(hours: 24)).isAfter(now))
      ).toList();
    } else if (status == 'Past') {
      return allEvents.where((event) => event.date.isBefore(now)).toList();
    } else {
      throw Exception('Invalid status provided');
    }
  }
}
