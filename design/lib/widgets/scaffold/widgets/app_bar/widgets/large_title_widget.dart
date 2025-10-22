import 'package:deps/features/features.dart';
import 'package:flutter/cupertino.dart';

import '../../../../_core/overridens/overriden_transitionable_navigation_bar.dart';
import '../../../models/fab_appbar_search_bar_settings.dart';
import '../../../models/fab_appbar_settings.dart';
import '../../../utils/measures.dart';
import '../../../utils/store.dart';

class LargeTitleWidget extends StatelessWidget {
  const LargeTitleWidget({
    required this.measures,
    required this.animationStatus,
    required this.appBarSettings,
    required this.components,
    super.key,
  });

  final Measures measures;
  final SearchBarAnimationStatus animationStatus;
  final FabAppBarSettings appBarSettings;
  final NavigationBarStaticComponents components;

  Store get _store => Store.instance();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _store.searchBarHasFocus,
      builder: (_, searchBarHasFocus, __) {
        return ValueListenableBuilder(
          valueListenable: _store.largeTitleHeight,
          builder: (_, largeTitleHeight, __) {
            return ValueListenableBuilder(
              valueListenable: _store.largeTitleOpacity,
              builder: (_, largeTitleOpacity, __) {
                return ValueListenableBuilder(
                  valueListenable: _store.largeTitleScale,
                  builder: (_, largeTitleScale, __) {
                    final opacity = largeTitleOpacity == 0 ? 1.0 : 0.0;

                    return Padding(
                      padding: appBarSettings.largeTitle!.padding,
                      child: AnimatedOpacity(
                        duration: measures.getSlowAnimationDuration,
                        opacity: searchBarHasFocus
                            ? (appBarSettings.searchBar!.animationBehavior ==
                                    SearchBarAnimationBehavior.top
                                ? 0
                                : opacity)
                            : opacity,
                        child: AnimatedContainer(
                          clipBehavior: Clip.hardEdge,
                          color: $.theme.backgroundColor,
                          height: searchBarHasFocus
                              ? (appBarSettings.searchBar!.animationBehavior ==
                                      SearchBarAnimationBehavior.top
                                  ? 0
                                  : largeTitleHeight)
                              : largeTitleHeight,
                          duration:
                              animationStatus == SearchBarAnimationStatus.paused
                                  ? Duration.zero
                                  : measures.getSlowAnimationDuration,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    measures.largeTitleHeight > 0 ? 4.0 : 0),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Transform.scale(
                                          scale: largeTitleScale,
                                          filterQuality: FilterQuality.high,
                                          alignment: Alignment.bottomLeft,
                                          child: components.largeTitle,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      components.largeTitleActions!,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
