import 'package:deps/packages/freezed_annotation.dart';

part 'sponsorship.model.freezed.dart';
part 'sponsorship.model.g.dart';

@freezed
class Sponsorship with _$Sponsorship {
  const factory Sponsorship({
    required String id,
    required String title,
    required String type,
    required String requestedProduct,
    required String productAmount,
    required String description,
  }) = _Sponsorship;

  factory Sponsorship.fromJson(Map<String, dynamic> json) =>
      _$SponsorshipFromJson(json);

  factory Sponsorship.empty() => const Sponsorship(
        id: '',
        title: '',
        type: '',
        requestedProduct: '',
        productAmount: '',
        description: '',
      );
}
