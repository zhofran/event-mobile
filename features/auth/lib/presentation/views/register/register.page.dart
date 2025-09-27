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
class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.onResult, super.key});

  final Function(bool didRegister) onResult;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    setState(() {
        _isLoading = true;
      });

      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // For now, just call onResult with true
      await $.navigator.replace(VerifyEmailRoute(onResult: (bool didVerify) {
        widget.onResult(didVerify);
      }));
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
              
              // Main content area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddingGap.sm(),
                        
                        // Welcome text section
                        _buildWelcomeSection(),
                        
                        PaddingGap.md(),
                        
                        // Register Form
                        _buildRegisterForm(),
                        
                        PaddingGap.lg(),
                        
                        // Social register options
                        _buildSocialRegisterSection(),
                        
                        PaddingGap.lg(),
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
              'Register',
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

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up your account',
          style: FabTypography.displaySemiBold22,
        ),
      ],
    );
  }

  Widget _buildSocialRegisterSection() {
    return Column(
      children: [
        // Divider with "atau" text
        Row(
          children: [
            Expanded(
              child: Divider(
              color: FabColors.line,
              thickness: 1,
            ),
            ),
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0),
               child: Text(
                 'or',
                 style: FabTypography.caption2.copyWith(
                   color: FabColors.greyscale600,
                 ),
               ),
             ),
            Expanded(
              child: Divider(
              color: FabColors.line,
              thickness: 1,
            ),
            ),
          ],
        ),
        
        PaddingGap.md(),
        
        // Google login button
        Column(
          children: [
            FabButton.secondary(
              onPressed: () {
                // TODO: Implement Google login
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.google.image(
                    width: 20,
                    height: 20,
                    package: 'design',
                  ),
                  PaddingGap.sm(),
                  Text(
                    'Continue With Google',
                    style: FabTypography.displaySemiBold14,
                  ),
                ],
              ),
            ),
            PaddingGap.sm(),
            FabButton.secondary(
              onPressed: () {
                // TODO: Implement LinkedIn login
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.linkedin.image(
                    width: 20,
                    height: 20,
                    package: 'design',
                  ),
                  PaddingGap.sm(),
                  Text(
                    'Continue With LinkedIn',
                    style: FabTypography.displaySemiBold14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Email Field
        FabTextfield(
          formControl: form.control('email') as FormControl<String>,
          keyboardType: TextInputType.emailAddress,
          labelText: 'Email',
          hintText: 'Masukkan email Anda',
          textInputAction: TextInputAction.next,
          prefixIcon: Icon(CupertinoIcons.mail, color: FabColors.primary300),
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Password Field
        FabTextfield(
          formControl: form.control('password') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Password',
          hintText: 'Masukkan password Anda',
          textInputAction: TextInputAction.next,
          obscureText: true,
          size: FabTextfieldSize.large,
          prefixIcon: Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: Icon(CupertinoIcons.eye, color: FabColors.primary300),
        ),
        
        PaddingGap.md(),
        
        // Confirm Password Field
        FabTextfield(
          formControl: form.control('confirmPassword') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Konfirmasi Password',
          hintText: 'Masukkan ulang password Anda',
          textInputAction: TextInputAction.done,
          obscureText: true,
          size: FabTextfieldSize.large,
          prefixIcon: Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: Icon(CupertinoIcons.eye, color: FabColors.primary300),
        ),
        
        PaddingGap.lg(),

        FabTextStyled(
          "By clicking continue, you agree to Mining Digital Platform Terms & Conditions.",
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),

        PaddingGap.sm(),
        
        // Register Button
        Container(
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
            onPressed: _isLoading ? null : _handleRegister,
          ),
        ),
      ],
    );
  }
}
