part of '../budget_planner.cubit.dart';

enum BudgetPlannerStateStatus {
  initial,
  loading,
  failed,
  succeeded,
  loadingPost
}

@freezed
sealed class BudgetPlannerState with _$BudgetPlannerState {
  const factory BudgetPlannerState({
    required BudgetPlannerStateStatus status,
    required Failure failure,
    required bool? isFormValid,
    required int venueBudget,
    required int speakerFees,
    required int vendorBudget,
    required int ticketSales,
    required int sponsorshipIncome,
    required int totalExpenses,
    required int totalIncome,
    required int netBudget,
  }) = _BudgetPlannerState;

  factory BudgetPlannerState.initial() => BudgetPlannerState(
        status: BudgetPlannerStateStatus.initial,
        failure: Failure.empty(),
        isFormValid: null,
        venueBudget: 0,
        speakerFees: 0,
        vendorBudget: 0,
        ticketSales: 0,
        sponsorshipIncome: 0,
        totalExpenses: 0,
        totalIncome: 0,
        netBudget: 0,
      );
}
