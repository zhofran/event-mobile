import 'package:deps/packages/freezed_annotation.dart';

part 'transportation_option.model.freezed.dart';
part 'transportation_option.model.g.dart';

@freezed
class TransportationOption with _$TransportationOption {
  factory TransportationOption({
    required String id,
    required String name,
    required int price,
    required String route,
    required String datetime,
    @Default(false) bool isSelected,
  }) = _TransportationOption;

  factory TransportationOption.fromJson(Map<String, dynamic> json) =>
      _$TransportationOptionFromJson(json);
}