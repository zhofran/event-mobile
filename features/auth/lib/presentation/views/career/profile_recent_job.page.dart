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
import 'package:feature_auth/_core/router.dart';

@RoutePage()
class ProfileRecentJobPage extends StatefulWidget {
  const ProfileRecentJobPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfileRecentJobPage> createState() => _ProfileRecentJobPageState();
}

class _ProfileRecentJobPageState extends State<ProfileRecentJobPage> {
  late FormGroup form;
  bool _isLoading = false;
  
  // Job title options
  final List<SelectOption<String>> _jobTitleOptions = [
    SelectOption(
      value: 'ui_ux_designer',
      label: 'UI UX Designer',
      icon: Icon(
        CupertinoIcons.paintbrush_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'ui_ux_researcher',
      label: 'UI UX Researcher',
      icon: Icon(
        CupertinoIcons.search,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'ux_analyst',
      label: 'UX Analyst',
      icon: Icon(
        CupertinoIcons.chart_bar_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'ux_architect',
      label: 'UX Architect',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'senior_ui_ux_designer',
      label: 'Senior UI UX Designer',
      icon: Icon(
        CupertinoIcons.star_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'senior_ux_analyst',
      label: 'Senior UX Analyst',
      icon: Icon(
        CupertinoIcons.star_circle_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
  ];

  // Job type options
  final List<SelectOption<String>> _jobTypeOptions = [
    SelectOption(
      value: 'fulltime',
      label: 'Fulltime',
      icon: Icon(
        CupertinoIcons.clock_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'part_time',
      label: 'Part Time',
      icon: Icon(
        CupertinoIcons.clock,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'freelance',
      label: 'Freelance',
      icon: Icon(
        CupertinoIcons.person_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'self_employee',
      label: 'Self Employee',
      icon: Icon(
        CupertinoIcons.briefcase_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'contract',
      label: 'Contract',
      icon: Icon(
        CupertinoIcons.doc_text_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'internship',
      label: 'Internship',
      icon: Icon(
        CupertinoIcons.book_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
  ];

  // Company options
  final List<SelectOption<String>> _companyOptions = [
    SelectOption(
      value: 'google',
      label: 'Google',
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: FabColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'G',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
    SelectOption(
      value: 'google_pay',
      label: 'Google Pay',
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'GP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
    SelectOption(
      value: 'google_teams',
      label: 'Google Teams',
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'GT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'recentJobTitle': FormControl<String>(
        validators: [Validators.required],
      ),
      'jobType': FormControl<String>(
        validators: [Validators.required],
      ),
      'recentCompany': FormControl<String>(
        validators: [Validators.required],
      ),
    });
  }

  Future<void> _handleProfileRecentJob() async {
    if (form.valid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate form submission process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful form submission
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
              
              // Main content area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileRecentJobContent(),
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
              'Find Job',
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

  Widget _buildProfileRecentJobContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Discover new people and opportunities',
          style: FabTypography.heading3SemiBold.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.md(),
        
        FabSelectBottomSheet<String>(
          formControl: form.control('recentJobTitle') as FormControl<String>,
          labelText: 'Recent Job',
          hintText: 'Select your recent job title',
          searchHintText: 'Search job titles',
          options: _jobTitleOptions,
          size: FabTextfieldSize.large,
          onChanged: (option) {
            // Optional: Handle job title selection
            print('Selected job title: ${option?.label}');
          },
        ),

        PaddingGap.md(),
        
        FabSelectBottomSheet<String>(
          formControl: form.control('jobType') as FormControl<String>,
          labelText: 'Job Type',
          hintText: 'Select job type',
          searchHintText: 'Search job types',
          options: _jobTypeOptions,
          size: FabTextfieldSize.large,
          onChanged: (option) {
            // Optional: Handle job type selection
            print('Selected job type: ${option?.label}');
          },
        ),

        PaddingGap.md(),
        
        FabSelectBottomSheet<String>(
          formControl: form.control('recentCompany') as FormControl<String>,
          labelText: 'Recent Company',
          hintText: 'Select your recent company',
          searchHintText: 'Search companies',
          options: _companyOptions,
          size: FabTextfieldSize.large,
          onChanged: (option) {
            // Optional: Handle company selection
            print('Selected company: ${option?.label}');
          },
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
        child: ReactiveFormConsumer(
          builder: (context, form, child) {
            return FabButton.primary(
              isLoading: _isLoading,
              child: Text(
                'Continue',
                style: FabTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              size: FabButtonSize.large,
              onPressed: form.valid 
                ? () => {
                    $.navigator.push(ProfilePhotoRoute(onResult: widget.onResult))
                  }
                : null,
            );
          },
        ),
      ),
    );
  }
}
