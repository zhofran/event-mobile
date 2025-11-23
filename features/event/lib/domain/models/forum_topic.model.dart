// forum_topic.model.dart
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_topic.model.freezed.dart';
part 'forum_topic.model.g.dart';

// Helper functions untuk DateTime parsing
DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) {
    return DateTime(1970);
  }
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
sealed class ForumTopicModel with _$ForumTopicModel {
  const factory ForumTopicModel({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'author_id') required int authorId,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_avatar') String? authorAvatar,
    @JsonKey(name: 'member_count') @Default(0) int memberCount,
    @JsonKey(name: 'post_count') @Default(0) int postCount,
    @JsonKey(name: 'event_id') int? eventId,
    @JsonKey(name: 'event_name') String? eventName,
    @JsonKey(name: 'is_joined') @Default(false) bool isJoined,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _ForumTopicModel;

  factory ForumTopicModel.fromJson(Map<String, dynamic> json) =>
      _$ForumTopicModelFromJson(json);

  factory ForumTopicModel.empty() => ForumTopicModel(
        id: 0,
        title: '',
        description: '',
        authorId: 0,
        authorName: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const ForumTopicModel._();

  bool get isEmpty => id == 0 && title.isEmpty;
  
  bool get hasEvent => eventId != null && eventName != null;
  
  String get eventSource => hasEvent ? 'From $eventName' : '';
}