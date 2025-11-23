part of '../event_page1.cubit.dart';

enum EventPage1StateStatus { initial, loading, failed, succeeded, loadingPost }

@freezed
sealed class EventPage1State with _$EventPage1State {
  const factory EventPage1State({
    required EventPage1StateStatus status,
    required Failure failure,
    required List<SelectOption<String>> eventCategoryOptions,
    required bool? isFormValid,
    required String eventName,
    required String eventType,
    required List<int> eventCategory,
    required String eventDescription,
    required String eventFormat,
    required String eventBanner,
  }) = _EventPage1State;

  factory EventPage1State.initial() => EventPage1State(
        status: EventPage1StateStatus.initial,
        failure: Failure.empty(),
        eventCategoryOptions: const [],
        isFormValid: null,
        eventName: '',
        eventType: '',
        eventCategory: const [],
        eventDescription: '',
        eventFormat: '',
        eventBanner: '',
      );
}
