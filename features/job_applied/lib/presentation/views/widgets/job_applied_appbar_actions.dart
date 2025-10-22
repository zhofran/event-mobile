import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobAppliedAppBarActions extends StatelessWidget {
  const JobAppliedAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            $.navigator.replace(
              CompanyProfileRoute(companyId: 1), // Using sample company ID
            );
          },
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
