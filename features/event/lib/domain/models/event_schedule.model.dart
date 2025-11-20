import 'package:deps/packages/freezed_annotation.dart';

part 'event_schedule.model.freezed.dart';
part 'event_schedule.model.g.dart';

@freezed
sealed class EventSchedule with _$EventSchedule {
  factory EventSchedule({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'event_time') required DateTime eventTime,
    @JsonKey(name: 'venue') required String? venue,
    @JsonKey(name: 'address') required String? address,
    @JsonKey(name: 'location') required String? location,
    @JsonKey(name: 'country') required String? country,
    @JsonKey(name: 'city_id') required int? cityId,
    @JsonKey(name: 'latitude') required double? latitude,
    @JsonKey(name: 'longitude') required double? longitude,
    @JsonKey(name: 'price') required double price,
    @JsonKey(name: 'capacity') required int capacity,
    @JsonKey(name: 'platform') required String? platform,
    @JsonKey(name: 'link') required String? link,
  }) = _EventSchedule;

  const EventSchedule._();

  factory EventSchedule.fromJson(Map<String, dynamic> json) =>
      _$EventScheduleFromJson(json);

  factory EventSchedule.empty() => EventSchedule(
        id: '',
        eventTime: DateTime.now(),
        venue: '',
        address: null,
        location: null,
        country: '',
        cityId: null,
        latitude: null,
        longitude: null,
        price: 0,
        capacity: 0,
        platform: null,
        link: null,
      );
}
