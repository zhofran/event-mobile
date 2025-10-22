import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/photo_avatar.dart';

@RoutePage()
class AttendeeRegisterPage extends StatefulWidget {
  const AttendeeRegisterPage({super.key});

  @override
  State<AttendeeRegisterPage> createState() => _AttendeeRegisterPageState();
}

class _AttendeeRegisterPageState extends State<AttendeeRegisterPage> {
  late FormGroup form;
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'firstName': FormControl<String>(
        validators: [Validators.required],
      ),
      'lastName': FormControl<String>(),
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
                  PaddingGap.lg(),

                  _buildPhotoAvatar(),

                  PaddingGap.lg(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  PaddingGap.xl(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildRegisterForm(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.push(
                    AttendeeTopicRoute(),
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
        ),
      )
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
              'Register Attendee',
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
        const FabTextStyled(
          "Let's start with your personal details",
          style: FabTypography.displayBold22,
        ),

        PaddingGap.xs(),

        FabTextStyled(
          "Let's make this experience a bit more personal.",
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
          // textAlign: TextAlign.center,
        ),
      ]
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // First Name Field
        FabTextfield(
          formControl: form.control('firstName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'First Name',
          hintText: 'First Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('lastName') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Last Name',
          hintText: 'Last Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Bio Field
        FabTextfield(
          formControl: form.control('bio') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Your Bio',
          hintText: 'Share a little about yourself',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

  
}