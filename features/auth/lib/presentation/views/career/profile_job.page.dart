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
class ProfileJobPage extends StatefulWidget {
  const ProfileJobPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfileJobPage> createState() => _ProfileJobPageState();
}

class _ProfileJobPageState extends State<ProfileJobPage> {
  late FormGroup form;
  bool _isLoading = false;
  List<String> _selectedJobs = []; // No pre-selected jobs
  
  // Available job positions as SelectOption list
  final List<SelectOption<String>> _jobOptions = [
    SelectOption(
      value: 'ui_ux_designer',
      label: 'UI UX Designer',
      icon: Icon(
        CupertinoIcons.paintbrush,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'ux_analyst',
      label: 'UX Analyst',
      icon: Icon(
        CupertinoIcons.chart_bar,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'product_designer',
      label: 'Product Designer',
      icon: Icon(
        CupertinoIcons.cube_box,
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
        CupertinoIcons.star,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'senior_ux_analyst',
      label: 'Senior UX Analyst',
      icon: Icon(
        CupertinoIcons.star_circle,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'searchJob': FormControl<String>(value: ''),
      'selectedJobs': FormControl<List<String>>(
        value: _selectedJobs,
        validators: [Validators.required],
      ),
    });
    _initializeJobSelectionFormControl();
  }

  Future<void> _handleProfileJob() async {
    if (_selectedJobs.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Update form control with selected values
      form.control('selectedJobs').value = _selectedJobs;

      // Simulate profile setup process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful profile setup
      widget.onResult(true);
    }
  }

  void _removeJob(String job) {
    setState(() {
      _selectedJobs.remove(job);
    });
  }

  late FormControl<String> _jobSelectionFormControl;

  void _initializeJobSelectionFormControl() {
    _jobSelectionFormControl = FormControl<String>();
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
                        _buildProfileJobContent(),
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
              'Add Job',
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

  Widget _buildProfileJobContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Which positions are you open to considering?',
          style: FabTypography.heading3SemiBold.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),
        
        // Search field using FabTextfield
        FabTextfield(
          formControl: form.control('searchJob') as FormControl<String>,
          hintText: 'e.g Product Designer, Social Media Sp...',
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: FabColors.greyscale400,
            size: 20,
          ),
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.lg(),
        
        // Selected job badges
        if (_selectedJobs.isNotEmpty) ...[
          _buildSelectedJobBadges(),
          PaddingGap.lg(),
        ],
        
        // Add Job button
        _buildAddJobButton(),
        
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
          onPressed: _selectedJobs.isNotEmpty 
            ? () => {
                $.navigator.push(ProfileLocationRoute(onResult: widget.onResult))
              }
            : null,
        ),
      ),
    );
  }

  Widget _buildSelectedJobBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedJobs.map((job) => _buildJobBadge(job, true)).toList(),
    );
  }

  Widget _buildJobBadge(String job, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? FabColors.primary : FabColors.greyscale100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FabTextStyled(
            job,
            style: FabTypography.body.copyWith(
              color: isSelected ? FabColors.greyscale0 : FabColors.greyscale700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeJob(job),
              child: Icon(
                CupertinoIcons.xmark,
                size: 16,
                color: FabColors.greyscale0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddJobButton() {
    return FabSelectBottomSheet<String>(
      formControl: _jobSelectionFormControl,
      labelText: 'Add Job Position',
      hintText: 'Select a job position to add',
      searchHintText: 'Search for job positions',
      prefixIcon: Icon(
        CupertinoIcons.add,
        color: FabColors.primary,
      ),
      options: _jobOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null && !_selectedJobs.contains(selectedOption.label)) {
          setState(() {
            _selectedJobs.add(selectedOption.label);
          });
          // Clear the selection after adding
          _jobSelectionFormControl.value = null;
        }
      },
    );
  }
}
