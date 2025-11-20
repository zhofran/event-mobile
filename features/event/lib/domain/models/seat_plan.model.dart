import 'package:deps/packages/freezed_annotation.dart';

part 'seat_plan.model.freezed.dart';
part 'seat_plan.model.g.dart';

@freezed
sealed class SeatPlan with _$SeatPlan {
  factory SeatPlan({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'ticket_name') required String ticketName,
    @JsonKey(name: 'ticket_type') required String ticketType,
    @JsonKey(name: 'price') required double price,
    @JsonKey(name: 'quota') required int quota,
    @JsonKey(name: 'sold') required int sold,
    @JsonKey(name: 'description') String? description,
  }) = _SeatPlan;

  const SeatPlan._();

  factory SeatPlan.fromJson(Map<String, dynamic> json) =>
      _$SeatPlanFromJson(json);

  factory SeatPlan.empty() => SeatPlan(
        id: '',
        ticketName: '',
        ticketType: '',
        price: 0,
        quota: 0,
        sold: 0,
        description: null,
      );
}
