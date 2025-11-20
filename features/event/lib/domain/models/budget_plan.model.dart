import 'package:deps/packages/freezed_annotation.dart';

part 'budget_plan.model.freezed.dart';
part 'budget_plan.model.g.dart';

@freezed
sealed class BudgetPlan with _$BudgetPlan {
  factory BudgetPlan({
    required String id,
    @JsonKey(name: 'venue_budget') required int venueBudget,
    @JsonKey(name: 'speaker_fee') required int speakerFee,
    @JsonKey(name: 'vendor_budget') required int vendorBudget,
    @JsonKey(name: 'ticket_sales') required int ticketSales,
    @JsonKey(name: 'sponsorship_income') required int sponsorshipIncome,
  }) = _BudgetPlan;

  const BudgetPlan._();

  factory BudgetPlan.fromJson(Map<String, dynamic> json) =>
      _$BudgetPlanFromJson(json);

  factory BudgetPlan.empty() => BudgetPlan(
        id: '',
        venueBudget: 0,
        speakerFee: 0,
        vendorBudget: 0,
        ticketSales: 0,
        sponsorshipIncome: 0,
      );
}
