import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/sponsor.model.dart';
import '../../cubits/invite_sponsors.cubit.dart';

@RoutePage()
class InviteSponsorsPage extends StatefulWidget {
  const InviteSponsorsPage({super.key, @queryParam this.fromReview = false});

  final bool fromReview;

  @override
  State<InviteSponsorsPage> createState() => _InviteSponsorsPageState();
}

class _InviteSponsorsPageState extends State<InviteSponsorsPage> {
  late InviteSponsorsCubit inviteSponsorsCubit;

  int currentStep = 8;
  int totalSteps = 10;

  late List<FabTabV2> tabs;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    inviteSponsorsCubit = $.get<InviteSponsorsCubit>();

    // Initialize cubit with dummy data
    inviteSponsorsCubit.initialize();

    // Load saved sponsors
    _loadSavedSponsors();

    tabs = [
      FabTabV2(title: 'Recommendations', items: []),
      FabTabV2(title: 'All Sponsors', items: []),
      FabTabV2(title: 'My Sponsors', items: []),
    ];
  }

  Future<void> _loadSavedSponsors() async {
    await inviteSponsorsCubit.loadSponsorsLocally();
  }

  List<Sponsor> _filterSponsors(List<Sponsor> sponsors) {
    if (searchQuery.isEmpty) {
      return sponsors;
    }

    return sponsors.where((sponsor) {
      final nameMatch =
          sponsor.name.toLowerCase().contains(searchQuery.toLowerCase());
      final industryMatch =
          sponsor.industry.toLowerCase().contains(searchQuery.toLowerCase());
      final locationMatch =
          sponsor.location.toLowerCase().contains(searchQuery.toLowerCase());

      return nameMatch || industryMatch || locationMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<InviteSponsorsCubit, InviteSponsorsState>(
        bloc: inviteSponsorsCubit,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: FabColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  const FabPageHeader(title: 'Create Event'),
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
                    child: _buildWelcomeSection(state),
                  ),
                  PaddingGap.md(),
                  _buildSearchBar(),
                  PaddingGap.xs(),
                  // Tab Selection with Expanded (Only scrollable area)
                  Expanded(
                    child: _buildListSponsor(state),
                  ),
                  _buildFooter(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(InviteSponsorsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Invite Sponsors',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Choose which sponsors to invite and which slots they can apply for.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
        ),
        PaddingGap.md(),
        FabTextStyled(
          '${state.selectedSponsors.length} Sponsors Selected',
          style: FabTypography.displaySemiBold16
              .copyWith(color: FabColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FabSearchBar(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildListSponsor(InviteSponsorsState state) {
    // Filter sponsors based on search query
    final filteredSponsors = _filterSponsors(state.allSponsors);

    // Update tabs with filtered data
    final updatedTabs = [
      FabTabV2(title: 'Recommendations', items: filteredSponsors),
      FabTabV2(title: 'All Sponsors', items: filteredSponsors),
      FabTabV2(title: 'My Sponsors', items: []),
    ];

    return FabTabSelectionV2(
      emptyTitle: 'No Sponsors Available',
      emptyDescription:
          'We are currently finding the best sponsors for your event',
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

  Widget _buildCard(dynamic data, InviteSponsorsState state) {
    final Sponsor sponsor = data as Sponsor;
    final bool isSelected = state.selectedSponsors.contains(sponsor.id);

    return GestureDetector(
      onTap: () {
        inviteSponsorsCubit.toggleSponsorSelection(sponsor.id);
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
            Row(
              children: [
                // Logo placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: FabColors.greyscale100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      sponsor.name.substring(0, 1).toUpperCase(),
                      style: FabTypography.displayBold22.copyWith(
                        color: FabColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sponsor.name,
                              style: FabTypography.displaySemiBold16.copyWith(
                                color: FabColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'View Profile',
                              style: FabTypography.bodySmallMedium.copyWith(
                                color: const Color(0xFFFF8A65),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sponsor.industry,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.greyscale500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(width: 4),
                Text(
                  sponsor.location,
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.greyscale500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.handshake_outlined,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(width: 4),
                Text(
                  sponsor.type,
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.greyscale500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: FabColors.greyscale500,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    sponsor.description,
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: FabColors.greyscale500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(InviteSponsorsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(
        color: FabColors.background,
      ),
      child: Column(
        children: [
          FabButton.primary(
            onPressed: state.selectedSponsors.isEmpty
                ? null
                : () async {
                    await inviteSponsorsCubit.saveSponsorsLocally();
                    if (!mounted) {
                      return;
                    }

                    FabSnackbar.success(
                      context: context,
                      content: 'Sponsors saved successfully!',
                    );

                    if (widget.fromReview) {
                      context.router.pop(true);
                    } else {
                      await $.navigator.push(const AddEvent8Route());
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
}
