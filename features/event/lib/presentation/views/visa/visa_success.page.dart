import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VisaSuccessPage extends StatelessWidget {
  const VisaSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildSuccessIllustration(),
              PaddingGap.xl(),
              _buildSuccessMessage(),
              PaddingGap.lg(),
              _buildDescription(),
              PaddingGap.md(),
              _buildNotificationText(),
              const Spacer(),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIllustration() {
    // Placeholder for illustration
    // You can replace this with your actual illustration asset
    return Image.asset(
        Assets.images.eventApproval.path,
        width: 240,
        height: 240,
        package: 'design',
      );
  }

  Widget _buildSuccessMessage() {
    return const FabTextStyled(
      'Your visa request has been\nsubmitted successfully!',
      style: FabTypography.displaySemiBold22,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return FabTextStyled(
      'We coordinate with authorized embassies and visa agents to support your application. Please ensure your passport remains valid for at least 6 months from your travel date.',
      style: FabTypography.displayRegular14.copyWith(
        color: FabColors.greyscale900,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNotificationText() {
    return FabTextStyled(
      "You'll receive a notification once your application is approved.",
      style: FabTypography.displayRegular12.copyWith(
        color: FabColors.greyscale400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Track My Application button (text only)
        TextButton(
          onPressed: () {
            // Navigate to tracking page
            $.navigator.replace(const HomeRoute());
          },
          child: FabTextStyled(
            'Track My Application',
            style: FabTypography.displayMedium16.copyWith(
              color: FabColors.primary,
            ),
          ),
        ),
        PaddingGap.md(),
        
        // Go to Dashboard button (primary)
        FabButton.primary(
          onPressed: () {
            // Navigate back to dashboard/home
            // $.navigator.popUntil((route) => route.isFirst);
            $.navigator.replace(const HomeRoute());
          },
          size: FabButtonSize.large,
          width: double.infinity,
          child: Text(
            'Go to Dashboard',
            style: FabTypography.displaySemiBold16.copyWith(
              color: FabColors.greyscale0,
            ),
          ),
        ),
      ],
    );
  }
}