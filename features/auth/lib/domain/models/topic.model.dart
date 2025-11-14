// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.model.freezed.dart';
part 'topic.model.g.dart';

// Helper functions untuk DateTime parsing
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) {
    return DateTime(1970);
  }
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
sealed class TopicModel with _$TopicModel {
  const factory TopicModel({
    required int id,
    required String name,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _TopicModel;

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  factory TopicModel.empty() => TopicModel(
    id: 0,
    name: '',
    createdAt: DateTime(1970),
    updatedAt: DateTime(1970),
  );

  const TopicModel._();

  bool get isEmpty => id == 0 && name.isEmpty;
}