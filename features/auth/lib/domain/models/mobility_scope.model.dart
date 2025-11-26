// mobility_scope.model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobility_scope.model.freezed.dart';
part 'mobility_scope.model.g.dart';

// Helper DateTime (bisa dipindah ke file terpisah jika dipakai banyak model)
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) return DateTime(1970);
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
class MobilityScopeModel with _$MobilityScopeModel {
  const factory MobilityScopeModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _MobilityScopeModel;

  factory MobilityScopeModel.fromJson(Map<String, dynamic> json) =>
      _$MobilityScopeModelFromJson(json);

  // Empty factory (sama seperti TopicModel)
  factory MobilityScopeModel.empty() => MobilityScopeModel(
        id: 0,
        name: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const MobilityScopeModel._();

  bool get isEmpty => id == 0 && name.isEmpty;
}
