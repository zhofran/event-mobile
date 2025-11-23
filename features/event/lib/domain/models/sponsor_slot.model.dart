import 'package:deps/packages/freezed_annotation.dart';

part 'sponsor_slot.model.freezed.dart';
part 'sponsor_slot.model.g.dart';

@freezed
sealed class SponsorSlot with _$SponsorSlot {
  const factory SponsorSlot({
    required String id,
    @JsonKey(name: 'event_id') required String eventId,
    @JsonKey(name: 'sponsor_title') required String sponsorTitle,
    @JsonKey(name: 'sponsor_type') required String sponsorType,
    @JsonKey(name: 'requested_product') required String requestedProduct,
    @JsonKey(name: 'product_amount') required double productAmount,
    @JsonKey(name: 'requested_amount') required double requestedAmount,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SponsorSlot;

  const SponsorSlot._();

  factory SponsorSlot.fromJson(Map<String, dynamic> json) =>
      _$SponsorSlotFromJson(json);

  factory SponsorSlot.empty() => SponsorSlot(
        id: '',
        eventId: '',
        sponsorTitle: '',
        sponsorType: '',
        requestedProduct: '',
        productAmount: 0,
        requestedAmount: 0,
        description: '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
}
