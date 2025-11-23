import 'package:deps/packages/freezed_annotation.dart';

part 'sponsor.model.freezed.dart';
part 'sponsor.model.g.dart';

@freezed
class Sponsor with _$Sponsor {
  factory Sponsor({
    required String id,
    required String name,
    required String industry,
    required String location,
    required String type,
    required String description,
    String? logo,
  }) = _Sponsor;

  const Sponsor._();

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);

  factory Sponsor.empty() => Sponsor(
        id: '',
        name: '',
        industry: '',
        location: '',
        type: '',
        description: '',
        logo: null,
      );
}
