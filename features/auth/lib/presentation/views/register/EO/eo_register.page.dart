import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/photo_avatar.dart';

@RoutePage()
class EORegisterPage extends StatefulWidget {
  const EORegisterPage({super.key});

  @override
  State<EORegisterPage> createState() => _EORegisterPageState();
}

class _EORegisterPageState extends State<EORegisterPage> {
  late FormGroup form;  
  
  String? _selectedCompanyType;

  final List<String> _companyType = [
    'Company',
    'Community/Association',
    'University/Institution',
    'Goverment Agency',
    'Independent Organizer',
    // Add more cities as needed
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'companyName': FormControl<String>(validators: [Validators.required]),
      'companyBio': FormControl<String>(validators: [Validators.required]),
    });
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
                  _buildWelcomeSection(),

                  PaddingGap.md(),

                  _buildPhotoAvatar(),

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
                onPressed: () {
                  $.navigator.push(
                    EODetailRoute(),
                  );
                },
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
              'Register Event Organizer',
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
      onImagePicked: (File? image) {
        print('Image picked: ${image?.path}');
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
            'Let’s start with your company',
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
    return DropdownButtonFormField<String>(
      hint: Text(
        'Company Type',
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
      initialValue: _selectedCompanyType,
      items: _companyType.map((size) {
        return DropdownMenuItem<String>(
          value: size,
          child: Text(size),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCompanyType = value;
        });
      },
      icon: Icon(
        UIcons.boldRounded.angle_small_down,
        size: 20,
      ),
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
        _buildCompanyType(),

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