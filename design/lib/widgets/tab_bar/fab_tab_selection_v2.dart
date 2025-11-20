import 'package:flutter/material.dart';

import '../../design.dart';

/// Model untuk data tab
class FabTabV2 {
  FabTabV2({
    required this.title,
    required this.items,
  });

  String title;
  List<dynamic> items;
}

/// Enhanced Tab Selection Widget
/// Designed to work with Expanded widget and single scroll
class FabTabSelectionV2 extends StatefulWidget {
  const FabTabSelectionV2({
    super.key,
    required this.tabs,
    required this.cardBuilder,
    this.onCreatePressed,
    this.emptyTitle = 'No Data Yet',
    this.emptyDescription = "There's nothing here yet. Try adding new items.",
    this.emptyIllustration,
    this.tabAlignment = TabAlignment.start,
    this.isScrollable = true,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.cardPadding = const EdgeInsets.only(bottom: 16),
    this.listPadding = const EdgeInsets.only(top: 16),
  });

  final List<FabTabV2> tabs;
  final Widget Function(dynamic) cardBuilder;
  final VoidCallback? onCreatePressed;
  final String emptyTitle;
  final String emptyDescription;
  final Widget? emptyIllustration;
  final TabAlignment tabAlignment;
  final bool isScrollable;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry cardPadding;
  final EdgeInsetsGeometry listPadding;

  @override
  State<FabTabSelectionV2> createState() => _FabTabSelectionV2State();
}

class _FabTabSelectionV2State extends State<FabTabSelectionV2>
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar (Fixed at top)
        Padding(
          padding: widget.padding,
          child: TabBar(
            tabAlignment: widget.tabAlignment,
            padding: EdgeInsets.zero,
            dividerHeight: 0,
            controller: _tabController,
            isScrollable: widget.isScrollable,
            labelColor: widget.labelColor ?? FabColors.textPrimary,
            unselectedLabelColor:
                widget.unselectedLabelColor ?? FabColors.greyscale400,
            indicatorColor: widget.indicatorColor ?? FabColors.primary,
            labelStyle: FabTypography.displaySemiBold14,
            unselectedLabelStyle: FabTypography.displayRegular14,
            tabs: widget.tabs.map((tab) => Tab(text: tab.title)).toList(),
          ),
        ),

        // Tab Content (Expanded - Scrollable)
        Expanded(
          child: Padding(
            padding: widget.padding,
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs.map((tab) {
                if (tab.items.isEmpty) {
                  return _buildEmptyState(context);
                } else {
                  return _buildListView(tab);
                }
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(FabTabV2 tab) {
    return ListView.builder(
      padding: widget.listPadding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tab.items.length,
      itemBuilder: (context, index) {
        final data = tab.items[index];
        return Padding(
          padding: widget.cardPadding,
          child: widget.cardBuilder(data),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.emptyIllustration ??
                Icon(
                  Icons.event_note_outlined,
                  size: 80,
                  color: FabColors.greyscale300,
                ),
            const SizedBox(height: 16),
            Text(
              widget.emptyTitle,
              style: FabTypography.displayBold18.copyWith(
                color: FabColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.emptyDescription,
              textAlign: TextAlign.center,
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale500,
              ),
            ),
            if (widget.onCreatePressed != null) ...[
              const SizedBox(height: 24),
              FabButton.primary(
                onPressed: widget.onCreatePressed,
                size: FabButtonSize.medium,
                child: Text(
                  'Create New',
                  style: FabTypography.displaySemiBold14.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
