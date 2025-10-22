import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/photo_avatar.dart';

@RoutePage()
class SponsorRegisterPage extends StatefulWidget {
  const SponsorRegisterPage({super.key});

  @override
  State<SponsorRegisterPage> createState() => _SponsorRegisterPageState();
}

class _SponsorRegisterPageState extends State<SponsorRegisterPage> {
  late FormGroup form;
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'companyName': FormControl<String>(
        validators: [Validators.required],
      ),
      'brandName': FormControl<String>(),
      'bio': FormControl<String>(),
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
                  _buildPhotoAvatar(),

                  PaddingGap.md(),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildRegisterForm(),
                    ),
                  ),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.push(
                    SponsorDetailRoute(),
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
              'Register Sponsor',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Let’s start with your company',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.sm(),
        Text(
          'Tell us about your company so we can connect you with the right events and audiences.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
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
        
        // Brand Name Field
        FabTextfield(
          formControl: form.control('brandName') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Brand Name',
          hintText: 'Brand Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Bio Field
        FabTextfield(
          formControl: form.control('bio') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Company Bio',
          hintText: 'Share a little about yourself',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

}