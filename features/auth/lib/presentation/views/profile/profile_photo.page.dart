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
class ProfilePhotoPage extends StatefulWidget {
  const ProfilePhotoPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  bool _isLoading = false;

  Future<void> _handleTakePhoto() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate photo capture process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // For now, just call onResult with true
    widget.onResult(true);
  }

  Future<void> _handleOpenGallery() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate gallery selection process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // For now, just call onResult with true
    widget.onResult(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildAppBar(),
            
            // Main content area - properly centered
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Profile Photo Content
                    Expanded(
                      child: _buildProfilePhotoContent(),
                    ),
                    // Bottom Buttons
                    _buildBottomButtons(),
                    PaddingGap.lg(),
                  ],
                ),
              ),
            ),
          ],
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
              $.navigator.push(
                VerifyEmailRoute(
                  onResult: widget.onResult,
                )
              );
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
              'Profile Photo',
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

  Widget _buildProfilePhotoContent() {
    return Column(
      children: [
        PaddingGap.lg(),

        // Welcome text section
        FabTextStyled(
          'Upload a photo so people can easily recognize you',
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),
        
        // Profile Photo Avatar
        _buildPhotoAvatar(),
        
        PaddingGap.xl(),
        
        // User Info
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildPhotoAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: FabColors.primary0,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.camera,
          size: 40,
          color: FabColors.primary200,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        FabTextStyled(
          'John Doe',
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale900,
          ),
          textAlign: TextAlign.center,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'UI UX Designer at Google',
          style: FabTypography.displayRegular16.copyWith(
            color: FabColors.greyscale500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        // Take Photo Button
        Expanded(
          child: SizedBox(
            height: 52,
            child: FabButton.secondary(
              onPressed: _isLoading ? null : _handleTakePhoto,
              size: FabButtonSize.large,
              child: Text(
                'Take Photo',
                style: FabTypography.displayMedium16.copyWith(
                  color: FabColors.greyscale700,
                ),
              ),
            ),
          ),
        ),
        
        PaddingGap.md(),
        
        // Open Gallery Button
        Expanded(
          child: SizedBox(
            height: 52,
            child: FabButton.primary(
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _handleOpenGallery,
              size: FabButtonSize.large,
              child: Text(
                'Open Gallery',
                style: FabTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
