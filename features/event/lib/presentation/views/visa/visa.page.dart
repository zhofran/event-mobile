import 'package:deps/features/features.dart';
import 'package:flutter/material.dart';

import 'package:deps/design/design.dart';
import 'package:deps/packages/auto_route.dart';

@RoutePage()
class VisaApplicationPage extends StatelessWidget {
  const VisaApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeader(),
                  PaddingGap.lg(),
                  _buildStepIndicator(),
                  PaddingGap.xl(),
                  _buildStepsList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [
          FabButton.secondary(
            onPressed: () => $.navigator.pop(),
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
              'Visa Application',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Apply for Visa Assistance',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Let us help you prepare your travel documents for this event.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepDot(true),
        _buildStepLine(),
        _buildStepDot(false),
        _buildStepLine(),
        _buildStepDot(false),
      ],
    );
  }

  Widget _buildStepDot(bool isActive) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? FabColors.primary : FabColors.greyscale200,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: FabColors.greyscale200,
      ),
    );
  }

  Widget _buildStepsList(BuildContext context) {
    return Column(
      children: [
        _buildStepCard(
          context,
          'Step 1',
          'Applicant Information',
          'Fill in your personal details',
          () => $.navigator.push(const VisaApplicantRoute()),
          // () => debugPrint('Navigate to Step 1'),
        ),
        PaddingGap.md(),
        _buildStepCard(
          context,
          'Step 2',
          'Travel Details',
          'Provide your travel information',
          () => $.navigator.push(const VisaTravelDetailRoute()),
          // null, // Will be enabled after step 1
        ),
        PaddingGap.md(),
        _buildStepCard(
          context,
          'Step 3',
          'Accommodation Details',
          'Enter your hotel information',
          () => $.navigator.push(const VisaAccomodationRoute()),
          // null, // Will be enabled after step 2
        ),
        PaddingGap.md(),
        _buildStepCard(
          context,
          'Step 4',
          'Document Upload',
          'Upload your travel documents',
          () => $.navigator.push(const VisaDocumentRoute()),
          // null, // Will be enabled after step 3
        ),
      ],
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    String stepNumber,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    final isEnabled = onTap != null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FabColors.greyscale0,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled ? FabColors.primary : FabColors.greyscale200,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FabTextStyled(
                    stepNumber,
                    style: FabTypography.displaySemiBold14.copyWith(
                      color: isEnabled ? FabColors.primary : FabColors.greyscale400,
                    ),
                  ),
                  PaddingGap.xs(),
                  FabTextStyled(
                    title,
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: isEnabled ? FabColors.greyscale900 : FabColors.greyscale400,
                    ),
                  ),
                  PaddingGap.xs(),
                  FabTextStyled(
                    subtitle,
                    style: FabTypography.displayRegular12.copyWith(
                      color: FabColors.greyscale400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isEnabled ? FabColors.greyscale900 : FabColors.greyscale300,
            ),
          ],
        ),
      ),
    );
  }
}
