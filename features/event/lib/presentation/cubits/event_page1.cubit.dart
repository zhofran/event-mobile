import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

part 'event_page1.cubit.freezed.dart';
part 'states/event_page1.state.dart';

@lazySingleton
class EventPage1Cubit extends Cubit<EventPage1State> {
  EventPage1Cubit(this._client) : super(EventPage1State.initial());

  final INetworkClient _client;

  void toggleValidityForm({required bool? value}) {
    emit(state.copyWith(isFormValid: value));
  }

  void createEvent({
    required String eventName,
    required String eventType,
    required List<String> eventCategory,
    required String eventDescription,
    required String eventFormat,
    required String eventBanner,
  }) {
    emit(
      state.copyWith(
        eventName: eventName,
        eventType: eventType,
        eventCategory: eventCategory,
        eventDescription: eventDescription,
        eventFormat: eventFormat,
        eventBanner: eventBanner,
      ),
    );
  }
}
