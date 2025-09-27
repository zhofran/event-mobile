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
class SetupPhoneNumberPage extends StatefulWidget {
  const SetupPhoneNumberPage({required this.onResult, super.key});

  final Function(bool didChange) onResult;

  @override
  State<SetupPhoneNumberPage> createState() => _SetupPhoneNumberPageState();
}

class _SetupPhoneNumberPageState extends State<SetupPhoneNumberPage> {
  late FormGroup form;
  bool _isLoading = false;

  // Country code mapping
  final Map<String, String> _countryCodes = {
    'ID': '+62',
    'US': '+1',
    'SG': '+65',
    'MY': '+60',
    'TH': '+66',
    'VN': '+84',
    'PH': '+63',
    'AU': '+61',
    'JP': '+81',
    'KR': '+82',
    'CN': '+86',
    'IN': '+91',
    'GB': '+44',
    'DE': '+49',
    'FR': '+33',
    'CA': '+1',
    'BR': '+55',
    'MX': '+52',
    'AR': '+54',
    'CL': '+56',
  };

  // Country options list
  final List<SelectOption<String>> _countryOptions = [
    SelectOption(
      value: 'ID',
      label: 'Indonesia',
      icon: const Text('🇮🇩', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'US',
      label: 'United States',
      icon: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'SG',
      label: 'Singapore',
      icon: const Text('🇸🇬', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'MY',
      label: 'Malaysia',
      icon: const Text('🇲🇾', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'TH',
      label: 'Thailand',
      icon: const Text('🇹🇭', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'VN',
      label: 'Vietnam',
      icon: const Text('🇻🇳', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'PH',
      label: 'Philippines',
      icon: const Text('🇵🇭', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'AU',
      label: 'Australia',
      icon: const Text('🇦🇺', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'JP',
      label: 'Japan',
      icon: const Text('🇯🇵', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'KR',
      label: 'South Korea',
      icon: const Text('🇰🇷', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'CN',
      label: 'China',
      icon: const Text('🇨🇳', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'IN',
      label: 'India',
      icon: const Text('🇮🇳', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'GB',
      label: 'United Kingdom',
      icon: const Text('🇬🇧', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'DE',
      label: 'Germany',
      icon: const Text('🇩🇪', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'FR',
      label: 'France',
      icon: const Text('🇫🇷', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'CA',
      label: 'Canada',
      icon: const Text('🇨🇦', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'BR',
      label: 'Brazil',
      icon: const Text('🇧🇷', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'MX',
      label: 'Mexico',
      icon: const Text('🇲🇽', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'AR',
      label: 'Argentina',
      icon: const Text('🇦🇷', style: TextStyle(fontSize: 20)),
    ),
    SelectOption(
      value: 'CL',
      label: 'Chile',
      icon: const Text('🇨🇱', style: TextStyle(fontSize: 20)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'country': FormControl<String>(
        validators: [Validators.required],
      ),
      'phoneNumber': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^[0-9]{8,15}$'), // Phone number validation
        ],
      ),
    });
  }

  Future<void> _handleSetupPhoneNumber() async {
    if (form.valid) {
      setState(() {
        _isLoading = true;
      });

      // Get form values
      final country = form.control('country').value;
      final phoneNumber = form.control('phoneNumber').value;

      // Log the form data (in real app, this would be sent to API)
      print('Phone Number Setup Data:');
      print('Country: $country');
      print('Phone Number: $phoneNumber');

      // Simulate phone number setup process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Call onResult with true to indicate successful phone number setup
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
                        _buildSetupPhoneNumberNameForm(),
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
              'Phone Number',
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

  Widget _buildSetupPhoneNumberNameForm() {
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
        
        // Country Field
        FabSelectBottomSheet<String>(
          formControl: form.control('country') as FormControl<String>,
          labelText: 'Country',
          hintText: 'Select your country',
          searchHintText: 'Search Country',
          options: _countryOptions,
          size: FabTextfieldSize.large,
          onChanged: (option) {
            // Optional: Handle country selection
            print('Selected country: ${option?.label}');
          },
        ),

        PaddingGap.md(),
        
        // Phone Number Field
        _buildPhoneNumberField(),
        
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
              $.navigator.push(OTPVerificationRoute(
                onResult: (result) {
                  if (result) {
                    $.navigator.pop();
                  }
                },
              ))
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FabTextStyled(
            'Number Phone',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale700,
            ),
          ),
        ),
        
        // Phone Number Input with Country Code Prefix
        ReactiveValueListenableBuilder<String>(
          formControl: form.control('country') as FormControl<String>,
          builder: (context, control, child) {
            final selectedCountry = control.value;
            final countryCode = selectedCountry != null ? _countryCodes[selectedCountry] ?? '+62' : '+62';
            final selectedOption = _countryOptions.firstWhere(
              (option) => option.value == selectedCountry,
              orElse: () => _countryOptions.first,
            );
            
            return Container(
              decoration: BoxDecoration(
                color: FabColors.background,
                border: Border.all(
                  color: FabColors.greyscale200,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Country Flag and Code Prefix
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedOption.icon != null) selectedOption.icon!,
                        const SizedBox(width: 8),
                        FabTextStyled(
                          countryCode,
                          style: FabTypography.displayRegular16.copyWith(
                            color: FabColors.greyscale700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 16,
                          color: FabColors.greyscale400,
                        ),
                      ],
                    ),
                  ),
                  
                  // Divider
                  Container(
                    width: 1,
                    height: 24,
                    color: FabColors.greyscale200,
                  ),
                  
                  // Phone Number Input
                  Expanded(
                    child: ReactiveTextField<String>(
                      formControl: form.control('phoneNumber') as FormControl<String>,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: '812-3456-7890',
                        hintStyle: FabTypography.displayRegular16.copyWith(
                          color: FabColors.greyscale400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: FabTypography.displayRegular16.copyWith(
                        color: FabColors.greyscale700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
