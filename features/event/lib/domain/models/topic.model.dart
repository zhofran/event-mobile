import 'package:deps/packages/freezed_annotation.dart';

part 'topic.model.freezed.dart';
part 'topic.model.g.dart';

@freezed
sealed class Topic with _$Topic {
  factory Topic({
    required int id,
    required String name,
  }) = _Topic;

  const Topic._();

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  factory Topic.empty() => Topic(
        id: 0,
        name: '',
      );
}
