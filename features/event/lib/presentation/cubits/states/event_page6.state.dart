part of '../event_page6.cubit.dart';

enum EventPage6StateStatus {
  initial,
  succeeded,
  failed,
}

@freezed
class EventPage6State with _$EventPage6State {
  const factory EventPage6State({
    required EventPage6StateStatus status,
    required double maximumBudget,
    required List<VendorRFQ> vendors,
    Failure? failure,
  }) = _EventPage6State;

  factory EventPage6State.initial() => const EventPage6State(
        status: EventPage6StateStatus.initial,
        maximumBudget: 0,
        vendors: [],
      );
}

extension EventPage6StateX on EventPage6State {
  /// Calculate total vendor fee
  double get totalVendorFee {
    return vendors.fold(0.0, (sum, vendor) => sum + vendor.budget);
  }

  /// Check if budget is exceeded
  bool get isBudgetExceeded {
    return totalVendorFee > maximumBudget;
  }

  /// Get exceeded amount
  double get exceededAmount {
    final exceeded = totalVendorFee - maximumBudget;
    return exceeded > 0 ? exceeded : 0;
  }

  /// Get vendor count
  int get vendorCount {
    return vendors.length;
  }
}
