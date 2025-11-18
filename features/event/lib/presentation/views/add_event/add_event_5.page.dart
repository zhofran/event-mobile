import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../../cubits/budget_planner.cubit.dart';
import '../widgets/invite_speaker_dialog.dart';

@RoutePage()
class AddEvent5Page extends StatefulWidget {
  AddEvent5Page({super.key});

  @override
  State<AddEvent5Page> createState() => _AddEvent5PageState();
}

class _AddEvent5PageState extends State<AddEvent5Page> {
  late BudgetPlannerCubit budgetPlannerCubit;

  int currentStep = 6;
  int totalSteps = 8;

  // Set untuk menyimpan speaker yang dipilih
  Set<String> selectedSpeakers = {};

  // List untuk menyimpan semua speaker data
  final List<DataCardSpeaker> allSpeakers = [
    DataCardSpeaker(
        id: '1',
        name: 'Dr. Rina Putri, M.Ed',
        title: 'Education Technology Specialist',
        location: 'Jakarta, Indonesia',
        specialize: 'AI • Education • Creative Thinking',
        total_event: 30,
        fee: FabFunction.formatRupiah(currency: double.parse('5000000'))),
    DataCardSpeaker(
        id: '2',
        name: 'Dr. Bramasto Putra, Ph.D',
        title: 'Educational Innovation Consultant',
        location: 'Surabaya, Indonesia',
        specialize: 'EdTech • Gamification • Curriculum Design',
        total_event: 45,
        fee: FabFunction.formatRupiah(currency: double.parse('15000000'))),
    DataCardSpeaker(
        id: '3',
        name: 'Naomi Pardede, B.A.',
        title: 'Student Researcher',
        location: 'Medan, Indonesia',
        specialize: 'Gen Z • Social Media • Youth Empowerment',
        total_event: 0,
        fee: FabFunction.formatRupiah(currency: double.parse('3000000'))),
  ];

  final List<FabTab> tabs = [
    FabTab(title: 'Recommendations', items: []),
    FabTab(title: 'All Speakers', items: []),
    FabTab(title: 'My Speakers', items: []),
  ];

  @override
  void initState() {
    super.initState();
    budgetPlannerCubit = $.get<BudgetPlannerCubit>();

    tabs[0].items = allSpeakers;
  }

  /// Calculate total fee dari speakers yang dipilih
  int _calculateTotalFee() {
    int total = 0;

    for (String speakerId in selectedSpeakers) {
      DataCardSpeaker? speaker = allSpeakers.firstWhere(
        (s) => s.id == speakerId,
        orElse: () => DataCardSpeaker(),
      );

      if (speaker.fee != null) {
        int feeValue = _parseFeeToInt(speaker.fee!);
        total += feeValue;
      }
    }

    return total;
  }

  /// Parse fee dari format "Rp7.000.000" ke integer 7000000
  int _parseFeeToInt(String feeString) {
    String cleanedFee = feeString
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(' ', '')
        .trim();

    return int.tryParse(cleanedFee) ?? 0;
  }

  /// Format integer ke Rupiah string
  String _formatToRupiah(int amount) {
    return FabFunction.formatRupiah(currency: amount.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    // Update tabs dengan data dari allSpeakers

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
            PaddingGap.md(),
            Expanded(
              child: ListView(
                children: [
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
                              '${selectedSpeakers.length} Speaker${selectedSpeakers.length != 1 ? 's' : ''}',
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
                              _formatToRupiah(_calculateTotalFee()),
                              style: FabTypography.bodySmallBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PaddingGap.xs(),

                  _buildSearchBar(),

                  // ADDED: Invite external speaker section
                  _buildInviteSection(),

                  _buildListSpeaker(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
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

  Widget _buildListSpeaker() {
    return FabTabSelection(
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
      cardBuilder: _buildCard,
      tabs: tabs,
    );
  }

  Widget _buildCard(dynamic data) {
    final DataCardSpeaker speaker = data as DataCardSpeaker;
    final bool isSelected = selectedSpeakers.contains(speaker.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSpeakers.remove(speaker.id);
          } else {
            if (speaker.id != null) {
              selectedSpeakers.add(speaker.id!);
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
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
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: FabColors.textPrimary),
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
                        speaker.name ?? '',
                        style: FabTypography.bodySmallBold.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        speaker.title ?? '',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(width: 6),
                Text(
                  speaker.location ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: FabColors.greyscale600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
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
                    speaker.specialize ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: FabColors.greyscale600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(width: 6),
                Text(
                  '${speaker.total_event ?? 0} Events',
                  style: const TextStyle(
                    fontSize: 12,
                    color: FabColors.greyscale600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  speaker.fee ?? 'Rp0',
                  style: FabTypography.bodySmallMedium
                      .copyWith(fontSize: 12, color: FabColors.greyscale600),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    int totalFee = _calculateTotalFee();
    int maxBudget = budgetPlannerCubit.state.speakerFees.toInt();
    bool isOverBudget = totalFee > maxBudget;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(
        color: FabColors.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOverBudget && selectedSpeakers.isNotEmpty)
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
                      'Total fee exceeds budget by ${_formatToRupiah(totalFee - maxBudget)}',
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (selectedSpeakers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${selectedSpeakers.length} speaker${selectedSpeakers.length > 1 ? 's' : ''} selected',
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
            onPressed: selectedSpeakers.isEmpty
                ? null
                : () {
                    if (isOverBudget) {
                      _showBudgetExceededDialog();
                    } else {
                      $.navigator.push(const AddEvent6Route());
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

  void _showBudgetExceededDialog() {
    int totalFee = _calculateTotalFee();
    int maxBudget = budgetPlannerCubit.state.speakerFees.toInt();
    int exceeded = totalFee - maxBudget;

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
          'You\'ve spent ${_formatToRupiah(exceeded)} more than your allocated speaker budget. Try removing some speakers or adjusting your budget.',
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
          // Handle speaker data yang ditambahkan
          debugPrint('Speaker added: $speakerData');

          // TODO: Add speaker to allSpeakers list or send to API

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invitation sent to ${speakerData['email']}'),
              backgroundColor: FabColors.success,
            ),
          );
        },
      ),
    );
  }
}

class DataCardSpeaker {
  final String? id;
  final String? name;
  final String? title;
  final String? location;
  final String? specialize;
  final int? total_event;
  final String? fee;

  DataCardSpeaker({
    this.id,
    this.name,
    this.title,
    this.location,
    this.specialize,
    this.total_event,
    this.fee,
  });
}
