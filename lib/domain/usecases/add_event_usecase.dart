import '../repositories/event_repository.dart';
import '../../data/local/models/event_model.dart';

class AddEventUseCase {
  final EventRepository eventRepository;

  AddEventUseCase(this.eventRepository);

  Future<void> execute(EventModel event) async {
    try {
      await eventRepository.createEvent(event);
    } catch (e) {
      throw Exception('Error adding event: ${e.toString()}');
    }
  }
}