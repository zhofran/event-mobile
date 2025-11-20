part of '../event_page5.cubit.dart';

enum EventPage5StateStatus { initial, loading, failed, succeeded }

@freezed
sealed class EventPage5State with _$EventPage5State {
  const factory EventPage5State({
    required EventPage5StateStatus status,
    required Failure failure,
    required List<Speaker> allSpeakers,
    required List<String> selectedSpeakers,
    required List<Speaker> invitedSpeakers,
  }) = _EventPage5State;

  factory EventPage5State.initial() => EventPage5State(
        status: EventPage5StateStatus.initial,
        failure: Failure.empty(),
        allSpeakers: [],
        selectedSpeakers: [],
        invitedSpeakers: [],
      );
}
