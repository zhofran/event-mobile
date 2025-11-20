import 'package:deps/packages/freezed_annotation.dart';

part 'sponsor.model.freezed.dart';
part 'sponsor.model.g.dart';

@freezed
class Sponsor with _$Sponsor {
  factory Sponsor({
    required String id,
    @JsonKey(name: 'event_id') required String eventId,
    required String name,
    String? description,
    @JsonKey(name: 'city_id') int? cityId,
    required String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Sponsor;

  const Sponsor._();

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);

  factory Sponsor.empty() => Sponsor(
        id: '',
        eventId: '',
        name: '',
        description: '',
        cityId: null,
        status: '',
        createdAt: null,
      );
}
