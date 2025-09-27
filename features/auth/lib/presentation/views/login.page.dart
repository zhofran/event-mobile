// ignore_for_file: max_lines_for_file, max_lines_for_function
// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:feature_auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/login.form.dart';
import '../cubits/login.cubit.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  LoginPage({required this.onResult, super.key});

  final Function(bool didLogin) onResult;

  final loginCubit = $.get<LoginCubit>();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final isSucceeded = await loginCubit.login(email: email, password: password);

    if (isSucceeded) {
      onResult(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: BlocListener<LoginCubit, LoginState>(
        bloc: loginCubit,
        listener: (_, state) {
          state.whenOrNull(
            loading: () => $.overlay.showLoadingOverlay(
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                  color: FabColors.primary,
                ),
              ),
            ),
            failed: (failure) {
              $.overlay.hideOverlay();
              $.toast.showAlert(failure: failure);
            },
            succeeded: (user) {
              $.overlay.hideOverlay();
              $.get<UserCubit>().loggedIn(user);
            },
          );
        },
        child: SafeArea(
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
                        
                        // Login Form
                        _buildLoginForm(),
                        
                        PaddingGap.lg(),
                        
                        // Social login options
                        _buildSocialLoginSection(),
                        
                        PaddingGap.xl(),
                        
                        // Footer
                        _buildFooter(),
                        
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
            onPressed: () => {},
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
              'Login',
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
          'Let’s get started',
          style: FabTypography.displaySemiBold22,
        )
      ],
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        // Divider with "atau" text
        Row(
          children: [
            Expanded(
              child: Divider(
              color: FabColors.greyscale300,
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
              color: FabColors.greyscale300,
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

  Widget _buildLoginForm() {
    return LoginFormFormBuilder(
      model: LoginForm.empty(),
      builder: (_, data, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Field
            FabTextfield(
              formControl: data.emailControl,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Email',
              hintText: 'Input your email',
              textInputAction: TextInputAction.next,
              onSubmitted: () => data.passwordControl.focus(),
              prefixIcon: Icon(CupertinoIcons.mail, color: FabColors.primary300,),
              size: FabTextfieldSize.large,
            ),
            
            PaddingGap.md(),
            
            // Password Field
            FabTextfield(
              formControl: data.passwordControl,
              keyboardType: TextInputType.text,
              labelText: 'Password',
              hintText: 'Input your password',
              textInputAction: TextInputAction.send,
              obscureText: true,
              size: FabTextfieldSize.large,
              prefixIcon: Icon(CupertinoIcons.lock, color: FabColors.primary300),
              suffixIcon: Icon(CupertinoIcons.eye, color: FabColors.primary300),
              onSubmitted: () => data.submit(
                onValid: (model) => login(
                  email: model.email,
                  password: model.password,
                ),
                onNotValid: () {
                  // Form is invalid, errors will be shown automatically
                },
              ),
            ),
            
            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password page
                },
                child: Text(
                  'Lupa Password?',
                  style: FabTypography.displayLight14.copyWith(
                    color: FabColors.primary,
                  ),
                ),
              ),
            ),
            
            PaddingGap.md(),
            
            // Login Button
            ReactiveLoginFormFormConsumer(
              builder: (_, __, ___) {
                return Container(
                  width: double.infinity,
                  height: 52,
                  child: FabButton.primary(
                    child: Text(
                      'Login',
                      style: FabTypography.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    size: FabButtonSize.large,
                    onPressed: () => data.submit(
                      onValid: (model) => login(
                        email: model.email,
                        password: model.password,
                      ),
                      onNotValid: () {
                        // Form is invalid, errors will be shown automatically
                        // because markAllAsTouched() is called in submit()
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }





  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum punya akun? ',
              style: FabTypography.footnote.copyWith(
                color: FabColors.greyscale600,
              ),
            ),
            GestureDetector(
              onTap: () {
                        $.navigator.replace(RegisterRoute(onResult: onResult));
                      },
              child: Text(
                'Daftar Sekarang',
                style: FabTypography.footnote.copyWith(
                  color: FabColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
