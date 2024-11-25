import 'package:hedieaty/data/local/models/event_model.dart';

import '../entities/event.dart';
import '../repositories/event_repository.dart';

class AddEventUseCase {
  final EventRepository repository;

  AddEventUseCase(this.repository);

  Future<void> call(Event event) async {
    await repository.createEvent(event as EventModel);
  }
}
