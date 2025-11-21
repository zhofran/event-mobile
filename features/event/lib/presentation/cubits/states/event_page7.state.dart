part of '../event_page7.cubit.dart';

enum EventPage7StateStatus {
  initial,
  succeeded,
  failed,
}

@freezed
class EventPage7State with _$EventPage7State {
  const factory EventPage7State({
    required EventPage7StateStatus status,
    required double sponsorshipGoal,
    required List<Sponsorship> sponsorships,
    String? failure,
  }) = _EventPage7State;

  factory EventPage7State.initial() => const EventPage7State(
        status: EventPage7StateStatus.initial,
        sponsorshipGoal: 0,
        sponsorships: [],
      );
}

extension EventPage7StateX on EventPage7State {
  /// Calculate total sponsorship income
  double get totalSponsorshipIncome {
    double total = 0;
    for (var sponsor in sponsorships) {
      final amount = _parseAmount(sponsor.productAmount);
      total += amount;
    }
    return total;
  }

  /// Get number of sponsor slots
  int get sponsorSlots => sponsorships.length;

  /// Check if income is below target
  bool get isIncomeBelowTarget => totalSponsorshipIncome < sponsorshipGoal;

  /// Get shortfall amount
  double get shortfallAmount => sponsorshipGoal - totalSponsorshipIncome;

  /// Parse amount string to double
  double _parseAmount(String amountStr) {
    return double.tryParse(
          amountStr
              .replaceAll('.', '')
              .replaceAll(',', '')
              .replaceAll('Rp', '')
              .trim(),
        ) ??
        0;
  }
}
