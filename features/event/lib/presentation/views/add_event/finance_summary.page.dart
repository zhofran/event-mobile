import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FinancialManagementPage extends StatefulWidget {
  const FinancialManagementPage({super.key});

  @override
  State<FinancialManagementPage> createState() =>
      _FinancialManagementPageState();
}

class _FinancialManagementPageState extends State<FinancialManagementPage> {
  int currentStep = 1;
  int totalSteps = 5;

  // Financial Data
  final double expensesBudget = 24000000;
  final double venueExpense = 10000000;
  final double speakersExpense = 8000000;
  final double vendorsExpense = 5000000;

  final double incomeTarget = 30000000;
  final double ticketSalesIncome = 15000000;
  final double sponsorsIncome = 20000000;

  // Calculations
  double get totalExpenses => venueExpense + speakersExpense + vendorsExpense;
  double get totalIncome => ticketSalesIncome + sponsorsIncome;
  double get netProfit => totalIncome - totalExpenses;

  // Status checks
  bool get isOnBudget => totalExpenses <= expensesBudget;
  bool get isAboveTarget => totalIncome >= incomeTarget;
  bool get isSurplus => netProfit > 0;

  String get expensesStatus => isOnBudget ? 'On Budget' : 'Over Budget';
  String get incomeStatus => isAboveTarget ? 'Above Target' : 'Below Target';
  String get summaryStatus => isSurplus ? 'Surplus' : 'Deficit';

  Color get expensesStatusColor =>
      isOnBudget ? const Color(0xFFD1F4E0) : const Color(0xFFFFD1D1);

  Color get incomeStatusColor =>
      isAboveTarget ? const Color(0xFFD1F4E0) : const Color(0xFFFFD1D1);

  Color get summaryStatusColor =>
      isSurplus ? const Color(0xFFD1F4E0) : const Color(0xFFFFD1D1);

  // Format currency
  String formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = FabFunction.formatRupiah(currency: absAmount);
    return isNegative ? '-$formatted' : formatted;
  }

  void handleContinue() {
    _showConfirmSubmissionDialog();
  }

  void _showConfirmSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  'Confirm Submission',
                  style: FabTypography.displaySemiBold18,
                  textAlign: TextAlign.center,
                ),
                PaddingGap.md(),
                Text(
                  'Once submitted, your event will be reviewed by our stakeholders.While waiting for approval, your event can be viewed by sponsors and vendors, but not yet visible to attendees.',
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale500,
                  ),
                  textAlign: TextAlign.center,
                ),
                PaddingGap.sm(),
                Text(
                  'You can edit or fine-tune this later anytime before publishing your event.',
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale400,
                  ),
                  textAlign: TextAlign.center,
                ),
                PaddingGap.lg(),
                FabButton.primary(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Submit event
                    _submitEvent();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Submit',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.greyscale0,
                    ),
                  ),
                ),
                PaddingGap.sm(),
                FabButton.secondary(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Cancel',
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

  void _submitEvent() {
    // Handle event submission
    // Navigate to success page or home
    $.navigator.push(EventApprovalRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FabPageHeader(title: 'Create Event'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: AnimatedStepProgressIndicator(
                  //     currentStep: currentStep,
                  //     totalSteps: totalSteps,
                  //   ),
                  // ),

                  PaddingGap.xl(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildHeaderSection(),
                  ),

                  PaddingGap.lg(),

                  // Expenses Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildExpensesSection(),
                  ),

                  PaddingGap.lg(),

                  // Income Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildIncomeSection(),
                  ),

                  PaddingGap.lg(),

                  // Summary Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSummarySection(),
                  ),

                  PaddingGap.xl(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: handleContinue,
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

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Financial Management',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          "Track your event's financial performance, view expenses, income, and overall profit in one place.",
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Expenses',
              style: FabTypography.displaySemiBold18,
            ),
            _buildStatusBadge(expensesStatus, expensesStatusColor),
          ],
        ),
        PaddingGap.xs(),
        Text(
          'See all your spending details',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.xs(),
        Text(
          'Budget: ${formatCurrency(expensesBudget)}',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.sm(),
        _buildExpenseItem('Venue', venueExpense),
        _buildExpenseItem('Speakers', speakersExpense),
        _buildExpenseItem('Vendors', vendorsExpense),
        PaddingGap.sm(),
        _buildTotalRow('Total Expenses', totalExpenses, isNegative: true),
      ],
    );
  }

  Widget _buildIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Income',
              style: FabTypography.displaySemiBold18,
            ),
            _buildStatusBadge(incomeStatus, incomeStatusColor),
          ],
        ),
        PaddingGap.xs(),
        Text(
          'Understand how your event generates revenue.',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.xs(),
        Text(
          'Target: ${formatCurrency(incomeTarget)}',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.sm(),
        _buildIncomeItem('Ticket Sales', ticketSalesIncome),
        _buildIncomeItem('Sponsors', sponsorsIncome),
        PaddingGap.sm(),
        _buildTotalRow('Total Income', totalIncome),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Summary',
              style: FabTypography.displaySemiBold18,
            ),
            _buildStatusBadge(summaryStatus, summaryStatusColor),
          ],
        ),
        PaddingGap.xs(),
        Text(
          'View the difference between your total income and expenses.',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.sm(),
        _buildSummaryItem('Income', totalIncome),
        _buildSummaryItem('Expenses', totalExpenses, isNegative: true),
        PaddingGap.sm(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: FabColors.greyscale200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Profit',
                style: FabTypography.displaySemiBold16,
              ),
              Text(
                formatCurrency(netProfit),
                style: FabTypography.displaySemiBold16.copyWith(
                  color: isSurplus ? FabColors.success : FabColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.textPrimary,
            ),
          ),
          PaddingGap.xxs(),
          const Icon(
            Icons.check_circle,
            size: 16,
            color: FabColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
          Text(
            formatCurrency(amount),
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
          Text(
            formatCurrency(amount),
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount,
      {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
          Text(
            isNegative ? formatCurrency(-amount) : formatCurrency(amount),
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount,
      {bool isNegative = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: FabColors.greyscale200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FabTypography.displaySemiBold16,
          ),
          Text(
            isNegative ? formatCurrency(-amount) : formatCurrency(amount),
            style: FabTypography.displaySemiBold16,
          ),
        ],
      ),
    );
  }
}
