// location_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.model.freezed.dart';
part 'country.model.g.dart';

@freezed
class CountryModel with _$CountryModel {
  const factory CountryModel({
    required String country,
    required String code,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  const CountryModel._();
}