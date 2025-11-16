part of '../event_page3.cubit.dart';

enum EventPage3StateStatus { initial, loading, failed, succeeded }

@freezed
sealed class EventPage3State with _$EventPage3State {
  const factory EventPage3State({
    required EventPage3StateStatus status,
    required Failure failure,
    required List<SeatPlan> seatPlans,
    required int capacity,
    required double ticketSalesTarget,
  }) = _EventPage3State;

  factory EventPage3State.initial() => EventPage3State(
        status: EventPage3StateStatus.initial,
        failure: Failure.empty(),
        seatPlans: const [],
        capacity: 0,
        ticketSalesTarget: 0.0,
      );
}

/// Extension methods for EventPage3State
extension EventPage3StateX on EventPage3State {
  /// Calculate total seats that are already used
  int get totalUsedSeats {
    return seatPlans.fold<int>(
      0,
      (total, plan) => total + plan.quota,
    );
  }

  /// Calculate remaining seats available
  int get remainingSeats => capacity - totalUsedSeats;

  /// Calculate total ticket income from all seat plans
  double get totalTicketIncome {
    return seatPlans.fold<double>(
      0.0,
      (total, plan) => total + (plan.price * plan.quota),
    );
  }

  /// Calculate shortfall from ticket sales target
  double get shortfall => ticketSalesTarget - totalTicketIncome;

  /// Check if ticket income meets or exceeds target
  bool get meetsTarget => totalTicketIncome >= ticketSalesTarget;

  /// Check if capacity is fully allocated
  bool get isFullyAllocated => remainingSeats == 0;
}

@freezed
class SeatPlan with _$SeatPlan {
  const factory SeatPlan({
    required String id,
    required String ticketName,
    required String ticketType,
    required double price,
    required int quota,
    required String description,
  }) = _SeatPlan;

  factory SeatPlan.empty() => const SeatPlan(
        id: '',
        ticketName: '',
        ticketType: 'Regular',
        price: 0.0,
        quota: 0,
        description: '',
      );

  // factory SeatPlan.fromJson(Map<String, dynamic> json) =>
  //     _$SeatPlanFromJson(json);
}
