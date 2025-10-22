// ignore_for_file: max_lines_for_function

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../_core/constants/fab_theme.dart';
import '../../../../../../design.dart';
import '../../../../../_core/overridens/overriden_transitionable_navigation_bar.dart';
import '../../../../models/fab_appbar_action_settings.dart';
import '../../../../models/fab_appbar_search_bar_settings.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/measures.dart';
import '../../../../utils/store.dart';

class StaticSearchBarWidget extends StatelessWidget {
  const StaticSearchBarWidget({
    required this.measures,
    required this.keys,
    required this.searchBar,
    required this.focusNode,
    required this.editingController,
    required this.searchBarFocusThings,
    super.key,
  });

  final Measures measures;
  final TextEditingController editingController;
  final FocusNode focusNode;
  final NavigationBarStaticComponentsKeys keys;
  final FabAppBarSearchBarSettings searchBar;
  final ValueChanged<bool> searchBarFocusThings;

  Store get _store => Store.instance();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: keys.searchBarKey,
      child: IgnorePointer(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.only(left: 8),
                color: Colors.transparent,
                onPressed: () {
                  searchBarFocusThings(false);
                  focusNode.unfocus();
                  editingController.clear();
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 10000),
                  opacity: _store.searchBarHasFocus.value ? 1 : 0,
                  child: Text(
                    searchBar.cancelButtonText,
                    style: context.fabTheme.appBarActionsStyle.copyWith(
                        color:
                            CupertinoTheme.of(context).primaryContrastingColor),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: FabColors.greyscale0,
                      borderRadius: searchBar.borderRadius,
                      border: Border.all(
                        color: FabColors.greyscale300,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Search Icon
                          ValueListenableBuilder<bool>(
                            valueListenable: _store.searchBarHasFocus,
                            builder: (context, hasFocus, child) {
                              return ValueListenableBuilder<double>(
                                valueListenable: _store.opacity,
                                builder: (context, opacity, child) {
                                  return Opacity(
                                    opacity: hasFocus ? 0 : opacity,
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: FabColors.greyscale500,
                                      size: 20,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          // TextField
                          Expanded(
                            child: ValueListenableBuilder<double>(
                              valueListenable: _store.opacity,
                              builder: (context, opacity, child) {
                                return TextField(
                                  style:
                                      FabTypography.displayRegular14.copyWith(
                                    color: FabColors.greyscale900,
                                    height: 1.6,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: searchBar.placeholderText,
                                    hintStyle:
                                        FabTypography.displayRegular14.copyWith(
                                      color: FabColors.greyscale500
                                          .withOpacity(opacity),
                                      height: 1.6,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final FabAppBarActionSettings searchAction
                        in searchBar.actions)
                      searchAction.behavior ==
                              FabAppBarActionSettingsBehavior.alwaysVisible
                          ? searchAction
                          : const SizedBox(),
                    AnimatedCrossFade(
                      firstChild: Center(
                        child: Row(
                          children: searchBar.actions
                              .where((e) =>
                                  e.behavior ==
                                  FabAppBarActionSettingsBehavior
                                      .visibleOnFocus)
                              .toList(),
                        ),
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: _store.searchBarHasFocus.value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: measures.getSlowAnimationDuration,
                    ),
                    AnimatedCrossFade(
                      firstChild: Center(
                        child: Row(
                          children: searchBar.actions
                              .where((e) =>
                                  e.behavior ==
                                  FabAppBarActionSettingsBehavior
                                      .visibleOnUnFocus)
                              .toList(),
                        ),
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: _store.searchBarHasFocus.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: measures.getSlowAnimationDuration,
                    ),
                    AnimatedContainer(
                      duration: measures.getSlowAnimationDuration,
                      width: _store.searchBarHasFocus.value
                          ? defaultTextSize(
                              searchBar.cancelButtonText,
                              context.fabTheme.appBarActionsStyle,
                            )
                          : 0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
