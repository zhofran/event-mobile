// ignore_for_file: avoid_empty_blocks

import 'package:deps/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/helpers.dart';
import '../../../../utils/measures.dart';
import '../../../../utils/store.dart';
import 'search_actions_widget.dart';

class DynamicSearchBarWidget extends StatefulWidget {
  const DynamicSearchBarWidget({
    required this.measures,
    required this.searchBar,
    required this.editingController,
    required this.focusNode,
    required this.searchBarFocusThings,
    super.key,
  });

  final Measures measures;
  final TextEditingController editingController;
  final FocusNode focusNode;
  final FabAppBarSearchBarSettings searchBar;
  final ValueChanged<bool> searchBarFocusThings;

  @override
  State<DynamicSearchBarWidget> createState() => _DynamicSearchBarWidgetState();
}

class _DynamicSearchBarWidgetState extends State<DynamicSearchBarWidget> {
  bool _isSubmitted = false;

  Store get _store => Store.instance();

  @override
  void dispose() {
    // Reset focus state when widget is disposed
    if (widget.focusNode.hasFocus) {
      widget.focusNode.unfocus();
      widget.searchBarFocusThings(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _store.searchBarHasFocus,
          builder: (context, hasFocus, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                duration: widget.measures.getSlowAnimationDuration,
                opacity: hasFocus ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !hasFocus,
                  child: CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    color: Colors.transparent,
                    onPressed: () {
                      widget.editingController.clear();
                      widget.focusNode.unfocus();
                      widget.searchBarFocusThings(false);
                      // Remove setState to avoid calling during build
                    },
                    child: Text(
                      widget.searchBar.cancelButtonText,
                      style: context.fabTheme.appBarActionsStyle,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: FabColors.greyscale0,
                  borderRadius: widget.searchBar.borderRadius,
                  border: Border.all(
                    color: FabColors.greyscale300,
                    width: 1,
                  ),
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (_isSubmitted) {
                      _isSubmitted = false;

                      return;
                    }
                    widget.searchBarFocusThings(hasFocus);
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Search Icon
                        ValueListenableBuilder<double>(
                          valueListenable: _store.opacity,
                          builder: (context, opacity, child) {
                            return Opacity(
                              opacity: opacity,
                              child: Icon(
                                CupertinoIcons.search,
                                color: FabColors.greyscale500,
                                size: 20,
                              ),
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
                                controller: widget.editingController,
                                focusNode: widget.focusNode,
                                style: FabTypography.displayRegular14.copyWith(
                                  color: FabColors.greyscale900,
                                  height: 1.6,
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.searchBar.placeholderText,
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
                                onSubmitted: (s) {
                                  _isSubmitted = true;
                                  widget.searchBar.onSubmitted?.call(s);
                                },
                                onChanged: (v) {
                                  // Remove setState to avoid calling during build
                                  // ignore: avoid_nested_if
                                  if (v.isNotEmpty) {
                                    if (widget.searchBar.resultBehavior ==
                                        SearchBarResultBehavior
                                            .visibleOnInput) {
                                      _store.searchBarResultVisible.value =
                                          true;
                                    }
                                  } else {
                                    if (widget.searchBar.resultBehavior ==
                                        SearchBarResultBehavior
                                            .visibleOnInput) {
                                      _store.searchBarResultVisible.value =
                                          false;
                                    }
                                  }
                                  widget.searchBar.onChanged?.call(v);
                                },
                                autocorrect: false,
                              );
                            },
                          ),
                        ),
                        // Clear button (optional)
                        if (widget.editingController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              widget.editingController.clear();
                              widget.searchBar.onChanged?.call('');
                              // Remove setState to avoid calling during build
                            },
                            child: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: FabColors.greyscale400,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SearchActionsWidget(
              actions: widget.searchBar.actions,
              animationDuration: widget.measures.getSlowAnimationDuration,
              searchBarHasFocus: _store.searchBarHasFocus.value,
            ),
            AnimatedContainer(
              duration: widget.measures.getSlowAnimationDuration,
              width: _store.searchBarHasFocus.value
                  ? defaultTextSize(
                      widget.searchBar.cancelButtonText,
                      context.fabTheme.appBarActionsStyle,
                    )
                  : 0,
            ),
          ],
        ),
      ],
    );
  }
}
