part of '../event_page4.cubit.dart';

enum EventPage4StateStatus { initial, loading, failed, succeeded }

@freezed
sealed class EventPage4State with _$EventPage4State {
  const factory EventPage4State({
    required EventPage4StateStatus status,
    required Failure failure,
    required DateTime? saleStartDate,
    required String? saleStartTime,
    required DateTime? saleEndDate,
    required String? saleEndTime,
  }) = _EventPage4State;

  factory EventPage4State.initial() => EventPage4State(
        status: EventPage4StateStatus.initial,
        failure: Failure.empty(),
        saleStartDate: null,
        saleStartTime: null,
        saleEndDate: null,
        saleEndTime: null,
      );
}
