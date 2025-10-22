// ignore_for_file: max_lines_for_file, max_lines_for_function
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileCompletedPage extends StatefulWidget {
  const ProfileCompletedPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfileCompletedPage> createState() => _ProfileCompletedPageState();
}

class _ProfileCompletedPageState extends State<ProfileCompletedPage> {

  @override
  void initState() {
    super.initState();
    // Auto navigate to notification permission page after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        $.navigator.push(
          PermissionNotificationRoute(
            onResult: widget.onResult,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.primary,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FabColors.primary,
          ),
          child: _buildSuccessContent(),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // White circular checkmark icon
        Center(
          child: Image.asset(
            Assets.images.checklist.path,
            width: 30,
            height: 30,
            package: 'design',
          ),
        ),
        
        const SizedBox(height: 40),
        
        // "Great!" title
        FabTextStyled(
          'Great!',
          style: FabTypography.displaySemiBold22.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 24),
        
        // Success message
        FabTextStyled(
          'Your account is ready.\nCheck your email to activate\nyour account.',
          style: FabTypography.displaySemiBold22.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
