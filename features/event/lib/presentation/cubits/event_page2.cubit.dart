import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/event_schedule.model.dart';

part 'event_page2.cubit.freezed.dart';
part 'states/event_page2.state.dart';

@lazySingleton
class EventPage2Cubit extends Cubit<EventPage2State> {
  EventPage2Cubit() : super(EventPage2State.initial());

  void toggleValidityForm({required bool? value}) {
    emit(state.copyWith(isFormValid: value));
  }

  void createScheduleVenueOnline({
    required DateTime date,
    required String time,
    required String platform,
    required String link,
    required int price,
    required int capacity,
  }) {
    // Validate that required online fields are not empty
    assert(platform.isNotEmpty, 'Platform is required for online events');
    assert(link.isNotEmpty, 'Link is required for online events');

    emit(
      state.copyWith(
        status: state.status,
        failure: state.failure,
        isFormValid: state.isFormValid,
        eventFormat: EventFormat.online,
        date: date,
        time: time,
        platform: platform,
        link: link,
        price: price.toDouble(),
        capacity: capacity,
        // Clear offline fields
        venue: null,
        address: null,
        location: null,
      ),
    );
  }

  void createScheduleVenueOffline({
    required DateTime date,
    required String time,
    required String venue,
    required String address,
    required String location,
    required int price,
    required int capacity,
  }) {
    // Validate that required offline fields are not empty
    assert(venue.isNotEmpty, 'Venue is required for offline events');
    assert(address.isNotEmpty, 'Address is required for offline events');

    emit(
      state.copyWith(
        status: state.status,
        failure: state.failure,
        isFormValid: state.isFormValid,
        eventFormat: EventFormat.offline,
        date: date,
        time: time,
        venue: venue,
        address: address,
        location: location,
        price: price.toDouble(),
        capacity: capacity,
        // Clear online fields
        platform: null,
        link: null,
      ),
    );
  }

  Future<void> saveEventScheduleLocally({required bool isOnline}) async {
    final prefs = $.get<SharedPreferencesManager>();

    EventSchedule? schedule;
    if (isOnline) {
      schedule = EventSchedule(
        id: 'scheduleId-online',
        eventTime: state.date,
        platform: state.platform,
        link: state.link,
        price: state.price,
        capacity: state.capacity,
        // Clear offline fields
        cityId: null,
        latitude: null,
        longitude: null,
        venue: null,
        address: null,
        location: null,
        country: null,
      );
    } else {
      schedule = EventSchedule(
        id: 'scheduleId-offline',
        eventTime: state.date.addTime(state.time),
        price: state.price,
        capacity: state.capacity,
        cityId: 1,
        latitude: 2,
        longitude: 3,
        venue: 'venue name',
        address: 'address here',
        location: 'location here',
        country: 'country name',
        // Clear online fields
        platform: null,
        link: null,
      );
    }

    await prefs.writeObject<EventSchedule>(
      EventKey.eventSchedule.name,
      schedule,
    );
  }

  Future<EventSchedule?> loadEventScheduleLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final eventSchedule = prefs.readObject<EventSchedule>(
      EventKey.eventSchedule.name,
      EventSchedule.fromJson,
    );

    if (eventSchedule != null) {
      emit(
        state.copyWith(
          eventFormat:
              eventSchedule.platform != null && eventSchedule.link != null
                  ? EventFormat.online
                  : EventFormat.offline,
          date: eventSchedule.eventTime,
          time:
              '${eventSchedule.eventTime.hour.toString().padLeft(2, '0')}:${eventSchedule.eventTime.minute.toString().padLeft(2, '0')}',
          venue: eventSchedule.venue,
          address: eventSchedule.address,
          location: eventSchedule.location,
          platform: eventSchedule.platform,
          link: eventSchedule.link,
          price: eventSchedule.price,
          capacity: eventSchedule.capacity,
        ),
      );
    }

    return eventSchedule;
  }

  /// Get online-specific data (throws if format is not online)
  ({String platform, String link}) get onlineData {
    assert(
      state.isOnline,
      'Cannot access online data when event format is offline',
    );
    return (
      platform: state.platform ?? '',
      link: state.link ?? '',
    );
  }

  /// Get offline-specific data (throws if format is not offline)
  ({String venue, String address, String location}) get offlineData {
    assert(
      state.isOffline,
      'Cannot access offline data when event format is online',
    );
    return (
      venue: state.venue ?? '',
      address: state.address ?? '',
      location: state.location ?? '',
    );
  }
}
