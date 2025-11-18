import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/register.cubit.dart';

@RoutePage()
class EORepresentativePage extends StatefulWidget {
  const EORepresentativePage({required this.dataEO, super.key});
  
  final Map<String, dynamic> dataEO;

  @override
  State<EORepresentativePage> createState() => _EORepresentativePageState();
}

class _EORepresentativePageState extends State<EORepresentativePage> {
  final registerCubit = $.get<RegisterCubit>();
  late FormGroup form;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    form = FormGroup({
      'repName': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
        ],
      ),
      'role': FormControl<String>(
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
    });

    // Log received data
    log('Received EO Data:', name: 'EO Representative Page');
    widget.dataEO.forEach((key, value) {
      log('  $key: $value', name: 'EO Representative Page');
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: registerCubit,
        listener: (context, state) {
          state.whenOrNull(
            loading: () {
              // Show loading state
            },
            berhasil: () {
              // Success - navigate to next page
              if (_isSubmitting) {
                _isSubmitting = false;
                _showSuccessDialog();
              }
            },
            succeeded: (user) {
              if (_isSubmitting) {
                _isSubmitting = false;
                _showSuccessDialog();
              }
            },
            failed: (failure) {
              if (_isSubmitting) {
                _isSubmitting = false;
                _showSnackBar('Registration failed: ${failure.message}');
              }
            },
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    PaddingGap.md(),
                    _buildWelcomeSection(),
                    PaddingGap.lg(),
                    ReactiveForm(
                      formGroup: form,
                      child: _buildVerifyForm(),
                    ),
                  ],
                ),
              ),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              'Register Event Organizer',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          FabButton.secondary(
            onPressed: () {},
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
          'Organizer Representative',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.sm(),
        Text(
          "We'll use this contact for event coordination and official communication.",
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildVerifyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FabTextfield(
          formControl: form.control('repName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Authorized Representative Name',
          hintText: 'Full Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          validationMessages: {
            'required': (_) => 'Representative name is required',
            'minLength': (_) => 'Name must be at least 3 characters',
          },
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('role') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Position / Role',
          hintText: 'e.g., Marketing Director',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          validationMessages: {
            'required': (_) => 'Position is required',
          },
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('email') as FormControl<String>,
          keyboardType: TextInputType.emailAddress,
          labelText: 'Email',
          hintText: 'joedoe@email.com',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
          validationMessages: {
            'required': (_) => 'Email is required',
            'email': (_) => 'Please enter a valid email',
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      bloc: registerCubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: FabButton.primary(
            onPressed: _handleSubmit,
            size: FabButtonSize.large,
            width: double.infinity,
            child: Text(
              'Complete Registration',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.greyscale0,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!form.valid) {
      form.markAllAsTouched();
      _showSnackBar('Please fill in all required fields correctly');
      return;
    }

    // Validate all required data from previous pages
    if (!_validateDataEO()) {
      return;
    }

    _isSubmitting = true;

    // Prepare data for API
    final repName = form.control('repName').value as String;
    final repPosition = form.control('role').value as String;
    final repEmail = form.control('email').value as String;

    // Log final data before submission
    log('=== Final EO Registration Data ===', name: 'EO Representative Page');
    log('Company Name: ${widget.dataEO['company_name']}', name: 'Submit');
    log('Company Type ID: ${widget.dataEO['company_type_id']}', name: 'Submit');
    log('Description: ${widget.dataEO['company_description']}', name: 'Submit');
    log('Event Type IDs: ${widget.dataEO['event_type_ids']}', name: 'Submit');
    log('Event Size: ${widget.dataEO['average_event_size']}', name: 'Submit');
    log('Website: ${widget.dataEO['website_url']}', name: 'Submit');
    log('Social Media: ${widget.dataEO['social_media_url']}', name: 'Submit');
    log('City ID: ${widget.dataEO['city_id']}', name: 'Submit');
    log('Venue Types: ${widget.dataEO['venue_types']}', name: 'Submit');
    log('Rep Name: $repName', name: 'Submit');
    log('Rep Position: $repPosition', name: 'Submit');
    log('Rep Email: $repEmail', name: 'Submit');

    // Submit to API
    final success = await registerCubit.registerEventOrganizer(
      companyName: widget.dataEO['company_name'] as String,
      companyTypeId: widget.dataEO['company_type_id'] as int,
      companyDescription: widget.dataEO['company_description'] as String,
      eventTypeIds: (widget.dataEO['event_type_ids'] as List).cast<int>(),
      averageEventSize: widget.dataEO['average_event_size'] as String,
      websiteUrl: widget.dataEO['website_url'] as String,
      socialMediaUrl: widget.dataEO['social_media_url'] as String?,
      cityId: widget.dataEO['city_id'] as int,
      venueTypes: (widget.dataEO['venue_types'] as List).cast<String>(),
      repName: repName,
      repPosition: repPosition,
      repEmail: repEmail,
    );

    if (!success) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  bool _validateDataEO() {
    final requiredFields = {
      'company_name': 'Company name',
      'company_type_id': 'Company type',
      'company_description': 'Company description',
      'event_type_ids': 'Event types',
      'average_event_size': 'Event size',
      'website_url': 'Website URL',
      'city_id': 'City',
      'venue_types': 'Venue preferences',
    };

    for (final entry in requiredFields.entries) {
      if (!widget.dataEO.containsKey(entry.key) || 
          widget.dataEO[entry.key] == null ||
          (widget.dataEO[entry.key] is String && 
           (widget.dataEO[entry.key] as String).isEmpty) ||
          (widget.dataEO[entry.key] is List && 
           (widget.dataEO[entry.key] as List).isEmpty)) {
        _showSnackBar('Missing required field: ${entry.value}');
        log('Validation failed: ${entry.key} is missing or empty', name: 'Validation');
        return false;
      }
    }

    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Column(
          children: [
            Icon(
              Icons.check_circle,
              color: FabColors.success,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Registration Successful!',
              style: FabTypography.displaySemiBold20,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'Your Event Organizer profile has been created successfully.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          FabButton.primary(
            onPressed: () {
              Navigator.of(context).pop();
              $.navigator.replace(
                PermissionNotificationRoute(onResult: (bool _) {}),
              );
            },
            size: FabButtonSize.large,
            width: double.infinity,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: FabColors.error,
      ),
    );
  }
}
