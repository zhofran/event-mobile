import 'package:deps/features/features.dart';
import 'package:deps/packages/extended_tabs.dart';
import 'package:flutter/material.dart';

import '../../design.dart';
import 'widgets/tab_indicator.dart';

class FabTabBar extends StatelessWidget {
  const FabTabBar({
    required this.tabs,
    required this.controller,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.padding,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.labelColor,
    this.unselectedLabelColor,
    this.isScrollable = false,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.indicatorColor,
    this.indicatorRadius = 2,
    this.backgroundColor,
    this.height,
    super.key,
  });

  final List<Widget> tabs;
  final TabController controller;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final bool isScrollable;
  final TabBarIndicatorSize indicatorSize;
  final Color? indicatorColor;
  final double indicatorRadius;
  final Color? backgroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.only(
      left: $.paddings.lg,
      right: $.paddings.lg,
    );

    Widget tabBar = ExtendedTabBar(
      tabs: tabs,
      controller: controller,
      labelStyle: labelStyle ?? FabTypography.bodySmallRegular,
      unselectedLabelStyle: unselectedLabelStyle ?? FabTypography.bodySmallRegular,
      labelPadding: labelPadding ?? EdgeInsets.symmetric(horizontal: $.paddings.xs),
      labelColor: labelColor ?? FabColors.greyscale900,
      unselectedLabelColor: unselectedLabelColor ?? context.fabTheme.inactiveColor,
      isScrollable: isScrollable,
      indicatorSize: indicatorSize,
      mainAxisAlignment: mainAxisAlignment,
      indicator: TabIndicator(
        color: indicatorColor ?? FabColors.primary,
        radius: indicatorRadius,
      ),
    );

    // Wrap with Container if backgroundColor or height is specified
    if (backgroundColor != null || height != null) {
      tabBar = Container(
        height: height,
        color: backgroundColor,
        child: tabBar,
      );
    }

    return Padding(
      padding: padding ?? defaultPadding,
      child: tabBar,
    );
  }
}
