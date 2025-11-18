import 'dart:developer';
import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/company_type.model.dart';
import '../../../cubits/register.cubit.dart';
import '../../widgets/photo_avatar.dart';

@RoutePage()
class EORegisterPage extends StatefulWidget {
  const EORegisterPage({super.key});

  @override
  State<EORegisterPage> createState() => _EORegisterPageState();
}

class _EORegisterPageState extends State<EORegisterPage> {
  late FormGroup form;
  late final RegisterCubit registerCubit;
  
  CompanyTypeModel? _selectedCompanyType;
  File? _avatarImage;
  bool _isLoadingCompanyTypes = false;

  @override
  void initState() {
    super.initState();
    registerCubit = $.get<RegisterCubit>();
    
    form = FormGroup({
      'companyName': FormControl<String>(validators: [Validators.required]),
      'companyBio': FormControl<String>(),
      'companyType': FormControl<CompanyTypeModel>(validators: [Validators.required]),
    });

    // Load company types on init
    _loadCompanyTypes();
  }

  Future<void> _loadCompanyTypes() async {
    setState(() => _isLoadingCompanyTypes = true);
    await registerCubit.getAllCompanyType();
    if (mounted) {
      setState(() => _isLoadingCompanyTypes = false);
    }
  }

  void _handleContinue() {
    // if (form.valid && _selectedCompanyType != null) {
      final companyName = form.control('companyName').value as String;
      final companyBio = form.control('companyBio').value as String;
      
      log('Form Data:', name: 'EORegisterPage');
      log('Company Name: $companyName', name: 'EORegisterPage');
      log('Company Type ID: ${_selectedCompanyType!.id}', name: 'EORegisterPage');
      log('Company Type Name: ${_selectedCompanyType!.name}', name: 'EORegisterPage');
      log('Company Bio: $companyBio', name: 'EORegisterPage');
      log('Avatar: ${_avatarImage?.path}', name: 'EORegisterPage');

      final dataEO = {
        'companyName': companyName,
        'companyTypeId': _selectedCompanyType?.id,
        'company_description': companyBio,
      };

      // Navigate to next page with data
      $.navigator.push(
        EODetailRoute(
          dataEO: dataEO,
          // companyName: companyName,
          // companyTypeId: _selectedCompanyType!.id,
          // companyTypeName: _selectedCompanyType!.name,
          // companyBio: companyBio,
          // avatarFile: _avatarImage,
        ),
      );
    // } else {
    //   form.markAllAsTouched();
      
    //   if (_selectedCompanyType == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Please select a company type'),
    //         backgroundColor: FabColors.error,
    //       ),
    //     );
    //   }
    // }
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
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              _buildAppBar(),
          
              Expanded(
                child: BlocListener<RegisterCubit, RegisterState>(
                  bloc: registerCubit,
                  listener: (context, state) {
                    state.whenOrNull(
                      failed: (failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(failure.message),
                            backgroundColor: FabColors.error,
                          ),
                        );
                      },
                    );
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildWelcomeSection(),
                      PaddingGap.md(),
                      _buildPhotoAvatar(),
                      PaddingGap.md(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildRegisterForm(),
                      ),
                    ],
                  ),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    return FabButton.primary(
                      onPressed: _handleContinue,
                      size: FabButtonSize.large,
                      width: double.infinity,
                      child: Text(
                        'Continue',
                        style: FabTypography.displaySemiBold16.copyWith(
                          color: FabColors.greyscale0,
                        ),
                      ),
                    );
                  },
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
            onPressed: () => $.navigator.pop(),
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
            onPressed: () {
              // TODO: Show help dialog
            },
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
  
  Widget _buildPhotoAvatar() {
    return PhotoAvatar(
      size: 120,
      backgroundColor: FabColors.primary0,
      iconColor: FabColors.primary200,
      onImagePicked: (File? image) {
        setState(() {
          _avatarImage = image;
        });
        log('Image picked: ${image?.path}', name: 'EORegisterPage');
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Let\'s start with your company',
            style: FabTypography.displaySemiBold22,
          ),
          PaddingGap.sm(),
          Text(
            'Tell us who you are, this helps us verify your organizer profile and build your event space.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyType() {
    // Loading state
    if (_isLoadingCompanyTypes) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: FabColors.greyscale200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading company types...',
              style: FabTypography.bodyLargeMedium.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (registerCubit.companyTypes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: FabColors.error),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: FabColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Failed to load company types',
                style: FabTypography.bodyLargeMedium.copyWith(
                  color: FabColors.error,
                ),
              ),
            ),
            TextButton(
              onPressed: _loadCompanyTypes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state - show dropdown
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Type',
          style: FabTypography.bodyLargeMedium.copyWith(
            color: FabColors.greyscale900,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CompanyTypeModel>(
          hint: Text(
            'Select Company Type',
            style: FabTypography.bodyLargeMedium.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: _selectedCompanyType == null && form.touched
                ? 'Please select a company type'
                : null,
          ),
          initialValue: _selectedCompanyType,
          items: registerCubit.companyTypes.map((type) {
            return DropdownMenuItem<CompanyTypeModel>(
              value: type,
              child: Text(
                type.name,
                style: FabTypography.bodyLargeMedium,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCompanyType = value;
              form.control('companyType').value = value;
            });
            log('Selected company type: ${value?.name} (ID: ${value?.id})', 
                name: 'EORegisterPage');
          },
          icon: Icon(
            UIcons.boldRounded.angle_small_down,
            size: 20,
            color: FabColors.greyscale600,
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Company Name Field
        FabTextfield(
          formControl: form.control('companyName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Company Name',
          hintText: 'Enter your company name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Company Type Dropdown
        _buildCompanyType(),

        PaddingGap.md(),

        // Company Bio Field
        FabTextfield(
          formControl: form.control('companyBio') as FormControl<String>,
          keyboardType: TextInputType.multiline,
          labelText: 'Company Bio',
          hintText: 'Share a little about your company',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
          maxLines: 4,
          minLines: 3,
        ),
      ],
    );
  }
}