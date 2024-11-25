import 'event.dart';
import 'gift.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final List<Event> createdEvents;
  final List<Gift> pledgedGifts;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.createdEvents,
    required this.pledgedGifts,
  });
}

//
// /// Domain-specific method to display a fallback name
//   String getDisplayName() {
//     return name.isNotEmpty ? name : email.split('@').first;
//   }
// }
