import 'package:deps/packages/freezed_annotation.dart';

part 'transportation.model.freezed.dart';
part 'transportation.model.g.dart';

@freezed
class Transportation with _$Transportation {
  factory Transportation({
    required String id,
    required String name,
    required int price,
    required String route,
    required String dates,
    required bool isSelected,
  }) = _Transportation;

  factory Transportation.fromJson(Map<String, dynamic> json) =>
      _$TransportationFromJson(json);
}