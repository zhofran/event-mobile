import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddEvent3Page extends StatefulWidget {
  AddEvent3Page({required this.budget, required this.capacity, super.key});

  final Map<String, dynamic> budget;
  final int capacity;

  @override
  State<AddEvent3Page> createState() => _AddEvent3PageState();
}

class _AddEvent3PageState extends State<AddEvent3Page> {
  int currentStep = 4;
  int totalSteps = 8;

  final List<SeatPlanData> seatPlans = [];

  final List<String> _ticketType = [
    'Regular',
    'Premium',
    'VIP',
    'VVIP',
  ];

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================

  // Menghitung total seats yang sudah terpakai
  int get totalUsedSeats {
    int total = 0;
    for (var plan in seatPlans) {
      if (!plan.isEditing) {
        final quota = ThousandsSeparatorInputFormatter.parseFormattedNumber(
                plan.form.control('quota').value) ??
            0;
        total += quota;
      }
    }
    return total;
  }

  // Menghitung remaining seats
  int get remainingSeats => widget.capacity - totalUsedSeats;

  // Menghitung total ticket income
  double get totalTicketIncome {
    double total = 0;
    for (var plan in seatPlans) {
      if (!plan.isEditing) {
        final price = ThousandsSeparatorInputFormatter.parseFormattedNumber(
                plan.form.control('price').value) ??
            0;
        final quota = ThousandsSeparatorInputFormatter.parseFormattedNumber(
                plan.form.control('quota').value) ??
            0;
        total += (price * quota);
      }
    }
    return total;
  }

  // Get badge color based on ticket type
  Color getBadgeColor(String type) {
    switch (type) {
      case 'Regular':
        return const Color(0xFFD1F4E0); // Light green
      case 'Premium':
        return const Color(0xFFD1F0FF); // Light blue
      case 'VIP':
        return const Color(0xFFFFF4D1); // Light yellow
      case 'VVIP':
        return const Color(0xFFFFE0F0); // Light pink
      default:
        return FabColors.primary50;
    }
  }

  // Calculate percentage of seats
  double getSeatsPercentage(int quota) {
    if (widget.capacity == 0) return 0;
    return (quota / widget.capacity) * 100;
  }

  /// =======================================================
  /// ============== CRUD Logic Seat Plan ===================
  /// =======================================================

  void addSeatPlan() {
    final newForm = FormGroup({
      'ticketName': FormControl<String>(),
      'ticketType': FormControl<String>(),
      'price': FormControl<String>(validators: [Validators.required]),
      'quota': FormControl<String>(validators: [Validators.required]),
      'description': FormControl<String>(),
    });

    setState(() {
      seatPlans.add(SeatPlanData(form: newForm, isEditing: true));
    });
  }

  void removeSeatPlan(int index) {
    setState(() {
      seatPlans.removeAt(index);
    });
  }

  void saveSeatPlan(int index) {
    final plan = seatPlans[index];
    
    // Validasi form
    if (!plan.form.valid) {
      plan.form.markAllAsTouched();
      return;
    }

    // Validasi quota tidak melebihi remaining seats
    final quota = ThousandsSeparatorInputFormatter.parseFormattedNumber(
            plan.form.control('quota').value) ??
        0;
    
    if (quota > remainingSeats) {
      _showMaximumSeatDialog();
      return;
    }

    setState(() {
      plan.isEditing = false;
    });

    log('Seat plan saved: ${plan.form.value}', name: 'add_event_3');
  }

  void editSeatPlan(int index) {
    setState(() {
      seatPlans[index].isEditing = true;
    });
  }

  /// =======================================================
  /// ================== UI Builder =========================
  /// =======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedStepProgressIndicator(
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                    ),
                  ),

                  PaddingGap.xl(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  PaddingGap.md(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildInfoSection(),
                  ),

                  PaddingGap.md(),

                  // Render semua seat plan card
                  for (int i = 0; i < seatPlans.length; i++)
                    seatPlans[i].isEditing
                        ? _buildSeatPlanForm(i)
                        : _buildSeatPlanSummary(i),

                  PaddingGap.sm(),

                  _buildAddSeatPlanButton(),

                  PaddingGap.md(),

                  // _buildAutoAllocateButton(),

                  // PaddingGap.xl(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: FabButton.primary(
                onPressed: _handleContinue,
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
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [
          FabButton.secondary(
            onPressed: () {
              $.navigator.pop();
            },
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
          const Expanded(
            child: FabTextStyled(
              'Create Event',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          FabButton.secondary(
            onPressed: () => {},
            isIconOnly: true,
            iconWidget: Assets.images.icons.questionLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
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
          'Your ticket income goal is ${FabFunction.formatRupiah(currency: double.parse(widget.budget['ticketSales']?.toString() ?? '0'))}. Adjust pricing or seat quota to reach this target.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
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
              '$remainingSeats seats available',
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
              FabFunction.formatRupiah(currency: totalTicketIncome),
              style: FabTypography.bodySmallBold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddSeatPlanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: () {
          if (remainingSeats == 0) {
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

  Widget _buildSeatPlanForm(int index) {
    final form = seatPlans[index].form;

    return FabCardForm(
      form: form,
      buildFields: (form) => [
        FabTextfield(
          formControl: form.control('ticketName') as FormControl<String>,
          labelText: 'Ticket Name',
          hintText: 'e.g. Adhiya Pass',
          keyboardType: TextInputType.text,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),
        _buildTicketTypeDropdown(form),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('price') as FormControl<String>,
          labelText: 'Price *',
          hintText: 'Enter price',
          keyboardType: TextInputType.number,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('quota') as FormControl<String>,
          labelText: 'Quota *',
          hintText: 'Enter quota',
          keyboardType: TextInputType.number,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('description') as FormControl<String>,
          labelText: 'Description *',
          hintText: 'Write description...',
          maxLines: 3,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.sm(),
        _buildTicketIncomeInfo(form),
      ],
      buildSummary: (form) => _buildSeatPlanSummary(index),
      onSaved: (form) => saveSeatPlan(index),
      onEdit: () => editSeatPlan(index),
      onDelete: () => removeSeatPlan(index),
    );
  }

  Widget _buildTicketTypeDropdown(FormGroup form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Type *',
          style: FabTypography.bodySmallMedium.copyWith(
            color: FabColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ReactiveDropdownField<String>(
          formControlName: 'ticketType',
          hint: Text(
            'Select Ticket Type',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
          ),
          items: _ticketType
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: FabColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          icon: Icon(
            UIcons.boldRounded.angle_small_down,
            size: 20,
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Ticket Type is required',
          },
        ),
      ],
    );
  }

  Widget _buildTicketIncomeInfo(FormGroup form) {
    return ReactiveValueListenableBuilder(
      formControl: form.control('price'),
      builder: (context, priceControl, child) {
        return ReactiveValueListenableBuilder(
          formControl: form.control('quota'),
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

  Widget _buildSeatPlanSummary(int index) {
    final form = seatPlans[index].form;
    final name = form.control('ticketName').value ?? '';
    final type = form.control('ticketType').value ?? '';
    final price = ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('price').value ?? '') ?? 0;
    final quota = ThousandsSeparatorInputFormatter.parseFormattedNumber(
            form.control('quota').value ?? '') ??
        0;
    final desc = form.control('description').value ?? '';

    final percentage = getSeatsPercentage(quota);
    final income = price * quota;

    return GestureDetector(
      onTap: () => editSeatPlan(index),
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
                        name,
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
                        color: getBadgeColor(type),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type,
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
                      '$quota seats (${percentage.toStringAsFixed(0)}%)',
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
                      FabFunction.formatRupiah(currency: price.toDouble()),
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
                        desc,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.greyscale500,
                        ),
                      ),
                    ),
                  ],
                ),

                PaddingGap.sm(),

                Text(
                  'This ticket category adds ${FabFunction.formatRupiah(currency: income.toDouble())} to your event income.',
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
      barrierDismissible: true,
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
                  'You don\'t have any quota left for make a seat plan, please adjust amount of seat that you already used.',
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
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
    $.navigator.push(AddEvent4Route(budget: widget.budget));
  }

  void _handleContinue() {
    final netBudget =
        double.parse(widget.budget['netBudget']?.toString() ?? '0');
    final shortfall = netBudget - totalTicketIncome;

    log('Net Budget: $netBudget, Ticket Income: $totalTicketIncome',
        name: 'add_event_3');

    if (shortfall > 0) {
      _showTicketIncomeBelowTargetDialog(shortfall);
    } else {
      _navigateToNextPage();
    }
  }
}

class SeatPlanData {
  final FormGroup form;
  bool isEditing;

  SeatPlanData({
    required this.form,
    this.isEditing = true,
  });
}