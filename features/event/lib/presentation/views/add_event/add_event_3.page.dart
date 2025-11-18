import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/add_event_3.form.dart';
import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page2.cubit.dart';
import '../../cubits/event_page3.cubit.dart';

@RoutePage()
class AddEvent3Page extends StatefulWidget {
  const AddEvent3Page({super.key});

  @override
  State<AddEvent3Page> createState() => _AddEvent3PageState();
}

class _AddEvent3PageState extends State<AddEvent3Page> {
  late BudgetPlannerCubit budgetPlannerCubit;
  late EventPage2Cubit eventPage2Cubit;
  late EventPage3Cubit eventPage3Cubit;

  int currentStep = 4;
  int totalSteps = 8;

  // Local state for editing seat plans - store model and ID for editing forms
  final Map<String, AddEvent3Form> editingModels = {};
  final Set<String> editingIds = {};

  final List<SelectOption<String>> _ticketTypeOptions = [
    const SelectOption(value: 'Regular', label: 'Regular'),
    const SelectOption(value: 'Premium', label: 'Premium'),
    const SelectOption(value: 'VIP', label: 'VIP'),
    const SelectOption(value: 'VVIP', label: 'VVIP'),
  ];

  @override
  void initState() {
    super.initState();
    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    eventPage2Cubit = $.get<EventPage2Cubit>();
    eventPage3Cubit = $.get<EventPage3Cubit>();

    // Initialize cubit with capacity and ticket sales target
    eventPage3Cubit.initialize(
      capacity: eventPage2Cubit.state.capacity,
      ticketSalesTarget: budgetPlannerCubit.state.ticketSales.toDouble(),
    );
  }

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================

  // Calculate percentage of seats
  double getSeatsPercentage(int quota) {
    return eventPage3Cubit.getSeatsPercentage(quota);
  }

  /// =======================================================
  /// ============== CRUD Logic Seat Plan ===================
  /// =======================================================

  void addSeatPlan() {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      editingModels[tempId] = AddEvent3Form.empty();
      editingIds.add(tempId);
    });
  }

  void removeSeatPlan(String id) {
    eventPage3Cubit.removeSeatPlan(id);
    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });
  }

  void saveSeatPlan(String id, AddEvent3Form model) {
    final price =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(model.price)
                ?.toDouble() ??
            0.0;
    final quota =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(model.quota) ?? 0;

    // Check if this is a new seat plan or an update
    final existingPlan =
        eventPage3Cubit.state.seatPlans.where((p) => p.id == id).firstOrNull;

    if (existingPlan != null) {
      // Update existing
      eventPage3Cubit.updateSeatPlan(
        id: id,
        ticketName: model.ticketName,
        ticketType: model.ticketType,
        price: price,
        quota: quota,
        description: model.description,
      );
    } else {
      // Add new
      eventPage3Cubit.addSeatPlan(
        ticketName: model.ticketName,
        ticketType: model.ticketType,
        price: price,
        quota: quota,
        description: model.description,
      );
    }

    // Check if there was an error
    if (eventPage3Cubit.state.status == EventPage3StateStatus.failed) {
      _showMaximumSeatDialog();
      return;
    }

    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });

    log('Seat plan saved: ${model.ticketName}', name: 'add_event_3');
  }

  void editSeatPlan(String id) {
    final plan = eventPage3Cubit.state.seatPlans.firstWhere((p) => p.id == id);

    setState(() {
      editingModels[id] = AddEvent3Form(
        ticketName: plan.ticketName,
        ticketType: plan.ticketType,
        price:
            ThousandsSeparatorInputFormatter.formatNumber(plan.price.toInt()),
        quota: ThousandsSeparatorInputFormatter.formatNumber(plan.quota),
        description: plan.description,
      );
      editingIds.add(id);
    });
  }

  /// =======================================================
  /// ================== UI Builder =========================
  /// =======================================================

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPage3Cubit, EventPage3State>(
      bloc: eventPage3Cubit,
      buildWhen: (previous, current) => previous != current,
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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildWelcomeSection(),
                      ),

                      PaddingGap.md(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildInfoSection(state),
                      ),

                      PaddingGap.md(),

                      // Render all seat plans
                      for (final plan in state.seatPlans)
                        editingIds.contains(plan.id)
                            ? _buildSeatPlanForm(plan.id)
                            : _buildSeatPlanSummary(plan),

                      // Render editing forms that are not yet saved
                      for (final entry in editingModels.entries)
                        if (!state.seatPlans.any((p) => p.id == entry.key))
                          _buildSeatPlanForm(entry.key),

                      PaddingGap.sm(),

                      _buildAddSeatPlanButton(state),

                      PaddingGap.md(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FabButton.primary(
                    onPressed: () {
                      eventPage3Cubit.byPass();
                      _navigateToNextPage();
                    },
                    // onPressed: () => _handleContinue(state),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Ticketing & Seat Plan',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Your ticket income goal is ${FabFunction.formatRupiah(currency: budgetPlannerCubit.state.ticketSales.toDouble())}. Adjust pricing or seat quota to reach this target.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(EventPage3State state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Venue capacity: ',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
            Text(
              '${state.remainingSeats} seats available',
              style: FabTypography.bodySmallBold,
            ),
          ],
        ),
        PaddingGap.xxs(),
        Row(
          children: [
            Text(
              'Ticket income: ',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
            Text(
              FabFunction.formatRupiah(currency: state.totalTicketIncome),
              style: FabTypography.bodySmallBold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddSeatPlanButton(EventPage3State state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: () {
          if (state.remainingSeats == 0) {
            _showMaximumSeatDialog();
            return;
          } else {
            addSeatPlan();
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: FabColors.textPrimary,
              size: 20,
            ),
            PaddingGap.xxs(),
            Text(
              'Add Seat Plan',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAutoAllocateButton() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24),
  //     child: TextButton(
  //       onPressed: () {
  //         // TODO: Implement auto allocate logic
  //       },
  //       child: Text(
  //         'Auto Allocate Seats',
  //         style: FabTypography.displaySemiBold14.copyWith(
  //           color: FabColors.primary,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSeatPlanForm(String id) {
    final model = editingModels[id];
    if (model == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: AddEvent3FormFormBuilder(
        model: model,
        builder: (context, formModel, child) {
          final inputFormatters = [
            ThousandsSeparatorInputFormatter(separator: ','),
          ];

          return FabCard(
            radius: 12,
            color: FabColors.greyscale0,
            border: Border.all(color: FabColors.greyscale200),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FabTextfield(
                    formControl: formModel.ticketNameControl,
                    labelText: 'Ticket Name',
                    hintText: 'e.g. Adhiya Pass',
                    keyboardType: TextInputType.text,
                  ),
                  PaddingGap.md(),
                  FabDropdown<String>(
                    formControl: formModel.ticketTypeControl,
                    options: _ticketTypeOptions,
                    labelText: 'Ticket Type',
                    hintText: 'Select Ticket Type',
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.priceControl,
                    labelText: 'Price',
                    hintText: 'Enter price',
                    keyboardType: TextInputType.number,
                    inputFormatters: inputFormatters,
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.quotaControl,
                    labelText: 'Quota',
                    hintText: 'Enter quota',
                    keyboardType: TextInputType.number,
                    inputFormatters: inputFormatters,
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.descriptionControl,
                    labelText: 'Description',
                    hintText: 'Write description...',
                    maxLines: 3,
                  ),
                  PaddingGap.sm(),
                  _buildTicketIncomeInfo(formModel),
                  PaddingGap.md(),
                  Row(
                    children: [
                      Expanded(
                        child: FabButton.secondary(
                          onPressed: () => removeSeatPlan(id),
                          child: Text(
                            'Delete',
                            style: FabTypography.displaySemiBold14.copyWith(
                              color: FabColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      PaddingGap.sm(),
                      Expanded(
                        child: FabButton.primary(
                          onPressed: () {
                            formModel.submit(
                              onValid: (model) => saveSeatPlan(id, model),
                              onNotValid: () {
                                setState(() {
                                  formModel.form.markAllAsTouched();
                                  FabSnackbar.error(
                                    context: context,
                                    content: 'Please fill all required fields',
                                  );
                                });
                              },
                            );
                          },
                          child: Text(
                            'Save',
                            style: FabTypography.displaySemiBold14.copyWith(
                              color: FabColors.greyscale0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketIncomeInfo(AddEvent3FormForm formModel) {
    return ReactiveValueListenableBuilder(
      formControl: formModel.priceControl,
      builder: (context, priceControl, child) {
        return ReactiveValueListenableBuilder(
          formControl: formModel.quotaControl,
          builder: (context, quotaControl, child) {
            final price = ThousandsSeparatorInputFormatter.parseFormattedNumber(
                    priceControl.value?.toString() ?? '0') ??
                0;
            final quota = ThousandsSeparatorInputFormatter.parseFormattedNumber(
                    quotaControl.value?.toString() ?? '0') ??
                0;
            final income = price * quota;

            if (income > 0) {
              return Text(
                'This ticket category adds ${FabFunction.formatRupiah(currency: income.toDouble())} to your event income.',
                style: FabTypography.bodySmallRegular.copyWith(
                  color: FabColors.greyscale500,
                  fontSize: 12,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildSeatPlanSummary(SeatPlan plan) {
    final percentage = getSeatsPercentage(plan.quota);
    final income = plan.price * plan.quota;

    return GestureDetector(
      onTap: () => editSeatPlan(plan.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: FabCard(
          radius: 12,
          pressedOpacity: 1,
          color: FabColors.greyscale0,
          border: Border.all(color: FabColors.greyscale200),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        plan.ticketName,
                        style: FabTypography.displaySemiBold16.copyWith(
                          color: FabColors.textPrimary,
                        ),
                      ),
                    ),
                    PaddingGap.sm(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: plan.ticketType.badgeTicketColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        plan.ticketType,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                PaddingGap.xs(),
                Row(
                  children: [
                    const Icon(
                      Icons.event_seat,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    PaddingGap.xxs(),
                    Text(
                      '${plan.quota} seats (${percentage.toStringAsFixed(0)}%)',
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: FabColors.greyscale500,
                      ),
                    ),
                  ],
                ),
                PaddingGap.xxs(),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    PaddingGap.xxs(),
                    Text(
                      FabFunction.formatRupiah(currency: plan.price),
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: FabColors.greyscale500,
                      ),
                    ),
                  ],
                ),
                PaddingGap.xxs(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    PaddingGap.xxs(),
                    Expanded(
                      child: Text(
                        plan.description,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.greyscale500,
                        ),
                      ),
                    ),
                  ],
                ),
                PaddingGap.sm(),
                Text(
                  'This ticket category adds ${FabFunction.formatRupiah(currency: income)} to your event income.',
                  style: FabTypography.bodySmallRegular.copyWith(
                    color: FabColors.greyscale500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMaximumSeatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Maximum Seat',
                  style: FabTypography.displayBold22,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "You don't have any quota left for make a seat plan, please adjust amount of seat that you already used.",
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FabButton.primary(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Adjust Seat',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.greyscale0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTicketIncomeBelowTargetDialog(double shortfall) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ticket Income Below Target',
                  style: FabTypography.displaySemiBold18,
                  textAlign: TextAlign.center,
                ),
                PaddingGap.md(),
                Text(
                  'Your ticket income is ${FabFunction.formatRupiah(currency: shortfall)} below the target. Increase promotion or adjust pricing to reach your goal.',
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale500,
                  ),
                  textAlign: TextAlign.center,
                ),
                PaddingGap.lg(),
                FabButton.primary(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Adjust Ticket Plan',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.greyscale0,
                    ),
                  ),
                ),
                PaddingGap.sm(),
                FabButton.secondary(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToNextPage();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Continue Anyway',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToNextPage() {
    $.navigator.push(const AddEvent4Route());
  }

  void _handleContinue(EventPage3State state) {
    final ticketSales = budgetPlannerCubit.state.ticketSales;
    final shortfall = ticketSales - state.totalTicketIncome;

    log('Ticket Sales: $ticketSales, Ticket Income: ${state.totalTicketIncome}',
        name: 'add_event_3');

    if (shortfall > 0) {
      _showTicketIncomeBelowTargetDialog(shortfall);
    } else {
      _navigateToNextPage();
    }
  }
}
