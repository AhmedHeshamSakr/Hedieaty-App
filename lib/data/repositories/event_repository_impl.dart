// import 'package:flutter/foundation.dart';
//
// import '../../domain/entities/event.dart';
// import '../../domain/repositories/event_repository.dart';
// import '../local/datasources/sqlite_event_datasource.dart';
// import '../local/datasources/sqlite_user_datasource.dart';
// import '../remote/datasources/firebase_event_datasource.dart';
// import '../models/event_model.dart';
// import 'package:logger/logger.dart';
//
// import '../utils/firebase_auth_service.dart';
//
// class EventRepositoryImpl implements EventRepository {
//   final SqliteEventDatasource localDatasource;
//   final FirebaseEventDataSource remoteDatasource;
//   final SqliteUserDatasource userDatasource;
//   final FirebaseAuthService authService; // Add this
//
//   final Logger logger;
//
//   // Constructor with optional logger
//   EventRepositoryImpl(
//       this.localDatasource,
//       this.remoteDatasource,
//       this.authService,
//       this.userDatasource,
//       {Logger? logger}
//       ) : logger = logger ?? Logger();
//
//   @override
//   Future<List<Event>> getAllEvents() async {
//     try {
//       // Attempt to fetch events from the remote datasource
//       final remoteEvents = await remoteDatasource.getAllEvents();
//
//       if (remoteEvents.isNotEmpty) {
//         // Convert remote events to local models
//         final batchEvents = remoteEvents
//             .map((dto) => EventModel.fromEntity(dto as Event))
//             .toList();
//
//         // Batch insert into the local database
//         await localDatasource.batchEvents(batchEvents);
//       }
//     } catch (e, stackTrace) {
//       // Log the error but do not interrupt the flow
//       logger.e("Error syncing remote events to local", e, stackTrace);
//     }
//
//     // Always fetch from the local datasource
//     final localEvents = await localDatasource.getAllEvents();
//
//     if (localEvents.isEmpty) {
//       // Log a warning if no events are found
//       logger.w("Local database contains no events");
//     }
//
//     return localEvents.map((model) => model.toEntity()).toList();
//   }
//
//
//   @override
//   Future<Event> createEvent(Event event) async {
//     try {
//       // Get the current authenticated user
//       final currentUser = authService.currentUser;
//
//       if (currentUser == null) {
//         throw Exception('No user is currently logged in');
//       }
//
//       // Fetch the user details from local database
//       final userModel = await userDatasource.getUserById(currentUser.uid);
//
//       if (userModel == null) {
//         throw Exception('User not found in local database');
//       }
//
//       // Create a new event with the current user's ID
//       final eventWithUserId = event.copyWith(
//         // Convert Firebase UID to int, or use a consistent ID strategy
//           userId: currentUser.uid, id: ''
//       );
//
//       // Prepare the event model for local insertion
//       final eventModel = EventModel.fromEntity(eventWithUserId);
//
//       // Insert the event and get the local ID
//       final localId = await localDatasource.insertEvent(eventModel);
//
//       // Update the event with the local generated ID
//       final updatedEvent = eventWithUserId.copyWith(id: localId, userId: '');
//
//       // Convert to DTO for remote datasource if needed
//       final eventDTO = updatedEvent.toDTO();
//
//       // Optional: Add to remote datasource
//       await remoteDatasource.addEvent(eventDTO);
//
//       return updatedEvent;
//     } catch (e, stackTrace) {
//       // Consider using a proper logging mechanism
//       if (kDebugMode) {
//         print("Error creating event: $e");
//       }
//       if (kDebugMode) {
//         print(stackTrace);
//       }
//       rethrow;
//     }
//   }
//   @override
//   Future<void> updateEvent(Event event) async {
//     try {
//       // Convert Event to DTO and update in remote datasource
//       final eventDTO = EventDTO.fromEventModel(event as EventModel);
//       await remoteDatasource.updateEvent(event.id.toString(), eventDTO);
//     } catch (e, stackTrace) {
//       logger.e("Error updating event in remote datasource", e, stackTrace);
//     }
//
//     // Convert Event to Model and update in local datasource
//     final eventModel = EventModel.fromEntity(event);
//     await localDatasource.updateEvent(eventModel);
//   }
//
//   @override
//   Future<void> deleteEvent(int eventId) async {
//     try {
//       // Delete event from remote datasource
//       await remoteDatasource.deleteEvent(eventId.toString());
//     } catch (e, stackTrace) {
//       logger.e("Error deleting event in remote datasource", e, stackTrace);
//     }
//
//     // Delete event from local datasource
//     await localDatasource.deleteEvent(eventId);
//   }
//
//   Future<void> synchronizeEvents() async {
//     try {
//       // Fetch remote events
//       final remoteEvents = await remoteDatasource.getAllEvents();
//       if (remoteEvents.isEmpty) return;
//
//       // Clear local database
//       await localDatasource.clearAllEvents(null);
//       // Insert fetched events into local database
//       final batchEvents = remoteEvents.map((dto) => EventModel.fromDTO(dto)).toList();
//       await localDatasource.batchEvents(batchEvents);
//     } catch (e, stackTrace) {
//       logger.e("Synchronization failed", e, stackTrace);
//     }
//   }
//
//   @override
//   Future<List<Event>> getEventsByStatus(String status) async {
//     final DateTime now = DateTime.now();
//     DateTime? startDate;
//     DateTime? endDate;
//     switch (status) {
//       case 'Upcoming':
//         startDate = now;
//         break;
//       case 'Current':
//         startDate = now.subtract(const Duration(hours: 24));
//         endDate = now.add(const Duration(hours: 24));
//         break;
//       case 'Past':
//         endDate = now;
//         break;
//       default:
//         throw ArgumentError('Invalid status provided: $status');
//     }
//     // Filter events by date in the local datasource
//     final filteredEvents = await localDatasource.filterEvents(
//       startDate: startDate,
//       endDate: endDate,
//     );
//     return filteredEvents.map((model) => model.toEntity()).toList();
//   }
// }