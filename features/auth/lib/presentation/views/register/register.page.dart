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
  
  bool _obscureText = true;

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
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
      }, title: 'Register', move: RoleSelectionRoute(onResult: widget.onResult)));
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
                        
                        PaddingGap.xxl(),
                        
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
        const Text(
          'Start Where the Events Begin',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.sm(),
        Text(
          'Join the Mining Event Platform, a single space for every event role.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
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
            const Expanded(
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
            const Expanded(
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
                  const Text(
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
                  const Text(
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
          // labelText: 'Email',
          hintText: 'Email',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(CupertinoIcons.mail, color: FabColors.primary300),
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Password Field
        FabTextfield(
          formControl: form.control('password') as FormControl<String>,
          keyboardType: TextInputType.text,
          // labelText: 'Password',
          hintText: 'Password',
          textInputAction: TextInputAction.next,
          obscureText: _obscureText,
          size: FabTextfieldSize.large,
          prefixIcon: const Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: Icon(
            _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye, 
            color: FabColors.primary300
          ),
        ),
        
        PaddingGap.md(),
        
        // Confirm Password Field
        FabTextfield(
          formControl: form.control('confirmPassword') as FormControl<String>,
          keyboardType: TextInputType.text,
          // labelText: 'Konfirmasi Password',
          hintText: 'Confirm Password',
          textInputAction: TextInputAction.done,
          obscureText: true,
          size: FabTextfieldSize.large,
          prefixIcon: const Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: Icon(
            _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye, 
            color: FabColors.primary300
          ),
        ),
        
        PaddingGap.xxl(),

        FabTextStyled(
          "By continuing, you agree to our Terms & Privacy Policy.",
          style: FabTypography.displayRegular14Alt.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.center,
        ),

        PaddingGap.xs(),
        
        // Register Button
        Container(
          width: double.infinity,
          height: 52,
          child: FabButton.primary(
            isLoading: _isLoading,
            size: FabButtonSize.large,
            onPressed: _isLoading ? null : _handleRegister,
            child: Text(
              'Continue',
              style: FabTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        PaddingGap.sm(),

        // Login redirect
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
            GestureDetector(
              onTap: () {
                $.navigator.replace(LoginRoute(onResult: widget.onResult));
              },
              child: Text(
                'Login',
                style: FabTypography.displayRegular14.copyWith(
                  color: FabColors.primary200,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
