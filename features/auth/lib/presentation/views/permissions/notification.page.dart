// ignore_for_file: max_lines_for_file, max_lines_for_function
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class PermissionNotificationPage extends StatefulWidget {
  const PermissionNotificationPage({required this.onResult, super.key});

  final Function(bool didRegister) onResult;

  @override
  State<PermissionNotificationPage> createState() => _PermissionNotificationPageState();
}

class _PermissionNotificationPageState extends State<PermissionNotificationPage> {
  late FormGroup form;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(
        validators: [Validators.required],
      ),
    });
  }

  Future<void> _handleRegister() async {
    if (form.valid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // For now, just call onResult with true
      widget.onResult(true);
    } else {
      form.markAllAsTouched();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              // Header with back button and title
              _buildAppBar(),
              
              // Main content area - properly centered
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Register Form
                          _buildRegisterForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 52,
                child: FabButton.primary(
                  size: FabButtonSize.large,
                  onPressed: () {
                    // if (currentPage < slides.length - 1) {
                    //   _pageController.nextPage(
                    //     duration: const Duration(milliseconds: 300),
                    //     curve: Curves.easeInOut,
                    //   );
                    // } else {
                    //   $.navigator.replace(RegisterRoute(onResult: (bool _) {}));
                    // }
                  },
                  child: Text(
                    'Enable Notifications',
                    style: FabTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ),
              ),
              TextButton(
                onPressed: () {
                  $.navigator.replace(LoginRoute(onResult: (bool _) {}));
                },
                child: Text(
                  'Skip',
                  style: FabTypography.displayLight14.copyWith(
                    color: FabColors.disabledText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: const Row(
        children: [ 
          // FabButton.secondary(
          //   onPressed: () {
          //     $.navigator.replace(LoginRoute(onResult: widget.onResult));
          //   },
          //   isIconOnly: true,
          //   iconWidget: Assets.images.icons.arrowLeftSLine.svg(
          //     width: 20,
          //     height: 20,
          //     package: 'design',
          //   ),
          //   child: const SizedBox.shrink(),
          // ),
          Expanded(
            child: FabTextStyled(
              'Notification Permission',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          // FabButton.secondary(
          //   onPressed: () => {},
          //   isIconOnly: true,
          //   iconWidget: Assets.images.icons.questionLine.svg(
          //     width: 20,
          //     height: 20,
          //     package: 'design',
          //   ),
          //   child: const SizedBox.shrink(),
          // ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // image from Asset
        Center(
          child: Image.asset(
            Assets.images.notifPermission.path,
            width: 120,
            height: 120,
            package: 'design',
          ),
        ),

        PaddingGap.md(),

        FabTextStyled(
          'Stay Updated on What Matters',
          textAlign: TextAlign.center,
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.sm(),

        FabTextStyled(
          'Turn on notifications to get event reminders, speaker invites, and sponsor opportunities - all in real time.',
          textAlign: TextAlign.center,
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.sm(),

        FabTextStyled(
          'You can manage your preferences anytime in Settings.',
          textAlign: TextAlign.center,

          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }
}
