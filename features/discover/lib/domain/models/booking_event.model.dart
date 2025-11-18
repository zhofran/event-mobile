import 'package:deps/packages/freezed_annotation.dart';

import 'discover_event.model.dart';

part 'booking_event.model.freezed.dart';
part 'booking_event.model.g.dart';

@freezed
class BookingEventModel with _$BookingEventModel {
  factory BookingEventModel({
    required int id,
    required String title,
    required String imageUrl,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String time,
    required int basePrice,
    String? badge,
    required String category,
  }) = _BookingEventModel;

  factory BookingEventModel.fromJson(Map<String, dynamic> json) =>
      _$BookingEventModelFromJson(json);

  factory BookingEventModel.fromDiscoverEvent(DiscoverEventModel event) {
    return BookingEventModel(
      id: event.id,
      title: event.title,
      imageUrl: event.imageUrl,
      location: event.location,
      startDate: event.startDate,
      endDate: event.endDate,
      time: "07.00 WIB", // Default time
      basePrice: event.priceStart,
      badge: event.badge,
      category: event.category,
    );
  }
}