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
class ProfileCareerPage extends StatefulWidget {
  const ProfileCareerPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfileCareerPage> createState() => _ProfileCareerPageState();
}

class _ProfileCareerPageState extends State<ProfileCareerPage> {
  late FormGroup form;
  bool _isLoading = false;
  String? _selectedCareerStatus;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'careerStatus': FormControl<String>(
        validators: [Validators.required],
      ),
    });
  }

  Future<void> _handleProfileCareer() async {
    if (_selectedCareerStatus != null) {
      setState(() {
        _isLoading = true;
      });

      // Update form control with selected value
      form.control('careerStatus').value = _selectedCareerStatus;

      // Simulate profile setup process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful profile setup
      widget.onResult(true);
    }
  }

  void _selectCareerStatus(String status) {
    setState(() {
      _selectedCareerStatus = status;
    });
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
                        // Career selection content
                        _buildProfileCareerContent(),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Bottom button area
              _buildBottomButton(),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [ 
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

  Widget _buildProfileCareerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Thinking about making a career move?',
          style: FabTypography.heading3SemiBold.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),
        
        // Career Status Selection Options
        _buildCareerOption(
          'actively_looking',
          'Yes, I\'m actively looking',
          'Let us help you discover new roles that match your goals.',
          CupertinoIcons.search,
        ),

        PaddingGap.lg(),

        _buildCareerOption(
          'currently_employed',
          'I\'m currently employed',
          'Stay open to future opportunities tailored to your interests.',
          CupertinoIcons.briefcase,
        ),
        
        PaddingGap.xl(),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
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
          onPressed: _selectedCareerStatus != null 
            ? () => {
                $.navigator.push(ProfileJobRoute(onResult: widget.onResult))
              }
            : null,
        ),
      ),
    );
  }

  Widget _buildCareerOption(String value, String title, String description, IconData icon) {
    final isSelected = _selectedCareerStatus == value;
    
    return GestureDetector(
      onTap: () => _selectCareerStatus(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF97F3A).withOpacity(0.2) : FabColors.greyscale0,
          border: Border.all(
            color: isSelected ? FabColors.primary200 : FabColors.greyscale200,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? FabColors.primary200 : FabColors.greyscale200,
                ),
              ),
              child: Icon(
                icon,
                color:FabColors.greyscale500,
                size: 20,
              ),
            ),
            PaddingGap.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FabTextStyled(
                    title,
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.greyscale900,
                    ),
                  ),
                  PaddingGap.xs(),
                  FabTextStyled(
                    description,
                    style: FabTypography.displayRegular14.copyWith(
                      color: FabColors.greyscale400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
