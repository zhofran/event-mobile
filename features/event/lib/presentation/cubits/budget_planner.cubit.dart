import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';
import 'package:flutter/foundation.dart';

import '../../data/create_event.service.dart';
import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/budget_plan.model.dart';

part 'budget_planner.cubit.freezed.dart';
part 'states/budget_planner.state.dart';

@lazySingleton
class BudgetPlannerCubit extends Cubit<BudgetPlannerState> {
  BudgetPlannerCubit() : super(BudgetPlannerState.initial());

  final createEventService = $.get<CreateEventService>();

  // Post Budget Plan
  Future<void> postBudgetPlan({required Function() callback}) async {
    emit(state.copyWith(status: BudgetPlannerStateStatus.loadingPost));

    final result = await createEventService.createBudgetPlan(
      venueBudget: state.venueBudget,
      speakerFee: state.speakerFees,
      vendorBudget: state.vendorBudget,
      ticketSales: state.ticketSales,
      sponsorshipIncome: state.sponsorshipIncome,
    );

    await result.fold(
      (failure) {
        log(failure.toString(), name: 'postBudgetPlan - err');
        emit(
          state.copyWith(status: BudgetPlannerStateStatus.failed),
        );
      },
      (response) async {
        log(response.toString(), name: 'postBudgetPlan - success');

        await saveBudgetPlanLocally();

        emit(
          state.copyWith(status: BudgetPlannerStateStatus.succeeded),
        );

        callback.call();
      },
    );
  }

  Future<void> saveBudgetPlanLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeObject<BudgetPlan>(
      EventKey.budgetPlan.name,
      BudgetPlan(
        id: '1',
        venueBudget: state.venueBudget,
        speakerFee: state.speakerFees,
        vendorBudget: state.vendorBudget,
        ticketSales: state.ticketSales,
        sponsorshipIncome: state.sponsorshipIncome,
      ),
    );
  }

  Future<BudgetPlan?> loadBudgetPlanLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final budgetPlan = prefs.readObject<BudgetPlan>(
      EventKey.budgetPlan.name,
      BudgetPlan.fromJson,
    );

    if (budgetPlan != null) {
      emit(
        state.copyWith(
          venueBudget: budgetPlan.venueBudget,
          speakerFees: budgetPlan.speakerFee,
          vendorBudget: budgetPlan.vendorBudget,
          ticketSales: budgetPlan.ticketSales,
          sponsorshipIncome: budgetPlan.sponsorshipIncome,
        ),
      );
    }

    return budgetPlan;
  }

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
        venueBudget: venueBudget,
        speakerFees: speakerFees,
        vendorBudget: vendorBudget,
        ticketSales: ticketSales,
        sponsorshipIncome: sponsorshipIncome,
        totalExpenses: totalExpenses,
        totalIncome: totalIncome,
        netBudget: netBudget,
      ),
    );
  }
}
