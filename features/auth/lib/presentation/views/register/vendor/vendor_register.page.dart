import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../cubits/register.cubit.dart';
import '../../../cubits/vendor_registration.cubit.dart';
import '../../widgets/photo_avatar.dart';

@RoutePage()
class VendorRegisterPage extends StatefulWidget {
  const VendorRegisterPage({super.key});

  @override
  State<VendorRegisterPage> createState() => _VendorRegisterPageState();
}

class _VendorRegisterPageState extends State<VendorRegisterPage> {
  late FormGroup form;  
  
  String? _selectedBusinessType;
  String? _selectedBusinessTypeId;
  File? _selectedImage;

  final vendorRegistrationCubit = $.get<VendorRegistrationCubit>();
  final registerCubit = $.get<RegisterCubit>();

  final List<String> _businessType = [
    'Catering',
    'Equipment Rental',
    'Security',
    'Transportation',
    'Booth Design',
    'Other',
    // Add more cities as needed
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'companyName': FormControl<String>(validators: [Validators.required]),
      'companyType': FormControl<String>(validators: [Validators.required]),
      'companyBio': FormControl<String>(validators: [Validators.required]),
    });
    
    // Load company types
    registerCubit.getAllCompanyType();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildPhotoAvatar(),

                  PaddingGap.md(),

                  _buildWelcomeSection(),

                  PaddingGap.md(),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                    child: ReactiveForm(
                      formGroup: form, 
                      child: _buildRegisterForm()
                    ),
                  )
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _onContinuePressed,
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  'Continue',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
            ),
          ],
        )
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
              'Register Vendor',
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
  
  Widget _buildPhotoAvatar() {
    return PhotoAvatar(
      size: 120,
      backgroundColor: FabColors.primary0,
      iconColor: FabColors.primary200,
      selectedImage: _selectedImage,
      onImagePicked: (File? image) {
        setState(() {
          _selectedImage = image;
        });
      },
    );
  }

  void _onContinuePressed() {
    if (form.valid) {
      // Save Step 1 data to cubit
      vendorRegistrationCubit.updateStep1(
        companyName: form.control('companyName').value as String?,
        companyType: _selectedBusinessType,
        companyTypeId: _selectedBusinessTypeId ?? '1', // Default to first type
        companyDescription: form.control('companyBio').value as String?,
        companyAvatar: _selectedImage?.path,
      );

      // Navigate to next step
      $.navigator.push(VendorDetailRoute());
    } else {
      // Mark all as touched to show validation errors
      form.markAllAsTouched();
    }
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Let’s start with your company',
            style: FabTypography.displaySemiBold22,
          ),
      
          PaddingGap.sm(),
      
          Text(
            'We’ll use this info to help event organizers find and trust your services.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        StreamBuilder<RegisterState>(
          stream: registerCubit.stream,
          initialData: registerCubit.state,
          builder: (context, snapshot) {
            final companyTypes = registerCubit.companyTypes;
            
            return DropdownButtonFormField<String>(
              hint: Text(
                'Business Type',
                style: FabTypography.bodyLargeMedium.copyWith(
                  color: FabColors.greyscale400
                ),
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: FabColors.greyscale200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: FabColors.primary300),
                ),
              ),
              value: _selectedBusinessTypeId,
              items: companyTypes.map((companyType) {
                return DropdownMenuItem<String>(
                  value: companyType.id.toString(),
                  child: Text(companyType.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBusinessTypeId = value;
                  // Find the company type name for display
                  final selectedType = companyTypes.firstWhere(
                    (type) => type.id.toString() == value,
                    orElse: () => companyTypes.first,
                  );
                  _selectedBusinessType = selectedType.name;
                });
              },
              icon: Icon(
                UIcons.boldRounded.angle_small_down,
                size: 20,
              ),
            );
          },
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
          hintText: 'Company Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Company Type
        _buildBusinessType(),

        Visibility(
          visible: _selectedBusinessType == 'Other' ? true : false,
          child: Column(
            children: [
              PaddingGap.md(),
              
              FabTextfield(
                formControl: form.control('companyType') as FormControl<String>,
                keyboardType: TextInputType.name,
                // labelText: 'Company Name',
                hintText: 'Company Type',
                textInputAction: TextInputAction.next,
                size: FabTextfieldSize.large,
              ),
            ],
          ),
        ),

        PaddingGap.md(),

        // Company Bio Field
        FabTextfield(
          formControl: form.control('companyBio') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Company Bio',
          hintText: 'Share a little about your company',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

}