// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'budget_planner.form.freezed.dart';
part 'budget_planner.form.g.dart';
part 'budget_planner.form.gform.dart';

@freezed
@Rf()
class BudgetPlannerForm with _$BudgetPlannerForm {
  factory BudgetPlannerForm({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String venueBudget,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String speakerFees,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String vendorBudget,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String ticketSales,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String sponsorshipIncome,
  }) = _BudgetPlannerForm;

  factory BudgetPlannerForm.fromJson(Map<String, dynamic> json) =>
      _$BudgetPlannerFormFromJson(json);

  factory BudgetPlannerForm.empty() => BudgetPlannerForm(
        venueBudget: '',
        speakerFees: '',
        vendorBudget: '',
        ticketSales: '',
        sponsorshipIncome: '',
      );

  BudgetPlannerForm._();

  bool get isEmpty => this == BudgetPlannerForm.empty();

  bool equalsTo(BudgetPlannerForm other) {
    return venueBudget == other.venueBudget &&
        speakerFees == other.speakerFees &&
        vendorBudget == other.vendorBudget &&
        ticketSales == other.ticketSales &&
        sponsorshipIncome == other.sponsorshipIncome;
  }
}
