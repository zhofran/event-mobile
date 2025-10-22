import 'package:deps/design/design.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoverAppBarActions extends StatelessWidget {
  const DiscoverAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Assets.images.icons.media.notification2Line.svg(
            width: 25,
            height: 25,
            package: 'design',
            colorFilter: ColorFilter.mode(
              FabColors.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
