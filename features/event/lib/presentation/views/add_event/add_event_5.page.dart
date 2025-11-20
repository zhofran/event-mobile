import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/speaker.model.dart';
import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page5.cubit.dart';
import '../widgets/invite_speaker_dialog.dart';

@RoutePage()
class AddEvent5Page extends StatefulWidget {
  const AddEvent5Page({super.key});

  @override
  State<AddEvent5Page> createState() => _AddEvent5PageState();
}

class _AddEvent5PageState extends State<AddEvent5Page> {
  late BudgetPlannerCubit budgetPlannerCubit;
  late EventPage5Cubit eventPage5Cubit;

  int currentStep = 6;
  int totalSteps = 8;

  late List<FabTabV2> tabs;

  @override
  void initState() {
    super.initState();
    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    eventPage5Cubit = $.get<EventPage5Cubit>();

    // Initialize cubit with dummy data
    eventPage5Cubit.initialize();

    // Load saved speakers
    _loadSavedSpeakers();

    tabs = [
      FabTabV2(title: 'Recommendations', items: []),
      FabTabV2(title: 'All Speakers', items: []),
      FabTabV2(title: 'My Speakers', items: []),
    ];
  }

  Future<void> _loadSavedSpeakers() async {
    await eventPage5Cubit.loadSpeakersLocally();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPage5Cubit, EventPage5State>(
      bloc: eventPage5Cubit,
      builder: (context, state) {
        final totalFee = eventPage5Cubit.calculateTotalFee();
        final maxBudget = budgetPlannerCubit.state.speakerFees.toDouble();
        final isOverBudget = eventPage5Cubit.isOverBudget(maxBudget);

        return Scaffold(
          backgroundColor: FabColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const FabPageHeader(title: 'Create Event'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedStepProgressIndicator(
                      currentStep: currentStep, totalSteps: totalSteps),
                ),
                PaddingGap.xl(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildWelcomeSection(),
                ),
                PaddingGap.md(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Speaker Selected Count
                      Row(
                        children: [
                          Text(
                            'Speaker Selected: ',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          Text(
                            '${state.selectedSpeakers.length} Speaker${state.selectedSpeakers.length != 1 ? 's' : ''}',
                            style: FabTypography.bodySmallBold,
                          ),
                        ],
                      ),
                      PaddingGap.xxs(),
                      // Speaker Total Fee
                      Row(
                        children: [
                          Text(
                            'Speaker Total Fee: ',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          Text(
                            FabFunction.formatRupiah(currency: totalFee),
                            style: FabTypography.bodySmallBold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PaddingGap.xs(),
                _buildSearchBar(),
                PaddingGap.xs(),
                // ADDED: Invite external speaker section
                _buildInviteSection(),
                // Tab Selection with Expanded (Only scrollable area)
                Expanded(
                  child: _buildListSpeaker(state),
                ),
                _buildFooter(state, totalFee, maxBudget, isOverBudget),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const FabTextStyled(
        'Choose Speakers',
        style: FabTypography.displayBold22,
      ),
      PaddingGap.xs(),
      FabTextStyled(
        'Total budget for speakers is capped at ${FabFunction.formatRupiah(currency: budgetPlannerCubit.state.speakerFees.toDouble())}. This includes honorarium, travel, and accommodation.',
        style: FabTypography.displayRegular14
            .copyWith(color: FabColors.greyscale400),
      ),
    ]);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FabSearchBar(
        onChanged: (value) {
          // TODO: Implement search functionality
        },
      ),
    );
  }

  /// ADDED: Invite external speaker section
  Widget _buildInviteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: RichText(
        text: TextSpan(
          style: FabTypography.bodySmallRegular.copyWith(
            color: FabColors.greyscale600,
          ),
          children: [
            const TextSpan(text: 'Have a great speaker in mind? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: _showInviteExternalSpeakerDialog,
                child: Text(
                  'Invite them to your event',
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: const Color(0xFFFF8A65),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSpeaker(EventPage5State state) {
    // Get invited speaker IDs for filtering
    final invitedSpeakerIds = state.invitedSpeakers.map((s) => s.id).toSet();

    // Filter out invited speakers from allSpeakers to avoid duplicates
    final nonInvitedSpeakers = state.allSpeakers
        .where((speaker) => !invitedSpeakerIds.contains(speaker.id))
        .toList();

    // Combine invited speakers (at top) with non-invited speakers for Recommendations tab
    final recommendationsSpeakers = [
      ...state.invitedSpeakers,
      ...nonInvitedSpeakers,
    ];

    // Update tabs with appropriate data
    final updatedTabs = [
      FabTabV2(title: 'Recommendations', items: recommendationsSpeakers),
      FabTabV2(title: 'All Speakers', items: state.allSpeakers),
      FabTabV2(title: 'My Speakers', items: state.invitedSpeakers),
    ];

    return FabTabSelectionV2(
      emptyTitle: 'No Speakers Available',
      emptyDescription:
          'We are currently finding the best speakers for your event',
      emptyIllustration: Center(
        child: Image.asset(
          Assets.images.notifPermission.path,
          width: 120,
          height: 120,
          package: 'design',
        ),
      ),
      cardBuilder: (data) => _buildCard(data, state),
      tabs: updatedTabs,
    );
  }

  Widget _buildCard(dynamic data, EventPage5State state) {
    final Speaker speaker = data as Speaker;
    final bool isSelected = state.selectedSpeakers.contains(speaker.id);
    final bool isInvited = speaker.status == 'invited';

    return GestureDetector(
      onTap: () {
        eventPage5Cubit.toggleSpeakerSelection(speaker.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFF8A65) : FabColors.greyscale200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invited Speaker - Simplified UI
            if (isInvited) ...[
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: FabColors.greyscale200,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 30,
                      color: FabColors.greyscale500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          speaker.name,
                          style: FabTypography.bodySmallBold.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          speaker.title,
                          style: FabTypography.bodySmallRegular.copyWith(
                            fontSize: 12,
                            color: FabColors.greyscale600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Fee ${FabFunction.formatRupiah(currency: speaker.fee)}',
                style: FabTypography.bodySmallMedium.copyWith(
                  fontSize: 12,
                  color: FabColors.textPrimary,
                ),
              ),
            ] else ...[
              // Regular Speaker - Full UI
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: FabColors.textPrimary,
                    ),
                    child: Image.asset(
                      Assets.images.testEvent.path,
                      width: 50,
                      height: 50,
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
                          speaker.name,
                          style: FabTypography.bodySmallBold.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          speaker.title,
                          style: FabTypography.bodySmallRegular.copyWith(
                            fontSize: 12,
                            color: FabColors.greyscale600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        color: Color(0xFFFF8A65),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (speaker.location.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      speaker.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: FabColors.greyscale600,
                      ),
                    ),
                  ],
                ),
              if (speaker.location.isNotEmpty) const SizedBox(height: 4),
              if (speaker.specialize.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        speaker.specialize,
                        style: const TextStyle(
                          fontSize: 12,
                          color: FabColors.greyscale600,
                        ),
                      ),
                    ),
                  ],
                ),
              if (speaker.specialize.isNotEmpty) const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 16,
                    color: FabColors.greyscale500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${speaker.totalEvent} Events',
                    style: const TextStyle(
                      fontSize: 12,
                      color: FabColors.greyscale600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Fee ${FabFunction.formatRupiah(currency: speaker.fee)}',
                style: FabTypography.bodySmallMedium.copyWith(
                  fontSize: 12,
                  color: FabColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(
    EventPage5State state,
    double totalFee,
    double maxBudget,
    bool isOverBudget,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(
        color: FabColors.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOverBudget && state.selectedSpeakers.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total fee exceeds budget by ${FabFunction.formatRupiah(currency: totalFee - maxBudget)}',
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (state.selectedSpeakers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${state.selectedSpeakers.length} speaker${state.selectedSpeakers.length > 1 ? 's' : ''} selected',
                style: FabTypography.displayRegular14.copyWith(
                  color: FabColors.greyscale600,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Select speakers for your event',
                style: FabTypography.displayRegular14.copyWith(
                  color: FabColors.greyscale400,
                ),
              ),
            ),
          FabButton.primary(
            onPressed: state.selectedSpeakers.isEmpty
                ? null
                : () async {
                    if (isOverBudget) {
                      _showBudgetExceededDialog(totalFee, maxBudget);
                    } else {
                      await eventPage5Cubit.saveSpeakersLocally();
                      if (!mounted) {
                        return;
                      }

                      FabSnackbar.success(
                        context: context,
                        content:
                            'Create Ticket Selling Time saved successfully!',
                      );
                      await $.navigator.push(const AddEvent6Route());
                    }
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
        ],
      ),
    );
  }

  void _showBudgetExceededDialog(double totalFee, double maxBudget) {
    final exceeded = totalFee - maxBudget;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        title: Center(
          child: FabTextStyled(
            'Speaker Budget Exceeded',
            style: FabTypography.displaySemiBold18.copyWith(
              color: FabColors.greyscale900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: FabTextStyled(
          'You\'ve spent ${FabFunction.formatRupiah(currency: exceeded)} more than your allocated speaker budget. Try removing some speakers or adjusting your budget.',
          style: FabTypography.bodySmallRegular.copyWith(
            color: FabColors.greyscale600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FabButton.primary(
                onPressed: () {
                  Navigator.pop(context);
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  'Adjust Speakers',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  $.navigator.push(const AddEvent6Route());
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
        ],
      ),
    );
  }

  /// ADDED: Show invite external speaker dialog
  void _showInviteExternalSpeakerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InviteExternalSpeakerDialog(
        onSpeakerAdded: (speakerData) {
          // Parse fee from formatted string (e.g., "10,000,000" to 10000000)
          final feeString = speakerData['fee']?.toString() ?? '0';
          final cleanedFee = feeString.replaceAll(',', '').replaceAll('.', '');
          final parsedFee = double.tryParse(cleanedFee) ?? 0;

          // Create Speaker object from invited data
          final invitedSpeaker = Speaker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            speakerUserId: speakerData['email'] ?? '',
            speakerName: speakerData['name'] ?? '',
            email: speakerData['email'] ?? '',
            phone: '',
            organization: '',
            bio: '',
            photo: '',
            speakerFee: parsedFee,
            status: 'invited',
            name: speakerData['name'] ?? '',
            title: speakerData['title'] ?? 'Invited Speaker',
            location: '',
            specialize: '',
            totalEvent: 0,
            fee: parsedFee,
          );

          // Add to cubit
          eventPage5Cubit.addInvitedSpeaker(invitedSpeaker);

          // Show success message
          FabSnackbar.success(
            context: context,
            content: 'Invitation sent to ${speakerData['email']}',
          );
        },
      ),
    );
  }
}
