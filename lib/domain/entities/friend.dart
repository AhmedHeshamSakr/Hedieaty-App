import 'event.dart';

class Friend {
  final String id;
  final String name;
  final String profilePicture;
  final List<Event> events;

  Friend({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.events,
  });
}
