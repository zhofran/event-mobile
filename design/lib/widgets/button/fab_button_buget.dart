import 'package:deps/design/design.dart';
import 'package:flutter/material.dart';

class BudgetExceededDialog {
  /// Show Budget Exceeded Dialog
  /// 
  /// Parameters:
  /// - [context]: BuildContext
  /// - [exceededAmount]: Jumlah yang melebihi budget (sudah dalam format Rupiah)
  /// - [onAdjustBudget]: Callback ketika tombol "Adjust Budget" ditekan
  /// - [onContinueAnyway]: Callback ketika tombol "Continue Anyway" ditekan (optional)
  static Future<void> show({
    String? title,
    String? subtitle,
    required BuildContext context,
    required String exceededAmount,
    required VoidCallback onAdjustBudget,
    VoidCallback? onContinueAnyway,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _BudgetExceededDialogContent(
        title: title,
        subtitle: subtitle,
        exceededAmount: exceededAmount,
        onAdjustBudget: onAdjustBudget,
        onContinueAnyway: onContinueAnyway,
      ),
    );
  }
}

class _BudgetExceededDialogContent extends StatelessWidget {
  const _BudgetExceededDialogContent({
    this.title,
    this.subtitle,
    required this.exceededAmount,
    required this.onAdjustBudget,
    this.onContinueAnyway,
  });

  final String? title;
  final String? subtitle;
  final String exceededAmount;
  final VoidCallback onAdjustBudget;
  final VoidCallback? onContinueAnyway;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            FabTextStyled(
              '$title',
              style: FabTypography.displaySemiBold18.copyWith(
                color: FabColors.greyscale900,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Content
            FabTextStyled(
              subtitle ?? 'You\'ve spent $exceededAmount more than your allocated $title. Try reducing rental or decoration costs to stay within limit.',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Adjust Budget Button (Primary)
            SizedBox(
              width: double.infinity,
              child: FabButton.primary(
                onPressed: () {
                  Navigator.pop(context);
                  onAdjustBudget();
                },
                size: FabButtonSize.large,
                child: Text(
                  'Adjust Budget',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Continue Anyway Button (Text Button)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onContinueAnyway != null) {
                  onContinueAnyway!();
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: FabTextStyled(
                'Continue Anyway',
                style: FabTypography.displayMedium16.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}