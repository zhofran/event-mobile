// comment.model.dart
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_comment.model.freezed.dart';
part 'forum_comment.model.g.dart';

DateTime _dateFromJson(String? date) {
  if (date == null || date.isEmpty) {
    return DateTime(1970);
  }
  return DateTime.parse(date);
}

String _dateToJson(DateTime date) => date.toIso8601String();

@freezed
sealed class ForumCommentModel with _$ForumCommentModel {
  const factory ForumCommentModel({
    required int id,
    @JsonKey(name: 'post_id') required int postId,
    @JsonKey(name: 'parent_id') int? parentId,
    required String content,
    @JsonKey(name: 'author_id') required int authorId,
    @JsonKey(name: 'author_name') required String authorName,
    @JsonKey(name: 'author_avatar') String? authorAvatar,
    @JsonKey(name: 'author_role') String? authorRole,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'dislike_count') @Default(0) int dislikeCount,
    @JsonKey(name: 'reply_count') @Default(0) int replyCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'is_disliked') @Default(false) bool isDisliked,
    @JsonKey(name: 'replies') @Default([]) List<ForumCommentModel> replies,
    @JsonKey(name: 'created_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime updatedAt,
  }) = _ForumCommentModel;

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ForumCommentModelFromJson(json);

  factory ForumCommentModel.empty() => ForumCommentModel(
        id: 0,
        postId: 0,
        content: '',
        authorId: 0,
        authorName: '',
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      );

  const ForumCommentModel._();

  bool get isEmpty => id == 0 && content.isEmpty;
  
  bool get isReply => parentId != null;
  
  bool get hasReplies => replies.isNotEmpty;
  
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

// Example JSON responses for testing:

/*
// Forum Topic JSON Response
{
  "id": 1,
  "title": "Smart Mining Innovations",
  "description": "Discuss breakthroughs in AI, automation, and digital transformation.",
  "author_id": 123,
  "author_name": "Dr. Rina Putri, M.Ed",
  "author_avatar": "https://example.com/avatar.jpg",
  "member_count": 25,
  "post_count": 48,
  "event_id": 456,
  "event_name": "Mining Tech Summit 2025",
  "is_joined": true,
  "category": "Technology",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-20T15:45:00Z"
}

// Forum Post JSON Response
{
  "id": 1,
  "topic_id": 1,
  "title": "Share your favorite part of Mining Summit 2025",
  "content": "Thanks everyone for joining my session! Feel free to ask any questions about AI tools for event management.",
  "author_id": 123,
  "author_name": "Dr. Rina Putri, M.Ed",
  "author_avatar": "https://example.com/avatar.jpg",
  "author_role": "Education Technology Specialist",
  "like_count": 15,
  "dislike_count": 0,
  "comment_count": 12,
  "is_liked": false,
  "is_disliked": false,
  "is_bookmarked": true,
  "attachments": [
    {
      "id": 1,
      "file_name": "presentation.pdf",
      "file_url": "https://example.com/files/presentation.pdf",
      "file_type": "application/pdf",
      "file_size": 2048000
    }
  ],
  "created_at": "2025-01-18T09:00:00Z",
  "updated_at": "2025-01-18T09:00:00Z"
}

// Comment JSON Response
{
  "id": 1,
  "post_id": 1,
  "parent_id": null,
  "content": "I loved your demo, Arya! Which platform would you recommend for automating sponsor matching?",
  "author_id": 456,
  "author_name": "John Doe",
  "author_avatar": "https://example.com/avatar2.jpg",
  "author_role": "Event Organizer",
  "like_count": 5,
  "dislike_count": 0,
  "reply_count": 3,
  "is_liked": true,
  "is_disliked": false,
  "replies": [
    {
      "id": 2,
      "post_id": 1,
      "parent_id": 1,
      "content": "Thanks! I recommend using EventHub Pro for sponsor matching.",
      "author_id": 123,
      "author_name": "Dr. Rina Putri, M.Ed",
      "author_avatar": "https://example.com/avatar.jpg",
      "author_role": "Education Technology Specialist",
      "like_count": 2,
      "dislike_count": 0,
      "reply_count": 0,
      "is_liked": false,
      "is_disliked": false,
      "replies": [],
      "created_at": "2025-01-18T10:30:00Z",
      "updated_at": "2025-01-18T10:30:00Z"
    }
  ],
  "created_at": "2025-01-18T10:00:00Z",
  "updated_at": "2025-01-18T10:00:00Z"
}
*/

// Usage Examples:

/*
// 1. Parsing from JSON
final forumTopicJson = await api.getForumTopic(id);
final forumTopic = ForumTopicModel.fromJson(forumTopicJson);

// 2. Creating empty model
final emptyTopic = ForumTopicModel.empty();
if (emptyTopic.isEmpty) {
  print('No topic data');
}

// 3. Using computed properties
print(forumTopic.eventSource); // "From Mining Tech Summit 2025"
print(forumPost.formattedDate); // "2d ago" or "15 Jan 2025"
print(comment.hasReplies); // true/false

// 4. Converting to JSON
final json = forumPost.toJson();
await api.updatePost(json);

// 5. CopyWith for updates
final updatedPost = forumPost.copyWith(
  likeCount: forumPost.likeCount + 1,
  isLiked: true,
);

// 6. Working with collections
final topics = (jsonList as List)
    .map((json) => ForumTopicModel.fromJson(json))
    .where((topic) => !topic.isEmpty)
    .toList();

// 7. Nested comment replies
if (comment.hasReplies) {
  for (final reply in comment.replies) {
    print('Reply: ${reply.content}');
  }
}
*/