import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/intl.dart';
import 'package:flutter/material.dart';

import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page1.cubit.dart';
import '../../cubits/event_page2.cubit.dart';
import '../../cubits/event_page3.cubit.dart';
import '../../cubits/event_page5.cubit.dart';
import '../../cubits/event_page6.cubit.dart';
import '../../cubits/event_page7.cubit.dart';
import '../../cubits/invite_sponsors.cubit.dart';

@RoutePage()
class AddEvent8Page extends StatefulWidget {
  const AddEvent8Page({super.key});

  @override
  State<AddEvent8Page> createState() => _AddEvent8PageState();
}

class _AddEvent8PageState extends State<AddEvent8Page> {
  late EventPage1Cubit eventPage1Cubit;
  late BudgetPlannerCubit budgetCubit;
  late EventPage2Cubit eventPage2Cubit;
  late EventPage3Cubit eventPage3Cubit;
  late EventPage5Cubit eventPage5Cubit;
  late EventPage6Cubit eventPage6Cubit;
  late EventPage7Cubit eventPage7Cubit;
  late InviteSponsorsCubit inviteSponsorsCubit;

  int currentStep = 9;
  int totalSteps = 10;

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _loadAllData();
  }

  void _initializeCubits() {
    eventPage1Cubit = $.get<EventPage1Cubit>();
    budgetCubit = $.get<BudgetPlannerCubit>();
    eventPage2Cubit = $.get<EventPage2Cubit>();
    eventPage3Cubit = $.get<EventPage3Cubit>();
    eventPage5Cubit = $.get<EventPage5Cubit>();
    eventPage6Cubit = $.get<EventPage6Cubit>();
    eventPage7Cubit = $.get<EventPage7Cubit>();
    inviteSponsorsCubit = $.get<InviteSponsorsCubit>();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      eventPage1Cubit.loadEventDetailsLocally(),
      budgetCubit.loadBudgetPlanLocally(),
      eventPage2Cubit.loadEventScheduleLocally(),
      eventPage3Cubit.loadSeatPlansLocally(),
      eventPage5Cubit.loadSpeakersLocally(),
      eventPage6Cubit.loadVendorsLocally(),
      eventPage7Cubit.loadSponsorshipsLocally(),
      inviteSponsorsCubit.loadSponsorsLocally(),
    ]);
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

                    // Vendors Section
                    _buildVendorsSection(),

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

  Widget _buildEventSummarySection() {
    return BlocBuilder<EventPage1Cubit, EventPage1State>(
      bloc: eventPage1Cubit,
      builder: (context, state) {
        return _buildSection(
          title: 'Event Summary',
          onEdit: () async {
            final result = await context.router.push(AddEvent1Route(fromReview: true));
            if (result == true) {
              _loadAllData();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              _buildLabel('Event Name'),
              const SizedBox(height: 4),
              Text(
                state.eventName.isEmpty ? '-' : state.eventName,
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
                        Text(
                          state.eventType.isEmpty ? '-' : state.eventType,
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
                        Text(
                          state.eventFormat.isEmpty ? '-' : state.eventFormat,
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
              Text(
                state.eventDescription.isEmpty ? '-' : state.eventDescription,
                style: FabTypography.bodySmallSemiBold,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 16),

              // Event Banner
              _buildLabel('Event Banner'),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: state.eventBanner.isNotEmpty
                    ? Image.network(
                        state.eventBanner,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 160,
                            color: FabColors.greyscale200,
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 48,
                                color: FabColors.greyscale400,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 160,
                        color: FabColors.greyscale200,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: FabColors.greyscale400,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleVenueSection() {
    return BlocBuilder<EventPage2Cubit, EventPage2State>(
      bloc: eventPage2Cubit,
      builder: (context, state) {
        return _buildSection(
          title: 'Schedule & Venue',
          onEdit: () async {
            final result = await context.router.push(AddEvent2Route(fromReview: true));
            if (result == true) {
              _loadAllData();
            }
          },
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
                        Text(
                          DateFormat('dd MMMM yyyy').format(state.date),
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
                        Text(
                          state.time.isEmpty ? '-' : state.time,
                          style: FabTypography.displayBold14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (state.eventFormat == EventFormat.offline) ...[
                const SizedBox(height: 16),

                // Venue
                _buildLabel('Venue'),
                const SizedBox(height: 4),
                Text(
                  state.venue?.isEmpty ?? true ? '-' : state.venue!,
                  style: FabTypography.displaySemiBold14,
                ),

                const SizedBox(height: 12),

                // Address
                _buildLabel('Address'),
                const SizedBox(height: 4),
                Text(
                  state.address?.isEmpty ?? true ? '-' : state.address!,
                  style: FabTypography.displayBold14.copyWith(
                    color: FabColors.greyscale600,
                  ),
                ),

                const SizedBox(height: 12),

                // Location
                _buildLabel('Location'),
                const SizedBox(height: 4),
                Text(
                  state.location?.isEmpty ?? true ? '-' : state.location!,
                  style: FabTypography.displayBold14.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],

              if (state.eventFormat == EventFormat.online) ...[
                const SizedBox(height: 16),

                // Platform
                _buildLabel('Platform'),
                const SizedBox(height: 4),
                Text(
                  state.platform?.isEmpty ?? true ? '-' : state.platform!,
                  style: FabTypography.displaySemiBold14,
                ),

                const SizedBox(height: 12),

                // Link
                _buildLabel('Link'),
                const SizedBox(height: 4),
                Text(
                  state.link?.isEmpty ?? true ? '-' : state.link!,
                  style: FabTypography.displayBold14.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Capacity
              _buildLabel('Capacity'),
              const SizedBox(height: 4),
              Text(
                state.capacity.toString(),
                style: FabTypography.displayBold14,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketSeatingSection() {
    return BlocBuilder<EventPage3Cubit, EventPage3State>(
      bloc: eventPage3Cubit,
      builder: (context, state) {
        return _buildSection(
          title: 'Ticket & Seating',
          subtitle: state.seatPlans.isEmpty
              ? 'No seat plans yet'
              : 'You Have ${state.seatPlans.length} Plan${state.seatPlans.length > 1 ? 's' : ''}',
          onEdit: () async {
            final result = await context.router.push(AddEvent3Route(fromReview: true));
            if (result == true) {
              _loadAllData();
            }
          },
          child: state.seatPlans.isEmpty
              ? const Center(
                  child: Text(
                    'No seat plans configured',
                    style: FabTypography.bodySmallRegular,
                  ),
                )
              : Column(
                  children: state.seatPlans
                      .asMap()
                      .entries
                      .map((entry) {
                        final index = entry.key;
                        final plan = entry.value;
                        final percentage = state.capacity > 0
                            ? (plan.quota / state.capacity * 100).toStringAsFixed(0)
                            : '0';
                        
                        final color = index == 0
                            ? FabColors.success25
                            : index == 1
                                ? FabColors.info
                                : FabColors.warning;

                        return Column(
                          children: [
                            if (index > 0) const SizedBox(height: 12),
                            _buildTicketCard(
                              name: plan.ticketName,
                              type: plan.ticketType,
                              color: color,
                              seats: '${plan.quota} seats ($percentage%)',
                              price: 'Rp${NumberFormat('#,###').format(plan.price)}',
                              benefits: plan.description ?? '-',
                            ),
                          ],
                        );
                      })
                      .toList(),
                ),
        );
      },
    );
  }

  Widget _buildSpeakersSection() {
    return BlocBuilder<EventPage5Cubit, EventPage5State>(
      bloc: eventPage5Cubit,
      builder: (context, state) {
        final totalSpeakers = state.selectedSpeakers.length + state.invitedSpeakers.length;
        final selectedSpeakersData = state.allSpeakers
            .where((s) => state.selectedSpeakers.contains(s.id))
            .toList();

        return _buildSection(
          title: 'Speakers',
          subtitle: totalSpeakers == 0
              ? 'No speakers yet'
              : 'You Have $totalSpeakers Speaker${totalSpeakers > 1 ? 's' : ''}',
          onEdit: () async {
            final result = await context.router.push(AddEvent5Route(fromReview: true));
            if (result == true) {
              _loadAllData();
            }
          },
          child: totalSpeakers == 0
              ? const Center(
                  child: Text(
                    'No speakers selected',
                    style: FabTypography.bodySmallRegular,
                  ),
                )
              : Column(
                  children: [
                    ...selectedSpeakersData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final speaker = entry.value;
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 12),
                          _buildSpeakerCard(
                            name: speaker.name,
                            title: speaker.title,
                            imageUrl: speaker.photo.isEmpty ? Assets.images.testEvent.path : speaker.photo,
                          ),
                        ],
                      );
                    }),
                    ...state.invitedSpeakers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final speaker = entry.value;
                      return Column(
                        children: [
                          if (selectedSpeakersData.isNotEmpty || index > 0) const SizedBox(height: 12),
                          _buildSpeakerCard(
                            name: speaker.name,
                            title: speaker.title,
                            imageUrl: speaker.photo.isEmpty ? Assets.images.testEvent.path : speaker.photo,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildVendorsSection() {
    return BlocBuilder<EventPage6Cubit, EventPage6State>(
      bloc: eventPage6Cubit,
      builder: (context, state) {
        return _buildSection(
          title: 'Vendors',
          subtitle: state.vendors.isEmpty
              ? 'No vendors yet'
              : 'You Have ${state.vendors.length} Vendor${state.vendors.length > 1 ? 's' : ''}',
          onEdit: () async {
            final result = await context.router.push(AddEvent6Route(fromReview: true));
            if (result == true) {
              _loadAllData();
            }
          },
          child: state.vendors.isEmpty
              ? const Center(
                  child: Text(
                    'No vendors configured',
                    style: FabTypography.bodySmallRegular,
                  ),
                )
              : Column(
                  children: state.vendors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final vendor = entry.value;
                    final color = index == 0
                        ? FabColors.info
                        : index == 1
                            ? FabColors.success50
                            : FabColors.warning;

                    return Column(
                      children: [
                        if (index > 0) const SizedBox(height: 12),
                        _buildVendorCard(
                          name: vendor.vendor,
                          category: vendor.categories,
                          color: color,
                          budget: 'Rp ${NumberFormat('#,###').format(vendor.budget)}',
                          description: vendor.description,
                        ),
                      ],
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Widget _buildSponsorsSection() {
    return BlocBuilder<EventPage7Cubit, EventPage7State>(
      bloc: eventPage7Cubit,
      builder: (context, page7State) {
        return BlocBuilder<InviteSponsorsCubit, InviteSponsorsState>(
          bloc: inviteSponsorsCubit,
          builder: (context, inviteState) {
            final totalPackages = page7State.sponsorships.length;
            final totalInvitations = inviteState.selectedSponsors.length;
            final totalSponsors = totalPackages + totalInvitations;

            final selectedSponsorsData = inviteState.allSponsors
                .where((s) => inviteState.selectedSponsors.contains(s.id))
                .toList();

            return _buildSection(
              title: 'Sponsors',
              subtitle: totalSponsors == 0
                  ? 'No sponsors yet'
                  : 'You Have $totalSponsors Sponsor${totalSponsors > 1 ? 's' : ''}',
              onEdit: () async {
                final result = await context.router.push(AddEvent7Route(fromReview: true));
                if (result == true) {
                  _loadAllData();
                }
              },
              child: totalSponsors == 0
                  ? const Center(
                      child: Text(
                        'No sponsors configured',
                        style: FabTypography.bodySmallRegular,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sponsor Packages
                        if (page7State.sponsorships.isNotEmpty) ...[
                          ...page7State.sponsorships.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sponsorship = entry.value;
                            final color = index == 0
                                ? FabColors.info
                                : index == 1
                                    ? FabColors.success50
                                    : FabColors.warning;

                            final benefits = sponsorship.type == 'Product'
                                ? sponsorship.productAmount
                                : 'Rp ${NumberFormat('#,###').format(double.tryParse(sponsorship.productAmount) ?? 0)}';

                            return Column(
                              children: [
                                if (index > 0) const SizedBox(height: 12),
                                _buildSponsorPackageCard(
                                  name: sponsorship.title,
                                  type: sponsorship.type,
                                  color: color,
                                  benefits: benefits,
                                  description: sponsorship.description,
                                ),
                              ],
                            );
                          }),
                        ],

                        // Sponsors Invitation
                        if (selectedSponsorsData.isNotEmpty) ...[
                          if (page7State.sponsorships.isNotEmpty) const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel('Sponsors Invitation'),
                              TextButton.icon(
                                onPressed: () async {
                                  final result = await context.router.push(InviteSponsorsRoute(fromReview: true));
                                  if (result == true) {
                                    _loadAllData();
                                  }
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: Color(0xFFFF8A65),
                                ),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Color(0xFFFF8A65),
                                    fontSize: 12,
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
                          const SizedBox(height: 8),
                          ...selectedSponsorsData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sponsor = entry.value;
                            return Column(
                              children: [
                                if (index > 0) const SizedBox(height: 8),
                                _buildSponsorInvitationCard(
                                  name: sponsor.name,
                                  category: sponsor.industry,
                                  imageUrl: sponsor.logo?.isEmpty ?? true
                                      ? Assets.images.testEvent.path
                                      : sponsor.logo!,
                                ),
                              ],
                            );
                          }),
                        ],
                      ],
                    ),
            );
          },
        );
      },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              const Icon(Icons.event_seat_outlined,
                  size: 14, color: FabColors.greyscale600),
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
              const Icon(Icons.local_offer_outlined,
                  size: 14, color: FabColors.greyscale600),
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
              const Icon(Icons.card_giftcard_outlined,
                  size: 14, color: FabColors.greyscale600),
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
            decoration: const BoxDecoration(
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

  Widget _buildVendorCard({
    required String name,
    required String category,
    required Color color,
    required String budget,
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
              Expanded(
                child: Text(
                  name,
                  style: FabTypography.displayBold14,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
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
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 14, color: FabColors.greyscale600),
              const SizedBox(width: 4),
              Text(
                budget,
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
              const Icon(Icons.description_outlined,
                  size: 14, color: FabColors.greyscale600),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              const Icon(Icons.card_giftcard_outlined,
                  size: 14, color: FabColors.greyscale600),
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
              const Icon(Icons.article_outlined,
                  size: 14, color: FabColors.greyscale600),
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
            decoration: const BoxDecoration(
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
          $.navigator.push(const FinancialManagementRoute());
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
