import 'package:deps/features/features.dart';
import 'package:deps/packages/smooth_sheets.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../design.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    this.title,
    super.key,
    this.leadingWidget,
  });

  final Widget? leadingWidget;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SheetDraggable(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            if (leadingWidget != null) leadingWidget! else const Spacer(),
            PaddingGap.sm(),
            Expanded(
              child: title != null
                  ? Text(
                      title!,
                      style: context.fabTheme.title2Style.bold,
                    )
                  : const Nil(),
            ),
            PaddingGap.sm(),
            FabButton.secondary(
              width: 32,
              size: FabButtonSize.small,
              isIconOnly: true,
              icon: UIcons.boldRounded.cross_small,
              onPressed: $.navigator.pop,
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
