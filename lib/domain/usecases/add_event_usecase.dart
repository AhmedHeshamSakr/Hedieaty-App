import '../entities/event.dart';
import '../repositories/event_repository.dart';

class AddEventUseCase {
  final EventRepository repository;

  AddEventUseCase({required this.repository});

  Future<void> execute(Event event) async {
    // Additional domain logic or validation can go here, if needed
    await repository.createEvent(event);
  }
}
