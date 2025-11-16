import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';
import 'package:flutter/foundation.dart';

part 'budget_planner.cubit.freezed.dart';
part 'states/budget_planner.state.dart';

@lazySingleton
class BudgetPlannerCubit extends Cubit<BudgetPlannerState> {
  BudgetPlannerCubit(this._client) : super(BudgetPlannerState.initial());

  final INetworkClient _client;

  // Toggle form validity manually
  void toggleValidityForm({required bool? value}) {
    emit(state.copyWith(isFormValid: value));
  }

  void calculateBudget({
    required int venueBudget,
    required int speakerFees,
    required int vendorBudget,
    required int ticketSales,
    required int sponsorshipIncome,
  }) {
    final totalExpenses = venueBudget + speakerFees + vendorBudget;
    final totalIncome = ticketSales + sponsorshipIncome;
    final netBudget = totalIncome - totalExpenses;

    emit(
      state.copyWith(
        venueBudget: venueBudget.toDouble(),
        speakerFees: speakerFees.toDouble(),
        vendorBudget: vendorBudget.toDouble(),
        ticketSales: ticketSales.toDouble(),
        sponsorshipIncome: sponsorshipIncome.toDouble(),
        totalExpenses: totalExpenses.toDouble(),
        totalIncome: totalIncome.toDouble(),
        netBudget: netBudget.toDouble(),
      ),
    );
  }
}
