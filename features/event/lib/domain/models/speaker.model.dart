
import 'package:deps/packages/freezed_annotation.dart';

part 'speaker.model.freezed.dart';
part 'speaker.model.g.dart';

@freezed
class Speaker with _$Speaker {
  factory Speaker({
    required String id,
    @JsonKey(name: 'speaker_user_id') required String speakerUserId,
    @JsonKey(name: 'speaker_name') required String speakerName,
    required String email,
    required String phone,
    required String organization,
    required String bio,
    required String photo,
    @JsonKey(name: 'speaker_fee') required double speakerFee,
    required String status,

    // 🔥 new fields
    required String name,
    required String title,
    required String location,
    required String specialize,
    @JsonKey(name: 'total_event') required int totalEvent,
    required double fee,
  }) = _Speaker;

  const Speaker._();

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);

  factory Speaker.empty() => Speaker(
        id: '',
        speakerUserId: '',
        speakerName: '',
        email: '',
        phone: '',
        organization: '',
        bio: '',
        photo: '',
        speakerFee: 0,
        status: '',
        name: '',
        title: '',
        location: '',
        specialize: '',
        totalEvent: 0,
        fee: 0,
      );
}
