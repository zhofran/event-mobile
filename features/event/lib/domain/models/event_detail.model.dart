import 'package:deps/packages/freezed_annotation.dart';

part 'event_detail.model.freezed.dart';
part 'event_detail.model.g.dart';

@freezed
sealed class EventDetail with _$EventDetail {
  factory EventDetail({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'organizer_id') required String organizerId,
    @JsonKey(name: 'event_name') required String eventName,
    @JsonKey(name: 'event_type') required String eventType,
    @JsonKey(name: 'event_category') required List<int> eventCategory,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'event_format') required String eventFormat,
    @JsonKey(name: 'event_banner') required String eventBanner,
    @JsonKey(name: 'status') required String status,
  }) = _EventDetail;

  const EventDetail._();

  factory EventDetail.fromJson(Map<String, dynamic> json) =>
      _$EventDetailFromJson(json);

  factory EventDetail.empty() => EventDetail(
        id: '',
        organizerId: '',
        eventName: '',
        eventType: '',
        eventCategory: [],
        description: '',
        eventFormat: '',
        eventBanner: '',
        status: '',
      );
}
