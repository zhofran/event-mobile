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
class PermissionLocationPage extends StatefulWidget {
  const PermissionLocationPage({required this.onResult, super.key});

  final Function(bool didRegister) onResult;

  @override
  State<PermissionLocationPage> createState() => _PermissionLocationPageState();
}

class _PermissionLocationPageState extends State<PermissionLocationPage> {
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [ 
          FabButton.secondary(
            onPressed: () {
              $.navigator.replace(LoginRoute(onResult: widget.onResult));
            },
            isIconOnly: true,
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
          const Expanded(
            child: FabTextStyled(
              'Location Permission',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          FabButton.secondary(
            onPressed: () => {},
            isIconOnly: true,
            iconWidget: Assets.images.icons.questionLine.svg(
              width: 20,
              height: 20,
              package: 'design',
            ),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image from Asset
        Center(
          child: Image.asset(
            Assets.images.locationPermission.path,
            width: 120,
            height: 120,
            package: 'design',
          ),
        ),

        PaddingGap.xl(),

        FabTextStyled(
          'Find Jobs Near You',
          textAlign: TextAlign.center,
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),

        FabTextStyled(
          'Allow location access to discover the best opportunities close to where you are.',
          textAlign: TextAlign.center,
          style: FabTypography.displayRegular16.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),

        FabTextStyled(
          'This helps us show jobs in your area.',
          textAlign: TextAlign.center,

          style: FabTypography.displayRegular16.copyWith(
            color: FabColors.greyscale400,
          ),
        ),

        PaddingGap.lg(),

        // Register Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FabButton.primary(
            isLoading: _isLoading,
            child: Text(
              'Locate Now',
              style: FabTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            size: FabButtonSize.large,
            onPressed: () => {
              $.navigator.push(LoginRoute(
                onResult: widget.onResult,
              ))
            },
          ),
        ),

        PaddingGap.md(),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: FabButton.secondary(
            child: Text(
              'Later',
              style: FabTypography.displayMedium16.copyWith(
                color: FabColors.greyscale700,
              ),
            ),
            size: FabButtonSize.large,
            onPressed: () {
              $.navigator.replace(ChangeEmailRoute(
                onResult: widget.onResult,
              ));
            },
          ),
        ),
      ],
    );
  }
}
