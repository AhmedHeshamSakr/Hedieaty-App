import '../entities/event.dart';

abstract class EventRepository {
  /// Retrieves all events as domain entities.
  Future<List<Event>> getAllEvents();

  /// Creates a new event using the domain entity.
  Future<void> createEvent(Event event);

  /// Updates an existing event using the domain entity.
  Future<void> updateEvent(Event event);

  /// Deletes an event by its ID.
  Future<void> deleteEvent(int eventId);

  Future<List<Event>> getEventsByStatus(String status);
}
