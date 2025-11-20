import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/seat_plan.model.dart';

part 'event_page3.cubit.freezed.dart';
part 'states/event_page3.state.dart';

@lazySingleton
class EventPage3Cubit extends Cubit<EventPage3State> {
  EventPage3Cubit() : super(EventPage3State.initial());

  // final _uuid = const Uuid();

  /// Initialize cubit with capacity and ticket sales target
  void initialize({
    required int capacity,
    required double ticketSalesTarget,
  }) {
    emit(
      state.copyWith(
        capacity: capacity,
        ticketSalesTarget: ticketSalesTarget,
      ),
    );
  }

  Future<void> byPass() async {
    final seatPlans = <SeatPlan>[
      SeatPlan(
        id: '1763304381145',
        ticketName: 'pow',
        ticketType: 'Regular',
        price: 5000.0,
        quota: 2000,
        description: 'asdsad',
        sold: 0,
      ),
      SeatPlan(
        id: '1763304519406',
        ticketName: 'low',
        ticketType: 'Premium',
        price: 8000.0,
        quota: 1000,
        description: 'asodkosad',
        sold: 0,
      ),
      SeatPlan(
        id: '1763304543567',
        ticketName: 'pass',
        ticketType: 'VVIP',
        price: 15000.0,
        quota: 150,
        description: 'asdlsakd',
        sold: 0,
      ),
    ];

    emit(state.copyWith(seatPlans: seatPlans));

    await saveSeatPlansLocally();
  }

  /// Add a new seat plan
  void addSeatPlan({
    required String ticketName,
    required String ticketType,
    required double price,
    required int quota,
    required String description,
  }) {
    // Validate quota doesn't exceed remaining seats
    if (quota > state.remainingSeats) {
      emit(
        state.copyWith(
          status: EventPage3StateStatus.failed,
          failure: Failure(
            type: FailureType.constructive,
            tag: FailureTag.state,
            code: 'QUOTA_EXCEEDED',
            message: 'Quota exceeds remaining seats',
          ),
        ),
      );
      return;
    }

    final newPlan = SeatPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ticketName: ticketName,
      ticketType: ticketType,
      price: price,
      quota: quota,
      description: description,
      sold: 0,
    );

    final updatedPlans = List<SeatPlan>.from(state.seatPlans)..add(newPlan);

    emit(
      state.copyWith(
        seatPlans: updatedPlans,
        status: EventPage3StateStatus.succeeded,
      ),
    );
  }

  /// Update an existing seat plan
  void updateSeatPlan({
    required String id,
    required String ticketName,
    required String ticketType,
    required double price,
    required int quota,
    required String description,
  }) {
    // Find the existing plan to calculate available seats
    final existingPlan = state.seatPlans.firstWhere((plan) => plan.id == id);
    final availableSeats = state.remainingSeats + existingPlan.quota;

    // Validate quota doesn't exceed available seats
    if (quota > availableSeats) {
      emit(
        state.copyWith(
          status: EventPage3StateStatus.failed,
          failure: Failure(
            type: FailureType.constructive,
            tag: FailureTag.state,
            code: 'QUOTA_EXCEEDED',
            message: 'Quota exceeds available seats',
          ),
        ),
      );
      return;
    }

    final updatedPlan = SeatPlan(
      id: id,
      ticketName: ticketName,
      ticketType: ticketType,
      price: price,
      quota: quota,
      description: description,
      sold: 0,
    );

    final updatedPlans = state.seatPlans.map((plan) {
      return plan.id == id ? updatedPlan : plan;
    }).toList();

    emit(
      state.copyWith(
        seatPlans: updatedPlans,
        status: EventPage3StateStatus.succeeded,
      ),
    );
  }

  /// Remove a seat plan
  void removeSeatPlan(String id) {
    final updatedPlans =
        state.seatPlans.where((plan) => plan.id != id).toList();

    emit(
      state.copyWith(
        seatPlans: updatedPlans,
        status: EventPage3StateStatus.succeeded,
      ),
    );
  }

  Future<void> saveSeatPlansLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeObjectList<SeatPlan>(
      EventKey.seatPlans.name,
      state.seatPlans,
    );
  }

  Future<List<SeatPlan>?> loadSeatPlansLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final seatPlans = prefs.readObjectList<SeatPlan>(
      EventKey.seatPlans.name,
      SeatPlan.fromJson,
    );

    if (seatPlans != null) {
      emit(
        state.copyWith(
          seatPlans: seatPlans,
        ),
      );
    }

    return seatPlans;
  }

  /// Calculate percentage of seats for a given quota
  double getSeatsPercentage(int quota) {
    if (state.capacity == 0) return 0;
    return (quota / state.capacity) * 100;
  }

  /// Clear all seat plans
  void clearAllSeatPlans() {
    emit(
      state.copyWith(
        seatPlans: [],
        status: EventPage3StateStatus.initial,
      ),
    );
  }

  /// Reset state
  void reset() {
    emit(EventPage3State.initial());
  }
}
