import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class BudgetPlanningPage extends StatefulWidget {
  const BudgetPlanningPage({super.key});

  @override
  State<BudgetPlanningPage> createState() => _BudgetPlanningPageState();
}

class _BudgetPlanningPageState extends State<BudgetPlanningPage> {
  late FormGroup form;
  
  int currentStep = 1;
  int totalSteps = 8;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'venueBudget': FormControl<String>(
        // validators: [Validators.required],
      ),
      'speakerFees': FormControl<String>(
        // validators: [Validators.required],
      ),
      'vendorBudget': FormControl<String>(
        // validators: [Validators.required],
      ),
      'ticketSales': FormControl<String>(
        // validators: [Validators.required],
      ),
      'sponsorshipIncome': FormControl<String>(
        // validators: [Validators.required],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

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
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildBudgetForm(),
                    ),
                  ),
                ],
              ),
            ),

            _buildBottomButtons(),
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

  Widget _buildBudgetForm() {
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
          formControl: form.control('venueBudget') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Venue Budget',
          hintText: 'Enter venue cost (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),

        // Speaker Fees Field
        FabTextfield(
          formControl: form.control('speakerFees') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Speaker Fees',
          hintText: 'Enter Speaker Fees (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),

        // Vendor Budget Field
        FabTextfield(
          formControl: form.control('vendorBudget') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Vendor Budget',
          hintText: 'Enter Vendor Budget (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
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
          formControl: form.control('ticketSales') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Ticket Sales',
          hintText: 'Enter estimated ticket sales (e.g. 10,000,000)',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),

        // Sponsorship Income Field
        FabTextfield(
          formControl: form.control('sponsorshipIncome') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Sponsorship Income',
          hintText: 'Enter estimated sponsorship (e.g. 10,000,000)',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        PaddingGap.xs(),

        TextButton(
          onPressed: _handleSkip,
          child: FabTextStyled(
            'Skip',
            style: FabTypography.displayMedium16.copyWith(
              color: FabColors.greyscale600,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
        
        PaddingGap.sm(),
      ],
    );
  }

  void _handleContinue() {
    // Mark form as touched to show validation errors
    form.markAllAsTouched();

    // Check if form is valid
    if (!form.valid) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FabTextStyled(
            'Please fill all required fields',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale0,
            ),
          ),
          backgroundColor: FabColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Collect form data
    final budgetData = {
      'venueBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('venueBudget').value ?? '0') ?? 0,
      'speakerFees': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('speakerFees').value ?? '0') ?? 0,
      'vendorBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('vendorBudget').value ?? '0') ?? 0,
      'ticketSales': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('ticketSales').value ?? '0') ?? 0,
      'sponsorshipIncome': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('sponsorshipIncome').value ?? '0') ?? 0,
    };

    // Calculate totals
    final totalExpenses = budgetData['venueBudget']! + 
                          budgetData['speakerFees']! + 
                          budgetData['vendorBudget']!;
    final totalIncome = budgetData['ticketSales']! + 
                        budgetData['sponsorshipIncome']!;
    final netBudget = totalIncome - totalExpenses;

    final allBudget = {
      'venueBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('venueBudget').value ?? '0') ?? 0,
      'speakerFees': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('speakerFees').value ?? '0') ?? 0,
      'vendorBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('vendorBudget').value ?? '0') ?? 0,
      'ticketSales': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('ticketSales').value ?? '0') ?? 0,
      'sponsorshipIncome': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('sponsorshipIncome').value ?? '0') ?? 0,
      'netBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(netBudget.toString()) ?? 0,
    };

    debugPrint('Budget Data: $budgetData');
    debugPrint('Total Expenses: $totalExpenses');
    debugPrint('Total Income: $totalIncome');
    debugPrint('Net Budget: $netBudget');

    // Navigate to next step
    $.navigator.push(
      AddEvent1Route(budget: allBudget)
    );

    // Show success message (temporary)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FabTextStyled(
          'Budget planning saved successfully!',
          style: FabTypography.bodySmallMedium.copyWith(
            color: FabColors.greyscale0,
          ),
        ),
        backgroundColor: FabColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleSkip() {
    // Show skip confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const FabTextStyled(
          'Skip Budget Planning?',
          style: FabTypography.displaySemiBold18,
        ),
        content: FabTextStyled(
          'If you skip the system wouldn\'t give you alert later, still skip the Budget Planning?',
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
              final allBudget = {
                'venueBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('venueBudget').value ?? '0') ?? 0,
                'speakerFees': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('speakerFees').value ?? '0') ?? 0,
                'vendorBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('vendorBudget').value ?? '0') ?? 0,
                'ticketSales': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('ticketSales').value ?? '0') ?? 0,
                'sponsorshipIncome': ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('sponsorshipIncome').value ?? '0') ?? 0,
                'netBudget': ThousandsSeparatorInputFormatter.parseFormattedNumber('0') ?? 0,
              };
              // Navigate to next step
              $.navigator.push(AddEvent1Route(budget: allBudget));
              debugPrint('Skipping budget planning...');
            },
            size: FabButtonSize.medium,
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