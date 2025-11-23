// forum_post.model.dart
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_post.model.freezed.dart';
part 'forum_post.model.g.dart';

DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) {
    return DateTime(1970);
  }
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
sealed class ForumPostModel with _$ForumPostModel {
  const factory ForumPostModel({
    required int id,
    @JsonKey(name: 'topic_id') required int topicId,
    required String title,
    required String content,
    @JsonKey(name: 'author_id') required int authorId,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_avatar') String? authorAvatar,
    @JsonKey(name: 'author_role') String? authorRole,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'dislike_count') @Default(0) int dislikeCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'is_disliked') @Default(false) bool isDisliked,
    @JsonKey(name: 'is_bookmarked') @Default(false) bool isBookmarked,
    @JsonKey(name: 'attachments') @Default([]) List<PostAttachment> attachments,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _ForumPostModel;

  factory ForumPostModel.fromJson(Map<String, dynamic> json) =>
      _$ForumPostModelFromJson(json);

  factory ForumPostModel.empty() => ForumPostModel(
        id: 0,
        topicId: 0,
        title: '',
        content: '',
        authorId: 0,
        authorName: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const ForumPostModel._();

  bool get isEmpty => id == 0 && title.isEmpty && content.isEmpty;
  
  bool get hasAttachments => attachments.isNotEmpty;
  
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 30) {
      return '${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

@freezed
class PostAttachment with _$PostAttachment {
  const factory PostAttachment({
    required int id,
    required String fileName,
    required String fileUrl,
    required String fileType,
    @JsonKey(name: 'file_size') int? fileSize,
  }) = _PostAttachment;

  factory PostAttachment.fromJson(Map<String, dynamic> json) =>
      _$PostAttachmentFromJson(json);
}