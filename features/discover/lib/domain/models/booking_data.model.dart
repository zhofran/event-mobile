import 'package:deps/packages/freezed_annotation.dart';

import 'booking_event.model.dart';
import 'hotel_option.model.dart';
import 'ticket_type.model.dart';
import 'transportation_option.model.dart';

part 'booking_data.model.freezed.dart';
part 'booking_data.model.g.dart';

@freezed
class BookingData with _$BookingData {
  factory BookingData({
    required BookingEventModel event,
    TicketType? selectedTicket,
    HotelOption? selectedHotel,
    TransportationOption? selectedTransportation,
    @Default(false) bool isTravelPackEnabled,
  }) = _BookingData;

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  const BookingData._();

  int get totalPayment {
    int total = selectedTicket?.price ?? 0;
    if (isTravelPackEnabled) {
      total += selectedHotel?.price ?? 0;
      total += selectedTransportation?.price ?? 0;
    }
    return total;
  }

  String get formattedTotalPayment {
    return _formatCurrency(totalPayment);
  }

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
