// ignore_for_file: max_lines_for_file,

import 'package:deps/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../_core/constants/fab_theme.dart';
import '../../../_core/overridens/overriden_transitionable_navigation_bar.dart';
import '../../models/fab_appbar_search_bar_settings.dart';
import '../../models/fab_appbar_settings.dart';
import '../../utils/helpers.dart';
import '../../utils/measures.dart';
import '../../utils/store.dart';
import 'app_bar_widget.dart';

class AnimatedAppBar extends StatelessWidget {
  const AnimatedAppBar({
    required this.measures,
    required this.animationController,
    required this.appBarSettings,
    required this.components,
    required this.editingController,
    required this.focusNode,
    required this.keys,
    required this.isCollapsed,
    required this.shouldTransiteBetweenRoutes,
    required this.color,
    super.key,
  });

  final Measures measures;
  final AnimationController animationController;
  final Color color;
  final FabAppBarSettings appBarSettings;
  final NavigationBarStaticComponents components;
  final TextEditingController editingController;
  final FocusNode focusNode;
  final bool isCollapsed;
  final NavigationBarStaticComponentsKeys keys;
  final bool shouldTransiteBetweenRoutes;

  Store get _store => Store.instance();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _store.searchBarAnimationStatus,
      builder: (_, animationStatus, __) {
        return ValueListenableBuilder(
          valueListenable: _store.searchBarHasFocus,
          builder: (_, searchBarHasFocus, __) {
            return ValueListenableBuilder(
              valueListenable: _store.height,
              builder: (_, height, __) {
                return AnimatedPositioned(
                  duration: animationStatus == SearchBarAnimationStatus.paused
                      ? Duration.zero
                      : measures.getSlowAnimationDuration,
                  top: 0,
                  left: 0,
                  right: 0,
                  height: searchBarHasFocus
                      ? (appBarSettings.searchBar!.animationBehavior ==
                              SearchBarAnimationBehavior.top
                          ? measures.getAppBarFocusedHeightWSafeZone
                          : height)
                      : height,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (_, __) {
                      return Container(
                        decoration:
                            defaultBorder(context, animationController.value),
                        child: wrapWithBackground(
                          brightness: context.platformBrightness,
                          hasBackgroundBlur: appBarSettings.hasBackgroundBlur,
                          backgroundColor: color,
                          child: Builder(
                            builder: (context) {
                              final Widget appBarWidget = AppBarWidget(
                                measures: measures,
                                animationStatus: animationStatus,
                                appBarSettings: appBarSettings,
                                components: components,
                                editingController: editingController,
                                focusNode: focusNode,
                                keys: keys,
                              );

                              if (!shouldTransiteBetweenRoutes ||
                                  !isTransitionable(context)) {
                                return appBarWidget;
                              }

                              return _HeroWrapper(
                                store: _store,
                                color: color,
                                appBarSettings: appBarSettings,
                                keys: keys,
                                isCollapsed: isCollapsed,
                                searchBarHasFocus: searchBarHasFocus,
                                child: appBarWidget,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// Separate widget to handle Hero animation properly
class _HeroWrapper extends StatefulWidget {
  const _HeroWrapper({
    required this.store,
    required this.color,
    required this.appBarSettings,
    required this.keys,
    required this.isCollapsed,
    required this.searchBarHasFocus,
    required this.child,
  });

  final Store store;
  final Color color;
  final FabAppBarSettings appBarSettings;
  final NavigationBarStaticComponentsKeys keys;
  final bool isCollapsed;
  final bool searchBarHasFocus;
  final Widget child;

  @override
  State<_HeroWrapper> createState() => _HeroWrapperState();
}

class _HeroWrapperState extends State<_HeroWrapper> {
  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      widget.store.isInHero.value = false;
    } else {
      widget.store.isInHero.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: HeroTag(Navigator.of(context)),
      createRectTween: linearTranslateWithLargestRectSizeTween,
      flightShuttleBuilder:
          (_, animation, flightDirection, fromHeroContext, toHeroContext) {
        // Remove old listener before adding new one to prevent memory leaks
        animation.removeStatusListener(_onAnimationStatus);
        animation.addStatusListener(_onAnimationStatus);

        return navBarHeroFlightShuttleBuilder(
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        );
      },
      placeholderBuilder: (_, __, child) {
        return navBarHeroLaunchPadBuilder(child);
      },
      transitionOnUserGestures: true,
      child: OverridenTransitionableNavigationBar(
        componentsKeys: widget.keys,
        backgroundColor: widget.color,
        backButtonTextStyle:
            context.fabTheme.appBarActionsStyle.copyWith(inherit: false),
        titleTextStyle: defaultTitleTextStyle(context, widget.appBarSettings),
        largeTitleTextStyle: widget.appBarSettings.largeTitle!.textStyle ??
            context.fabTheme.appBarLargeTitleStyle.copyWith(inherit: false),
        border: null,
        hasUserMiddle: widget.isCollapsed,
        largeExpanded:
            !widget.isCollapsed && widget.appBarSettings.largeTitle!.enabled,
        searchBarHasFocus: widget.searchBarHasFocus,
        child: widget.child,
      ),
    );
  }
}
