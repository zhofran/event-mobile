import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserCubit userCubit;

  @override
  void initState() {
    super.initState();
    userCubit = $.get<UserCubit>();
    userCubit.getUser();
    
    log('Log User cubit: ${userCubit.state}', name: 'Log usercubit on home page');
  }

  @override
  void dispose() {
    // Dispose cubit jika tidak menggunakan dependency injection global
    // userCubit.close();
    super.dispose();
  }

  List<FabTab> get tabs => [
    FabTab(title: 'All Events', items: _getAllEvents()),
    FabTab(title: 'Drafts', items: _getDraftEvents()),
    FabTab(title: 'Published', items: _getPublishedEvents()),
    FabTab(title: 'Completed', items: _getCompletedEvents()),
  ];

  List<FabCardData> _getAllEvents() {
    return [
      FabCardData(
        title: 'MiningTech Summit 2025',
        status: 'Published',
        location: 'Jakarta Convention Center',
        date: '15 Nov 25 - 18 Nov 25',
        time: '07.00 WIB',
        imageUrl: Assets.images.testEvent.path,
        attendees: 820,
        sponsors: 7,
        speakers: 12,
      ),
      FabCardData(
        title: 'Digital Innovation Forum',
        status: 'Draft',
        location: 'Bali International Convention Center',
        date: '20 Dec 25 - 22 Dec 25',
        time: '09.00 WIB',
        imageUrl: Assets.images.testEvent.path,
        attendees: 650,
        sponsors: 5,
        speakers: 8,
      ),
      FabCardData(
        title: 'Startup Ecosystem Conference',
        status: 'Published',
        location: 'Surabaya Expo Center',
        date: '10 Jan 26 - 12 Jan 26',
        time: '08.30 WIB',
        imageUrl: Assets.images.testEvent.path,
        attendees: 450,
        sponsors: 3,
        speakers: 6,
      ),
    ];
  }

  List<FabCardData> _getDraftEvents() {
    return _getAllEvents().where((e) => e.status == 'Draft').toList();
  }

  List<FabCardData> _getPublishedEvents() {
    return _getAllEvents().where((e) => e.status == 'Published').toList();
  }

  List<FabCardData> _getCompletedEvents() {
    return _getAllEvents().where((e) => e.status == 'Completed').toList();
  }

  // Method untuk mendapatkan Quick Access Menu berdasarkan role
  List<QuickAccessItem> _getQuickAccessByRole(int? roleId) {
    switch (roleId) {
      case 2: // Attendee
        return [
          QuickAccessItem(
            icon: Icons.event,
            label: 'My \nAssistants',
            onTap: () => debugPrint('My Assistants tapped'),
          ),
          QuickAccessItem(
            icon: Icons.confirmation_number,
            label: 'Apply Visa',
            onTap: () => $.navigator.push(const VisaApplicantRoute()),
          ),
          QuickAccessItem(
            icon: Icons.record_voice_over,
            label: 'Community \nForum',
            onTap: () => $.navigator.push(CommunityForumRoute()),
          ),
          QuickAccessItem(
            icon: Icons.notifications,
            label: 'Q&A \nDashboard',
            onTap: () => debugPrint('Q&A Dashboard tapped'),
          ),
        ];
      
      case 3: // Speaker
        return [
          QuickAccessItem(
            icon: Icons.mic,
            label: 'My Sessions',
            onTap: () => debugPrint('My Sessions tapped'),
          ),
          QuickAccessItem(
            icon: Icons.calendar_today,
            label: 'Apply Visa',
            onTap: () => debugPrint('Apply Visa tapped'),
          ),
          QuickAccessItem(
            icon: Icons.record_voice_over,
            label: 'Audience \nInsight',
            onTap: () => debugPrint('Audience nInsight tapped'),
          ),
          QuickAccessItem(
            icon: Icons.person,
            label: 'Q&A Dashboard',
            onTap: () => debugPrint('Q&A Dashboard tapped'),
          ),
        ];
      
      case 4: // Sponsor
        return [
          QuickAccessItem(
            icon: Icons.business,
            label: 'ROI \nDashboard',
            onTap: () => debugPrint('ROI Dashboard tapped'),
          ),
          QuickAccessItem(
            icon: Icons.analytics,
            label: 'Offers & Deals',
            onTap: () => debugPrint('Offers & Deals tapped'),
          ),
          QuickAccessItem(
            icon: Icons.handshake,
            label: 'Billing',
            onTap: () => debugPrint('Billing tapped'),
          ),
          QuickAccessItem(
            icon: Icons.receipt_long,
            label: 'Marketplace',
            onTap: () => debugPrint('Marketplace tapped'),
          ),
        ];
      
      case 5: // Event Organizer
        return [
          QuickAccessItem(
            icon: Icons.event,
            label: 'Create Event',
            onTap: () => $.navigator.push(const BudgetPlanningRoute()),
          ),
          QuickAccessItem(
            icon: Icons.celebration,
            label: 'Sponsors',
            onTap: () => debugPrint('Sponsors tapped'),
          ),
          QuickAccessItem(
            icon: Icons.record_voice_over,
            label: 'Speakers',
            onTap: () => debugPrint('Speakers tapped'),
          ),
          QuickAccessItem(
            icon: Icons.people_alt_sharp,
            label: 'Vendors',
            onTap: () => debugPrint('Vendors tapped'),
          ),
        ];
      
      case 6: // Vendor
        return [
          QuickAccessItem(
            icon: Icons.store,
            label: 'My Services',
            onTap: () => debugPrint('My Services tapped'),
          ),
          QuickAccessItem(
            icon: Icons.work,
            label: 'Active Jobs',
            onTap: () => debugPrint('Active Jobs tapped'),
          ),
          QuickAccessItem(
            icon: Icons.search,
            label: 'Find Work',
            onTap: () => debugPrint('Find Work tapped'),
          ),
          QuickAccessItem(
            icon: Icons.payment,
            label: 'Payments',
            onTap: () => debugPrint('Payments tapped'),
          ),
        ];
      
      default: // Default menu jika role tidak dikenali
        return [
          QuickAccessItem(
            icon: Icons.event,
            label: 'Events',
            onTap: () => debugPrint('Events tapped'),
          ),
          QuickAccessItem(
            icon: Icons.record_voice_over,
            label: 'Community \nForum',
            onTap: () => $.navigator.push(CommunityForumRoute()),
          ),
          QuickAccessItem(
            icon: Icons.person,
            label: 'Profile',
            onTap: () => debugPrint('Profile tapped'),
          ),
          QuickAccessItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () => debugPrint('Settings tapped'),
          ),
        ];
    }
  }

  Future<void> _handleLogout() async {
    try {
      await userCubit.logout();
      if (mounted) {
        $.navigator.replaceAll([LoginRoute(onResult: (bool _) {})]);
      }
    } catch (e) {
      log('Logout error: $e', name: 'HomePage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Quick Access Menu dengan BlocBuilder untuk mengambil role
                    BlocBuilder<UserCubit, UserModel>(
                      bloc: userCubit,
                      builder: (context, state) {
                        final roleId = state.roles?.firstOrNull?.id;
                        log('Current role ID: $roleId', name: 'HomePage');
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: FabQuickAccessMenu(
                            title: 'Quick Access',
                            items: _getQuickAccessByRole(roleId),
                          ),
                        );
                      },
                    ),
                    PaddingGap.sm(),
                    FabTabSelection(
                      title: 'My Events',
                      emptyTitle: 'No Events Created Yet',
                      emptyDescription:
                          'Plan your first event, invite speakers and sponsors, and let AI handle the rest',
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: ClipOval(
              child: BlocBuilder<UserCubit, UserModel>(
                bloc: userCubit,
                builder: (context, state) {
                  // log('Response from state: ${state.roles?[0].id}', name: 'Log home page');
                  return FabImage(
                    width: 48,
                    height: 48,
                    uri: state.avatar ?? '',
                    onPressed: _handleLogout,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BlocBuilder<UserCubit, UserModel>(
              bloc: userCubit,
              builder: (context, state) {
                log('Response from state: $state', name: 'Log home page');
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.name ?? 'Guest',
                      style: FabTypography.displaySemiBold18.copyWith(
                        color: FabColors.greyscale900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      state.roles?.firstOrNull?.name ?? 'No Role',
                      style: FabTypography.bodySmallLight.copyWith(
                        color: FabColors.greyscale400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FabSearchBar(
        onChanged: (value) {
          // TODO: Implement search functionality
          log('Search: $value', name: 'HomePage');
        },
      ),
    );
  }

  Widget _buildCard(dynamic data) {
    if (data is! FabCardData) return const SizedBox.shrink();
    
    final FabCardData event = data;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to event detail
          log('Event tapped: ${event.title}', name: 'HomePage');
          $.navigator.push(
            EventDetailAttendeeRoute(
              eventTitle: event.title, 
              eventDate: event.date ?? '',
            )
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.asset(
                  event.imageUrl!,
                  package: 'design',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: FabColors.greyscale200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: FabColors.greyscale400,
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: FabTypography.displayBold16,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (event.status != null) _buildStatusBadge(event.status!),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (event.location != null) _buildInfoRow(
                    Icons.location_on_outlined,
                    event.location!,
                  ),
                  if (event.date != null) _buildInfoRow(
                    Icons.calendar_today_outlined,
                    event.date!,
                  ),
                  if (event.time != null) _buildInfoRow(
                    Icons.alarm_rounded,
                    event.time!,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildEventStats(event),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final Color statusColor = status == 'Published'
        ? Colors.green
        : status == 'Draft'
            ? Colors.orange
            : FabColors.greyscale400;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        Icon(Icons.circle, color: statusColor, size: 10),
        const SizedBox(width: 6),
        Text(
          status,
          style: FabTypography.bodySmallRegular.copyWith(
            color: FabColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: FabColors.greyscale600,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: FabTypography.bodySmallRegular.copyWith(
                fontSize: 12,
                color: FabColors.greyscale600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventStats(FabCardData event) {
    return Row(
      children: [
        if (event.attendees != null) ...[
          _buildStatItem(Icons.people_alt_outlined, '${event.attendees}'),
          const SizedBox(width: 12),
        ],
        if (event.sponsors != null) ...[
          _buildStatItem(Icons.business_outlined, '${event.sponsors}'),
          const SizedBox(width: 12),
        ],
        if (event.speakers != null)
          _buildStatItem(Icons.mic_none_outlined, '${event.speakers}'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: FabColors.greyscale600,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: FabTypography.bodySmallRegular.copyWith(
            fontSize: 12,
            color: FabColors.greyscale600,
          ),
        ),
      ],
    );
  }
}