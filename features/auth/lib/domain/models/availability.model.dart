// availability.model.dart
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability.model.freezed.dart';
part 'availability.model.g.dart';

// Helper untuk parsing DateTime (sama seperti di contoh TopicModel)
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) return DateTime(1970);
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);

  // Empty constructor (mirip dengan TopicModel.empty())
  factory AvailabilityModel.empty() => AvailabilityModel(
        id: 0,
        name: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const AvailabilityModel._();

  // Helper untuk cek apakah model kosong
  bool get isEmpty => id == 0 && name.isEmpty;
}
