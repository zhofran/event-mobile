import 'package:deps/packages/freezed_annotation.dart';

part 'ticket_type.model.freezed.dart';
part 'ticket_type.model.g.dart';

@freezed
class TicketType with _$TicketType {
  factory TicketType({
    required String id,
    required String name,
    required int price,
    required String description,
    required int seatsLeft,
    @Default(false) bool isSelected,
  }) = _TicketType;

  factory TicketType.fromJson(Map<String, dynamic> json) =>
      _$TicketTypeFromJson(json);
}