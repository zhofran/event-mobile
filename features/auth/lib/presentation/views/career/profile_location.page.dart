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
class ProfileLocationPage extends StatefulWidget {
  const ProfileLocationPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<ProfileLocationPage> createState() => _ProfileLocationPageState();
}

class _ProfileLocationPageState extends State<ProfileLocationPage> {
  late FormGroup form;
  bool _isLoading = false;
  List<String> _selectedLocations = []; // Changed to list for multiple selection
  
  // Available city options as SelectOption list
  final List<SelectOption<String>> _cityOptions = [
    SelectOption(
      value: 'jakarta',
      label: 'Jakarta',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'surabaya',
      label: 'Surabaya',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'bandung',
      label: 'Bandung',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'medan',
      label: 'Medan',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'semarang',
      label: 'Semarang',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'makassar',
      label: 'Makassar',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'yogyakarta',
      label: 'Yogyakarta',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
    SelectOption(
      value: 'malang',
      label: 'Malang',
      icon: Icon(
        CupertinoIcons.building_2_fill,
        size: 20,
        color: FabColors.greyscale600,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'searchLocation': FormControl<String>(value: ''),
      'selectedLocations': FormControl<List<String>>(
        value: _selectedLocations,
        validators: [Validators.required],
      ),
    });
    _initializeLocationSelectionFormControl();
  }

  Future<void> _handleProfileLocation() async {
    if (_selectedLocations.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Update form control with selected values
      form.control('selectedLocations').value = _selectedLocations;

      // Simulate location setup process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful location setup
      widget.onResult(true);
    }
  }

  void _removeLocation(String location) {
    setState(() {
      _selectedLocations.remove(location);
    });
  }

  late FormControl<String> _locationSelectionFormControl;

  void _initializeLocationSelectionFormControl() {
    _locationSelectionFormControl = FormControl<String>();
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
                        // Location selection content
                        _buildProfileLocationContent(),
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
              'Add Location',
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

  Widget _buildProfileLocationContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingGap.md(),

        // Welcome text section
        FabTextStyled(
          'Where are you located?',
          style: FabTypography.heading3SemiBold.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.xl(),
        
        // Search field using FabTextfield
        FabTextfield(
          formControl: form.control('searchLocation') as FormControl<String>,
          hintText: 'e.g Jakarta, Surabaya, Bandung...',
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: FabColors.greyscale400,
            size: 20,
          ),
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.lg(),
        
        // Selected location badges
        if (_selectedLocations.isNotEmpty) ...[
          _buildSelectedLocationBadges(),
          PaddingGap.lg(),
        ],
        
        // Add Location button
        _buildAddLocationButton(),
        
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
          onPressed: _selectedLocations.isNotEmpty 
            ? () => {
                $.navigator.push(ProfileRecentJobRoute(onResult: widget.onResult))
              }
            : null,
        ),
      ),
    );
  }

  Widget _buildSelectedLocationBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedLocations.map((location) => _buildLocationBadge(location, true)).toList(),
    );
  }

  Widget _buildLocationBadge(String location, bool isSelected) {
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
            location,
            style: FabTypography.body.copyWith(
              color: isSelected ? FabColors.greyscale0 : FabColors.greyscale700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeLocation(location),
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

  Widget _buildAddLocationButton() {
    return FabSelectBottomSheet<String>(
      formControl: _locationSelectionFormControl,
      labelText: 'Add Location',
      hintText: 'Select a city to add',
      searchHintText: 'Search for cities',
      prefixIcon: Icon(
        CupertinoIcons.add,
        color: FabColors.primary,
      ),
      options: _cityOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null && !_selectedLocations.contains(selectedOption.label)) {
          setState(() {
            _selectedLocations.add(selectedOption.label);
          });
          // Clear the selection after adding
          _locationSelectionFormControl.value = null;
        }
      },
    );
  }
}
