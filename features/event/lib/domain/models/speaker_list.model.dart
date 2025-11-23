import 'package:deps/packages/freezed_annotation.dart';

// import 'speaker.model.dart';

part 'speaker_list.model.freezed.dart';
part 'speaker_list.model.g.dart';

@freezed
sealed class SpeakerList with _$SpeakerList {
  factory SpeakerList({
    required String id,
    // required List<Speaker> speakers,
  }) = _SpeakerList;

  const SpeakerList._();

  factory SpeakerList.fromJson(Map<String, dynamic> json) =>
      _$SpeakerListFromJson(json);

  factory SpeakerList.empty() => SpeakerList(
        id: '',
        // speakers: [],
      );
}
