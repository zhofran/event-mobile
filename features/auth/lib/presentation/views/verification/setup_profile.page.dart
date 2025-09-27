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
class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  late FormGroup form;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'firstName': FormControl<String>(
        validators: [Validators.required],
      ),
      'lastName': FormControl<String>(
        validators: [Validators.required],
      ),
    });
  }

  Future<void> _handleSetupProfile() async {
    if (form.valid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate profile setup process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful profile setup
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Change Email Form
                        _buildSetupProfileNameForm(),
                      ],
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
              $.navigator.pop();
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
              'Profile Name',
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

  Widget _buildSetupProfileNameForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Set up your account',
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.lg(),
        
        // First Name Field
        FabTextfield(
          formControl: form.control('firstName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'First Name',
          hintText: 'Input your first name',
          textInputAction: TextInputAction.next,
          prefixIcon: Icon(CupertinoIcons.person, color: FabColors.primary300),
          size: FabTextfieldSize.large,
        ),

        PaddingGap.md(),

        // Last Name Field
        FabTextfield(
          formControl: form.control('lastName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Last Name',
          hintText: 'Input your last name',
          textInputAction: TextInputAction.done,
          prefixIcon: Icon(CupertinoIcons.person, color: FabColors.primary300),
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.lg(),

        FabTextStyled(
          'By clicking continue, you agree to Mining Digital Platform Terms & Conditions.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),

        PaddingGap.md(),
        
        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FabButton.primary(
            isLoading: _isLoading,
            child: Text(
              'Continue',
              style: FabTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            size: FabButtonSize.large,
            onPressed: () => {
              $.navigator.push(SetupPhoneNumberRoute(onResult: widget.onResult))
            },
          ),
        ),
      ],
    );
  }
}
