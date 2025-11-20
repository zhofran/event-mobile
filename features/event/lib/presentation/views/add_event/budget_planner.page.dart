import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/budget_planner.form.dart';
import '../../cubits/budget_planner.cubit.dart';

@RoutePage()
class BudgetPlanningPage extends StatefulWidget {
  const BudgetPlanningPage({super.key});

  @override
  State<BudgetPlanningPage> createState() => _BudgetPlanningPageState();
}

class _BudgetPlanningPageState extends State<BudgetPlanningPage> {
  late BudgetPlannerCubit budgetPlannerCubit;

  int currentStep = 1;
  int totalSteps = 8;
  bool _isFormPopulated = false;

  @override
  void initState() {
    super.initState();

    // Initialize cubit from DI
    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    budgetPlannerCubit.toggleValidityForm(value: null);

    // Load saved budget plan and populate form
    _loadSavedBudgetPlan();
  }

  Future<void> _loadSavedBudgetPlan() async {
    await budgetPlannerCubit.loadBudgetPlanLocally();
  }

  void _populateFormWithSavedData(
      BudgetPlannerFormForm data, BudgetPlannerState state) {
    // Only populate once when form is first built
    if (_isFormPopulated) {
      return;
    }

    // Check if there's saved data in state
    if (state.venueBudget > 0 ||
        state.speakerFees > 0 ||
        state.vendorBudget > 0 ||
        state.ticketSales > 0 ||
        state.sponsorshipIncome > 0) {
      // Format numbers with thousands separator
      data.venueBudgetControl.value =
          ThousandsSeparatorInputFormatter.formatNumber(
        state.venueBudget,
        separator: ',',
      );

      data.speakerFeesControl.value =
          ThousandsSeparatorInputFormatter.formatNumber(
        state.speakerFees,
        separator: ',',
      );

      data.vendorBudgetControl.value =
          ThousandsSeparatorInputFormatter.formatNumber(
        state.vendorBudget,
        separator: ',',
      );

      data.ticketSalesControl.value =
          ThousandsSeparatorInputFormatter.formatNumber(
        state.ticketSales,
        separator: ',',
      );

      data.sponsorshipIncomeControl.value =
          ThousandsSeparatorInputFormatter.formatNumber(
        state.sponsorshipIncome,
        separator: ',',
      );

      _isFormPopulated = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetPlannerCubit, BudgetPlannerState>(
      bloc: budgetPlannerCubit,
      listener: (context, state) {
        if (state.status == BudgetPlannerStateStatus.loadingPost) {
          FabLoadingOverlay.show(context);
        } else {
          FabLoadingOverlay.hide(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: FabColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const FabPageHeader(title: 'Create Event'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedStepProgressIndicator(
                    currentStep: currentStep,
                    totalSteps: totalSteps,
                  ),
                ),
                PaddingGap.xl(),
                Expanded(
                  child: BudgetPlannerFormFormBuilder(
                    builder: (_, data, __) {
                      // Populate form with saved data if available
                      _populateFormWithSavedData(data, state);

                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              children: [
                                _buildWelcomeSection(),
                                PaddingGap.md(),
                                _buildBudgetPlannerForm(data),
                              ],
                            ),
                          ),
                          _buildBottomButtons(data),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetPlannerForm(BudgetPlannerFormForm data) {
    final inputFormatters = [ThousandsSeparatorInputFormatter(separator: ',')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Event Expenses Section
        const FabTextStyled(
          'Event Expenses',
          style: FabTypography.displaySemiBold18,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Add all costs needed to run your event.',
          style: FabTypography.bodySmallRegular.copyWith(
            color: FabColors.greyscale600,
          ),
        ),
        PaddingGap.md(),

        // Venue Budget Field
        FabTextfield(
          formControl: data.venueBudgetControl,
          keyboardType: TextInputType.number,
          labelText: 'Venue Budget',
          hintText: 'Enter venue cost (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),

        PaddingGap.md(),

        // Speaker Fees Field
        FabTextfield(
          formControl: data.speakerFeesControl,
          keyboardType: TextInputType.number,
          labelText: 'Speaker Fees',
          hintText: 'Enter Speaker Fees (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),

        PaddingGap.md(),

        // Vendor Budget Field
        FabTextfield(
          formControl: data.vendorBudgetControl,
          keyboardType: TextInputType.number,
          labelText: 'Vendor Budget',
          hintText: 'Enter Vendor Budget (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),

        PaddingGap.lg(),

        // Event Income Section
        const FabTextStyled(
          'Event Income',
          style: FabTypography.displaySemiBold18,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Estimate how much your event will earn from different sources.',
          style: FabTypography.bodySmallRegular.copyWith(
            color: FabColors.greyscale600,
          ),
        ),
        PaddingGap.md(),

        // Ticket Sales Field
        FabTextfield(
          formControl: data.ticketSalesControl,
          keyboardType: TextInputType.number,
          labelText: 'Ticket Sales',
          hintText: 'Enter estimated ticket sales (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),

        PaddingGap.md(),

        // Sponsorship Income Field
        FabTextfield(
          formControl: data.sponsorshipIncomeControl,
          keyboardType: TextInputType.number,
          labelText: 'Sponsorship Income',
          hintText: 'Enter estimated sponsorship (e.g. 10,000,000)',
          textInputAction: TextInputAction.done,
          inputFormatters: inputFormatters,
        ),

        PaddingGap.md(),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Budget Planning',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Track all expenses and income to stay on budget.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BudgetPlannerFormForm data) {
    return Column(
      children: [
        PaddingGap.xs(),
        TextButton(
          onPressed: () => _handleSkip(data),
          child: FabTextStyled(
            'Skip',
            style: FabTypography.displayMedium16.copyWith(
              color: FabColors.greyscale600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FabButton.primary(
            onPressed: byPass,
            // onPressed: () {
            //   data.submit(
            //     onValid: addBudgetPlanner,
            //     onNotValid: () {
            //       // Form is invalid, errors will be shown automatically
            //       budgetPlannerCubit.toggleValidityForm(value: false);
            //       FabSnackbar.error(
            //         context: context,
            //         content: 'Please fill all required fields',
            //       );
            //     },
            //   );
            // },
            size: FabButtonSize.large,
            width: double.infinity,
            child: Text(
              'Continue',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.greyscale0,
              ),
            ),
          ),
        ),
        PaddingGap.sm(),
      ],
    );
  }

  Future<void> byPass() async {
    budgetPlannerCubit
      ..calculateBudget(
        venueBudget: 50000000,
        speakerFees: 20000000,
        vendorBudget: 30000000,
        ticketSales: 20000000,
        sponsorshipIncome: 250000000,
      )
      ..toggleValidityForm(value: true);

    await budgetPlannerCubit.saveBudgetPlanLocally().then(
      (value) async {
        if (!mounted) {
          return;
        }
        FabSnackbar.success(
          context: context,
          content: 'Budget planning saved successfully!',
        );

        await $.navigator.push(const AddEvent1Route());
      },
    );
  }

  Future<void> addBudgetPlanner(BudgetPlannerForm model) async {
    final venueBudget = ThousandsSeparatorInputFormatter.parseFormattedNumber(
          model.venueBudget,
        ) ??
        0;

    final speakerFees = ThousandsSeparatorInputFormatter.parseFormattedNumber(
          model.speakerFees,
        ) ??
        0;

    final vendorBudget = ThousandsSeparatorInputFormatter.parseFormattedNumber(
          model.vendorBudget,
        ) ??
        0;

    final ticketSales = ThousandsSeparatorInputFormatter.parseFormattedNumber(
          model.ticketSales,
        ) ??
        0;

    final sponsorshipIncome =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(
              model.sponsorshipIncome,
            ) ??
            0;

    budgetPlannerCubit
      ..calculateBudget(
        venueBudget: venueBudget,
        speakerFees: speakerFees,
        vendorBudget: vendorBudget,
        ticketSales: ticketSales,
        sponsorshipIncome: sponsorshipIncome,
      )
      ..toggleValidityForm(value: true);

    await budgetPlannerCubit.postBudgetPlan(callback: () async {
      FabSnackbar.success(
        context: context,
        content: 'Budget planning saved successfully!',
      );

      await $.navigator.push(const AddEvent1Route());
    });
  }

  void _handleSkip(BudgetPlannerFormForm data) {
    // Show skip confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const FabTextStyled(
          'Skip Budget Planning?',
          style: FabTypography.displaySemiBold18,
        ),
        content: FabTextStyled(
          "If you skip the system wouldn't give you alert later, still skip the Budget Planning?",
          style: FabTypography.bodySmallMedium.copyWith(
            color: FabColors.greyscale600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: FabTextStyled(
              'Cancel',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale600,
              ),
            ),
          ),
          FabButton.primary(
            onPressed: () {
              Navigator.pop(context);
              budgetPlannerCubit.calculateBudget(
                venueBudget: 0,
                speakerFees: 0,
                vendorBudget: 0,
                ticketSales: 0,
                sponsorshipIncome: 0,
              );

              // Navigate to next step
              $.navigator.push(const AddEvent1Route());
              debugPrint('Skipping budget planning...');
            },
            child: Text(
              'Skip',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale0,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
