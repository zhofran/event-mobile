import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VisaReviewPage extends StatelessWidget {
  const VisaReviewPage({super.key});

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
                  _buildStep1Review(),
                  PaddingGap.xl(),
                  _buildStep2Review(),
                  PaddingGap.xl(),
                  _buildStep3Review(),
                  PaddingGap.xl(),
                  _buildStep4Review(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  Widget _buildStep1Review() {
    return _buildStepSection(
      'Step 1 - Applicant Information',
      [
        _buildReviewField('Full Name', 'Rolando Febrianto'),
        Row(
          children: [
            Expanded(
              child: _buildReviewField('Nationality', 'Indonesia'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReviewField('Passport Number', '2187319B273'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildReviewField('Birthdate', '24-02-2001'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReviewField('Passport Expiry Date', '28-02-2028'),
            ),
          ],
        ),
        _buildPassportScanField(),
      ],
    );
  }

  Widget _buildStep2Review() {
    return _buildStepSection(
      'Step 2 - Travel Details',
      [
        _buildReviewField('Event Name', 'Mining Tech Summit 2025'),
        Row(
          children: [
            Expanded(
              child: _buildReviewField('Event Location', 'Jakarta'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReviewField('Event Date', '15-10-2025'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildReviewField('Arrival Date', '12-10-2025'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReviewField('Departure Date', '15-10-2025'),
            ),
          ],
        ),
        _buildReviewField('Purpose of Visit', 'Speaker'),
      ],
    );
  }

  Widget _buildStep3Review() {
    return _buildStepSection(
      'Step 3 - Accommodation Details',
      [
        _buildReviewField('Hotel Name', 'Harris fX Sudirman'),
        _buildReviewField('Hotel Location', 'Jakarta'),
        Row(
          children: [
            Expanded(
              child: _buildReviewField('Check-In', '12-10-2025'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildReviewField('Check-Out', '15-10-2025'),
            ),
          ],
        ),
        _buildReviewField('Booking Ref', '2165737265'),
      ],
    );
  }

  Widget _buildStep4Review() {
    return _buildStepSection(
      'Step 4 - Required Documents',
      [
        _buildDocumentField('Invitation Letter', 'inv Letter.pdf'),
        _buildDocumentField('Proof of Accommodation', 'hotelbooking.pdf'),
        _buildDocumentField('Return Flight Ticket', 'ticketlion air.pdf'),
        _buildDocumentField('Additional Document', '-'),
      ],
    );
  }

  Widget _buildStepSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FabTextStyled(
              title,
              style: FabTypography.displaySemiBold18,
            ),
            InkWell(
              onTap: () {
                // Navigate back to edit specific step
              },
              child: Row(
                children: [
                  FabTextStyled(
                    'Edit',
                    style: FabTypography.displayMedium14.copyWith(
                      color: FabColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: FabColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        PaddingGap.md(),
        ...children,
      ],
    );
  }

  Widget _buildReviewField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FabTextStyled(
            label,
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          PaddingGap.xs(),
          FabTextStyled(
            value,
            style: FabTypography.displayMedium16.copyWith(
              color: FabColors.greyscale900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportScanField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FabTextStyled(
          'Passport Scan',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
        PaddingGap.xs(),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FabColors.greyscale200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://via.placeholder.com/400x200/CCCCCC/666666?text=Passport+Scan',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentField(String label, String fileName) {
    final hasFile = fileName != '-';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FabTextStyled(
            label,
            style: FabTypography.displayRegular12.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          PaddingGap.xs(),
          FabTextStyled(
            fileName,
            style: FabTypography.displayMedium14.copyWith(
              color: hasFile ? FabColors.greyscale900 : FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FabButton.primary(
        onPressed: () {
          // Navigate to success page
          $.navigator.push(const VisaSuccessRoute());
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
    );
  }
}
