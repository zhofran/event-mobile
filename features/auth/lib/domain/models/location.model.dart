// location_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.model.freezed.dart';
part 'location.model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required int id,
    required String city,
    @JsonKey(name: 'city_ascii') required String cityAscii,
    required double latitude,
    required double longitude,
    required String country,
    required String iso2,
    required String iso3,
    @JsonKey(name: 'admin_name') required String adminName,
    String? capital,
    int? population,
    @JsonKey(name: 'location_id') String? locationId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  const LocationModel._();

  String get displayName => '$city, $adminName';
}