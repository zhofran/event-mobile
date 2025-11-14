import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddEvent7Page extends StatefulWidget {
  const AddEvent7Page({super.key});

  @override
  State<AddEvent7Page> createState() => _AddEvent7PageState();
}

class _AddEvent7PageState extends State<AddEvent7Page> {
  int currentStep = 8;
  int totalSteps = 8;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Indicator
                    AnimatedStepProgressIndicator(
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                    ),

                    PaddingGap.md(),

                    // Title & Description
                    const Text(
                      'Review & Submit',
                      style: FabTypography.displayBold22,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Make sure everything looks good before publishing your event. You can still go back to edit any section.',
                      style: FabTypography.displayRegular14.copyWith(
                        color: FabColors.greyscale400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Event Summary Section
                    _buildEventSummarySection(),

                    const SizedBox(height: 24),

                    // Schedule & Venue Section
                    _buildScheduleVenueSection(),

                    const SizedBox(height: 24),

                    // Ticket & Seating Section
                    _buildTicketSeatingSection(),

                    const SizedBox(height: 24),

                    // Speakers Section
                    _buildSpeakersSection(),

                    const SizedBox(height: 24),

                    // Sponsors Section
                    _buildSponsorsSection(),

                    const SizedBox(height: 50), // Extra space for bottom button
                  ],
                ),
              ),
            ),

            // Submit Button
            _buildSubmitButton(),
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
          const SizedBox(width: 40), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildEventSummarySection() {
    return _buildSection(
      title: 'Event Summary',
      onEdit: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Name
          _buildLabel('Event Name'),
          const SizedBox(height: 4),
          const Text(
            'Mining Tech Summit 2025',
            style: FabTypography.displayBold16,
          ),

          const SizedBox(height: 16),

          // Event Type & Format
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Event Type'),
                    const SizedBox(height: 4),
                    const Text(
                      'Exhibition',
                      style: FabTypography.displayBold14,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Event Format'),
                    const SizedBox(height: 4),
                    const Text(
                      'Offline',
                      style: FabTypography.displayBold14,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          _buildLabel('Description'),
          const SizedBox(height: 4),
          const Text(
            'Join us for the Mining Tech Summit 2025, a premier event showcasing the latest innovations in mining technology. Explore cutting-edge solutions, network with industry leaders, and discover the future of mining.',
            style: FabTypography.bodySmallSemiBold,
            textAlign: TextAlign.justify,
          ),

          const SizedBox(height: 16),

          // Event Banner
          _buildLabel('Event Banner'),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Assets.images.testEvent.path,
              package: 'design',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleVenueSection() {
    return _buildSection(
      title: 'Schedule & Venue',
      onEdit: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Date'),
                    const SizedBox(height: 4),
                    const Text(
                      '20 October 2025',
                      style: FabTypography.displayBold14,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Time'),
                    const SizedBox(height: 4),
                    const Text(
                      '14:00 WIB',
                      style: FabTypography.displayBold14,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Venue
          _buildLabel('Venue'),
          const SizedBox(height: 4),
          const Text(
            'Jakarta Convention Center',
            style: FabTypography.displaySemiBold14,
          ),

          const SizedBox(height: 12),

          // Address
          _buildLabel('Address'),
          const SizedBox(height: 4),
          Text(
            'Jl. Gatot Subroto, RT.1/RW.3, Gelora, Kecamatan Tanah Abang, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta',
            style: FabTypography.displayBold14.copyWith(
              color: FabColors.greyscale600,
            ),
          ),

          const SizedBox(height: 12),

          // Location
          _buildLabel('Location'),
          const SizedBox(height: 4),
          Text(
            'https://share.googleNfhF3bASCzOeXubRh',
            style: FabTypography.displayBold14.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),

          const SizedBox(height: 12),

          // Capacity
          _buildLabel('Capacity'),
          const SizedBox(height: 4),
          const Text(
            '500',
            style: FabTypography.displayBold14,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketSeatingSection() {
    return _buildSection(
      title: 'Ticket & Seating',
      subtitle: 'You Have 3 Plan',
      onEdit: () {},
      child: Column(
        children: [
          _buildTicketCard(
            name: 'Adhiya Pass',
            type: 'Regular',
            color: FabColors.success25,
            seats: '300 seats (60%)',
            price: 'Rp150.000',
            benefits: 'Akses penuh ke seluruh sesi seminar utama.',
          ),
          const SizedBox(height: 12),
          _buildTicketCard(
            name: 'Pradipta Pass',
            type: 'Premium',
            color: FabColors.info,
            seats: '150 seats (30%)',
            price: 'Rp300.000',
            benefits:
                'Kursi prioritas + e-certificate eksklusif + snack box.',
          ),
          const SizedBox(height: 12),
          _buildTicketCard(
            name: 'Dharma Pass',
            type: 'VIP',
            color: FabColors.warning,
            seats: '50 seats (10%)',
            price: 'Rp600.000',
            benefits:
                'Kursi depan, merchandise eksklusif, & sesi meet & greet dengan pembicara.',
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakersSection() {
    return _buildSection(
      title: 'Speakers',
      subtitle: 'You Have 2 Speakers',
      onEdit: () {},
      child: Column(
        children: [
          _buildSpeakerCard(
            name: 'Dr. Rina Putri, M.Ed',
            title: 'Education Technology Specialist',
            imageUrl: Assets.images.testEvent.path,
          ),
          const SizedBox(height: 12),
          _buildSpeakerCard(
            name: 'Dr. Bramasto Putra, Ph.D',
            title: 'Educational Innovation Consultant',
            imageUrl: Assets.images.testEvent.path,
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection() {
    return _buildSection(
      title: 'Sponsors',
      subtitle: 'You Have 2 Sponsor Slots',
      onEdit: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sponsor Packages
          _buildSponsorPackageCard(
            name: 'Platinum Package',
            type: 'Product',
            color: FabColors.info,
            benefits: '20pcs Backpack, 300pcs Tumblr, 15pcs Umbrella',
            description: '2 VIP Passes, Social Media Promo, Logo on Swag',
          ),
          const SizedBox(height: 12),
          _buildSponsorPackageCard(
            name: 'Gold Package',
            type: 'Monetary',
            color: FabColors.success50,
            benefits: 'Rp 14.000.000',
            description: '2 VIP Passes, Social Media Shout-Out, Logo on Event Banner',
          ),

          const SizedBox(height: 16),

          // Sponsors Invitation
          _buildLabel('Sponsors Invitation'),
          const SizedBox(height: 8),
          _buildSponsorInvitationCard(
            name: 'Tokopakedi',
            category: 'E-Commerce',
            imageUrl: Assets.images.testEvent.path,
          ),
          const SizedBox(height: 8),
          _buildSponsorInvitationCard(
            name: 'Bank Center Afrika',
            category: 'Banking & Finance',
            imageUrl: Assets.images.testEvent.path,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required VoidCallback onEdit,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FabColors.greyscale200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FabTypography.displayBold16,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: FabTypography.displayRegular12.copyWith(
                        color: FabColors.greyscale500,
                      ),
                    ),
                  ],
                ],
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFFFF8A65),
                ),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFFFF8A65),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: FabTypography.displayRegular12.copyWith(
        color: FabColors.greyscale500,
      ),
    );
  }

  Widget _buildTicketCard({
    required String name,
    required String type,
    required Color color,
    required String seats,
    required String price,
    required String benefits,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FabColors.greyscale200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: FabTypography.displayBold14,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  type,
                  style: FabTypography.displaySemiBold12.copyWith(
                    color: FabColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.event_seat_outlined, size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Text(
                seats,
                style: FabTypography.displayRegular12.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Text(
                price,
                style: FabTypography.displayRegular12.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.card_giftcard_outlined, size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  benefits,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard({
    required String name,
    required String title,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FabColors.greyscale200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FabColors.greyscale200,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageUrl,
              package: 'design',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: FabTypography.displaySemiBold14,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorPackageCard({
    required String name,
    required String type,
    required Color color,
    required String benefits,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FabColors.greyscale200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: FabTypography.displayBold14,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  type,
                  style: FabTypography.displaySemiBold12.copyWith(
                    color: FabColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.card_giftcard_outlined, size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  benefits,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.article_outlined, size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  description,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorInvitationCard({
    required String name,
    required String category,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FabColors.greyscale200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FabColors.greyscale200,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageUrl,
              package: 'design',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: FabTypography.displaySemiBold14,
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: FabColors.background,
      child: FabButton.primary(
        onPressed: () {
          // Submit action
          // _showConfirmationModal(context);
          $.navigator.push(FinancialManagementRoute());
        },
        size: FabButtonSize.large,
        width: double.infinity,
        child: Text(
          'Continue',
          style: FabTypography.displaySemiBold16.copyWith(
            color: FabColors.greyscale0,
          ),
        ),
      ),
    );
  }
}