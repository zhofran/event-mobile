// honorarium_preference.model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'honorarium_preference.model.freezed.dart';
part 'honorarium_preference.model.g.dart';

// Helper DateTime (sama persis seperti yang kamu pakai sebelumnya)
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) return DateTime(1970);
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
class HonorariumPreferenceModel with _$HonorariumPreferenceModel {
  const factory HonorariumPreferenceModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _HonorariumPreferenceModel;

  factory HonorariumPreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$HonorariumPreferenceModelFromJson(json);

  // Empty state (sama seperti semua model sebelumnya)
  factory HonorariumPreferenceModel.empty() => HonorariumPreferenceModel(
        id: 0,
        name: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const HonorariumPreferenceModel._();

  bool get isEmpty => id == 0 && name.isEmpty;
}