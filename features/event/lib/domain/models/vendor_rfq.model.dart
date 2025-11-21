import 'package:deps/packages/freezed_annotation.dart';

part 'vendor_rfq.model.freezed.dart';
part 'vendor_rfq.model.g.dart';

@freezed
class VendorRFQ with _$VendorRFQ {
  const factory VendorRFQ({
    required String id,
    required String categories,
    required String vendor,
    required double budget,
    required String description,
  }) = _VendorRFQ;

  factory VendorRFQ.fromJson(Map<String, dynamic> json) =>
      _$VendorRFQFromJson(json);

  factory VendorRFQ.empty() => const VendorRFQ(
        id: '',
        categories: '',
        vendor: '',
        budget: 0,
        description: '',
      );
}
