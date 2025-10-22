// ignore_for_file: avoid_returning_widgets
import 'dart:async';

import 'package:deps/packages/easy_refresh.dart';
import 'package:deps/packages/extended_tabs.dart' hide LinkScrollController;
import 'package:flutter/material.dart';

import '../../_core/overridens/overriden_cupertino_scrollbar.dart';
import '../models/fab_appbar_search_bar_settings.dart';
import '../utils/measures.dart';
import '../utils/store.dart';
import 'test.dart';
import 'test3.dart';

class Body extends StatelessWidget {
  Body({
    required this.measures,
    required this.refreshListenable,
    required this.searchBar,
    required this.children,
    required this.scrollControllers,
    required this.onRefreshes,
    this.tabController,
    super.key,
  });

  final List<FutureOr<dynamic> Function()?> onRefreshes;
  final List<Widget> children;
  final Measures measures;
  final IndicatorStateListenable refreshListenable;
  final List<ScrollController> scrollControllers;
  final FabAppBarSearchBarSettings searchBar;
  final TabController? tabController;

  Store get _store => Store.instance();

  Widget _pullToRefreshBuilder({required int index}) {
    final onRefresh = onRefreshes.elementAtOrNull(index);
    final scrollController = scrollControllers.elementAt(index);
    final child = children.elementAt(index);

    Widget childWidget({ScrollPhysics? physics}) => _childBuilder(
          scrollController: scrollController,
          physics: physics,
          child: child,
        );

    return onRefresh != null
        ? EasyRefresh.builder(
            onRefresh: onRefresh,
            header: ListenerHeader(
              processedDuration: Duration.zero,
              triggerOffset: 160,
              listenable: refreshListenable,
              clamping: false,
              hitOver: true,
              hapticFeedback: true,
            ),
            childBuilder: (_, physics) {
              return childWidget(physics: physics);
            },
          )
        : childWidget();
  }

  Widget _childBuilder({
    required ScrollController scrollController,
    required Widget child,
    ScrollPhysics? physics,
  }) {
    final key = PageStorageKey<String>(scrollController.hashCode.toString());

    // Ensure child is a Sliver widget - wrap if necessary
    final Widget sliverChild = _ensureSliver(child);

    return OverridenCupertinoScrollbar(
      controller: scrollController,
      padding: EdgeInsets.only(top: measures.getAppBarHeightWSafeZone),
      thumbVisibility: true,
      thicknessWhileDragging: 6,
      child: CustomScrollView(
        key: key,
        controller: scrollController,
        physics: SnapScrollPhysics(
          parent: physics,
          snaps: [
            if (searchBar.scrollBehavior == SearchBarScrollBehavior.floated)
              Snap.avoidZone(0, measures.getSearchBarHeight),
            if (searchBar.scrollBehavior == SearchBarScrollBehavior.floated)
              Snap.avoidZone(measures.getSearchBarHeight,
                  measures.largeTitleHeight + measures.getSearchBarHeight),
            if (searchBar.scrollBehavior == SearchBarScrollBehavior.pinned)
              Snap.avoidZone(0, measures.largeTitleHeight),
          ],
        ),
        slivers: [
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: _store.searchBarAnimationStatus,
              builder: (_, animationStatus, __) {
                return AnimatedContainer(
                  duration: animationStatus == SearchBarAnimationStatus.paused
                      ? Duration.zero
                      : measures.getSlowAnimationDuration,
                  height: _store.searchBarHasFocus.value
                      ? (searchBar.animationBehavior ==
                              SearchBarAnimationBehavior.top
                          ? measures.getAppBarFocusedHeightWSafeZone
                          : measures.getAppBarHeightWSafeZone)
                      : measures.getAppBarHeightWSafeZone,
                );
              },
            ),
          ),
          sliverChild,
        ],
      ),
    );
  }

  /// Ensures the child widget is a Sliver widget
  Widget _ensureSliver(Widget child) {
    // Check if widget is already a Sliver type by checking runtime type name
    final typeName = child.runtimeType.toString();
    if (typeName.startsWith('Sliver') ||
        typeName.contains('SliverToBoxAdapter') ||
        typeName.contains('SliverList') ||
        typeName.contains('SliverGrid') ||
        typeName.contains('SliverPadding') ||
        typeName.contains('SliverAppBar')) {
      return child;
    }

    // Wrap non-Sliver widgets with SliverToBoxAdapter
    return SliverToBoxAdapter(child: child);
  }

  @override
  Widget build(BuildContext context) {
    final child = tabController != null
        ? ExtendedTabBarView(
            controller: tabController,
            cacheExtent: 2,
            children: [
              for (var i = 0; i < tabController!.length; i++) ...{
                _pullToRefreshBuilder(index: i),
              },
            ],
          )
        : _childBuilder(
            scrollController: scrollControllers.first,
            child: children.first,
          );

    return ValueListenableBuilder(
      valueListenable: _store.isInHero,
      builder: (_, isInHero, __) {
        return IgnorePointer(
          ignoring: isInHero,
          child: child,
        );
      },
    );
  }
}
