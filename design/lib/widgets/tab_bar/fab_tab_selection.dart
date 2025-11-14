import 'package:flutter/material.dart';

import '../../design.dart';

/// Model untuk data tab
class FabTab {
  final String title;
  final List<dynamic> items;

  FabTab({
    required this.title,
    required this.items,
  });
}

/// Model untuk data card (bisa kamu sesuaikan)
class FabCardData {
  final String title;
  final String? subtitle;
  final String? location;
  final String? date;
  final String? time;
  final String? status;
  final String? imageUrl;
  final int? attendees;
  final int? sponsors;
  final int? speakers;

  FabCardData({
    required this.title,
    this.subtitle,
    this.location,
    this.date,
    this.time,
    this.status,
    this.imageUrl,
    this.attendees,
    this.sponsors,
    this.speakers,
  });
}

/// Widget global utama
class FabTabSelection extends StatefulWidget {
  final String? title;
  final List<FabTab> tabs;
  final VoidCallback? onCreatePressed;
  final String emptyTitle;
  final String emptyDescription;
  final Widget? emptyIllustration;
  final Widget Function(dynamic) cardBuilder;

  const FabTabSelection({
    super.key,
    this.title,
    required this.tabs,
    required this.cardBuilder,
    this.onCreatePressed,
    this.emptyTitle = 'No Data Yet',
    this.emptyDescription = 'There\'s nothing here yet. Try adding new items.',
    this.emptyIllustration,
  });

  @override
  State<FabTabSelection> createState() => _FabTabSelectionState();
}

class _FabTabSelectionState extends State<FabTabSelection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hitung tinggi yang tersedia
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.6; // 60% dari tinggi layar
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Visibility(
          visible: widget.title != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.title ?? '',
              style: FabTypography.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Tab Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            dividerHeight: 0,
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: FabColors.background,
            tabs: widget.tabs.map((tab) => Tab(text: tab.title)).toList(),
          ),
        ),

        // Tab Views
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: availableHeight.clamp(300, 600), // Min 300, Max 600
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs.map((tab) {
                if (tab.items.isEmpty) {
                  return _buildEmptyState(context);
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: tab.items.length,
                    itemBuilder: (context, index) {
                      final data = tab.items[index];
                      return widget.cardBuilder(data);
                    },
                  );
                }
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.emptyIllustration ??
            Icon(
              Icons.event_note_outlined,
              size: 80, 
              color: Colors.orange.shade300
            ),

            const SizedBox(height: 16),
            
            Text(
              widget.emptyTitle,
              style: Theme.of(context).textTheme.titleMedium
            ),
            
            const SizedBox(height: 8),
            
            Text(
              widget.emptyDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              )
            ),

            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: widget.onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}