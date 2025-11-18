import 'package:deps/design/design.dart';
import 'package:flutter/material.dart';

class FabPageHeader extends StatelessWidget {
  const FabPageHeader({
    required this.title,
    this.onBack,
    this.onTrailing,
    this.showTrailing = false,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onTrailing;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Leading Button
          FabButton.secondary(
            onPressed: onBack ?? () => Navigator.pop(context),
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),

          // Title
          Expanded(
            child: FabTextStyled(
              title,
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),

          // Trailing (visible or hidden but keep spacing)
          if (showTrailing)
            FabButton.secondary(
              onPressed: onTrailing,
              isIconOnly: true,
              iconWidget: Assets.images.icons.questionLine.svg(
                width: 20,
                height: 20,
                package: 'design',
              ),
              child: const SizedBox.shrink(),
            )
          else
            Opacity(
              opacity: 0,
              child: FabButton.secondary(
                onPressed: () {},
                isIconOnly: true,
                iconWidget: Assets.images.icons.questionLine.svg(
                  width: 20,
                  height: 20,
                  package: 'design',
                ),
                child: const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}
