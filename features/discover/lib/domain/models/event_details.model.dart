import 'package:deps/packages/freezed_annotation.dart';

part 'event_details.model.freezed.dart';
part 'event_details.model.g.dart';

@freezed
class EventDetails with _$EventDetails {
  factory EventDetails({
    required String id,
    required String title,
    required String dateRange,
    required String time,
  }) = _EventDetails;

  factory EventDetails.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsFromJson(json);
}