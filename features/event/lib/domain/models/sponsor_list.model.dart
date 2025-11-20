import 'package:deps/packages/freezed_annotation.dart';

import 'speaker.model.dart';
import 'sponsor.model.dart';
import 'sponsor_slot.model.dart';

part 'sponsor_list.model.freezed.dart';
part 'sponsor_list.model.g.dart';

@freezed
sealed class SponsorList with _$SponsorList {
  factory SponsorList({
    required String id,
    required List<SponsorSlot> sponsorsSlot,
    required List<Sponsor> sponsors,
  }) = _SponsorList;

  const SponsorList._();

  factory SponsorList.fromJson(Map<String, dynamic> json) =>
      _$SponsorListFromJson(json);

  factory SponsorList.empty() => SponsorList(
        id: '',
        sponsorsSlot: [],
        sponsors: []
      );
}
