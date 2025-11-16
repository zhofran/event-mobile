part of '../event_page2.cubit.dart';

enum EventPage2StateStatus { initial, loading, failed, succeeded }

enum EventFormat { online, offline }

@freezed
sealed class EventPage2State with _$EventPage2State {
  const factory EventPage2State({
    required EventPage2StateStatus status,
    required Failure failure,
    required bool? isFormValid,
    required EventFormat eventFormat,
    // Common fields
    required DateTime date,
    required String time,
    required double price,
    required int capacity,
    // Online-specific fields
    String? platform,
    String? link,
    // Offline-specific fields
    String? venue,
    String? address,
    String? location,
  }) = _EventPage2State;

  factory EventPage2State.initial() => EventPage2State(
        status: EventPage2StateStatus.initial,
        failure: Failure.empty(),
        isFormValid: null,
        eventFormat: EventFormat.online,
        date: DateTime.now(),
        time: '00:00',
        price: 0.0,
        capacity: 0,
        platform: null,
        link: null,
        venue: null,
        address: null,
        location: null,
      );
}

/// Extension methods for EventPage2State
extension EventPage2StateX on EventPage2State {
  /// Check if event is online
  bool get isOnline => eventFormat == EventFormat.online;

  /// Check if event is offline
  bool get isOffline => eventFormat == EventFormat.offline;

  /// Get online-specific data (returns null if not online)
  ({String platform, String link})? get onlineDataOrNull {
    if (!isOnline) {
      return null;
    }
    return (
      platform: platform ?? '',
      link: link ?? '',
    );
  }

  /// Get offline-specific data (returns null if not offline)
  ({String venue, String address, String location})? get offlineDataOrNull {
    if (!isOffline) {
      return null;
    }
    return (
      venue: venue ?? '',
      address: address ?? '',
      location: location ?? '',
    );
  }

  /// Validate if all required fields are filled based on event format
  bool get hasAllRequiredFields {
    if (isOnline) {
      return platform != null &&
          platform!.isNotEmpty &&
          link != null &&
          link!.isNotEmpty &&
          capacity > 0;
    } else {
      return venue != null &&
          venue!.isNotEmpty &&
          address != null &&
          address!.isNotEmpty &&
          capacity > 0;
    }
  }
}
