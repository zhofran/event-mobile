import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

part 'event_page2.cubit.freezed.dart';
part 'states/event_page2.state.dart';

@lazySingleton
class EventPage2Cubit extends Cubit<EventPage2State> {
  EventPage2Cubit(this._client) : super(EventPage2State.initial());

  final INetworkClient _client;

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
