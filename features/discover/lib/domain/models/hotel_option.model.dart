import 'package:deps/packages/freezed_annotation.dart';

part 'hotel_option.model.freezed.dart';
part 'hotel_option.model.g.dart';

@freezed
class HotelOption with _$HotelOption {
  factory HotelOption({
    required String id,
    required String name,
    required int price,
    required DateTime checkIn,
    required DateTime checkOut,
    @Default(false) bool isSelected,
  }) = _HotelOption;

  factory HotelOption.fromJson(Map<String, dynamic> json) =>
      _$HotelOptionFromJson(json);
}