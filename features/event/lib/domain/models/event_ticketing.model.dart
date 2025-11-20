import 'package:deps/packages/freezed_annotation.dart';

part 'event_ticketing.model.freezed.dart';
part 'event_ticketing.model.g.dart';

@freezed
sealed class EventTicketing with _$EventTicketing {
  factory EventTicketing({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'ticket_start_date') required DateTime ticketStartDate,
    @JsonKey(name: 'ticket_end_date') required DateTime ticketEndDate,
  }) = _EventTicketing;

  const EventTicketing._();

  factory EventTicketing.fromJson(Map<String, dynamic> json) =>
      _$EventTicketingFromJson(json);

  factory EventTicketing.empty() => EventTicketing(
        id: '',
        ticketStartDate: DateTime.now(),
        ticketEndDate: DateTime.now(),
      );
}
