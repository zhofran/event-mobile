import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SpeakerBackgroundPage extends StatefulWidget {
  const SpeakerBackgroundPage({super.key});

  @override
  State<SpeakerBackgroundPage> createState() => _SpeakerBackgroundPageState();
}

class _SpeakerBackgroundPageState extends State<SpeakerBackgroundPage> {
  late FormGroup form;
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'title': FormControl<String>(validators: [Validators.required]),
      'year': FormControl<String>(validators: [Validators.required]),
      'company': FormControl<String>(validators: [Validators.required]),
      'portfolio': FormControl<String>(validators: [Validators.required]),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildRegisterForm()
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // For now, just navigate to a placeholder page
                  $.navigator.push(SpeakerLocationRoute());
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: const Text('Continue'),
              ),
            ),
          ],
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
              'Register Speaker',
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

  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Your Professional Background',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'This information helps us verify your profile and connect you to the right events.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Title Field
        FabTextfield(
          formControl: form.control('title') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Professional Title',
          hintText: 'e.g., Software Engineer',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.xs(),
        
        // Year Field
        FabTextfield(
          formControl: form.control('year') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Years of Experience',
          hintText: 'e.g., 5',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.xs(),
        
        // Company Field
        FabTextfield(
          formControl: form.control('company') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Company',
          hintText: 'e.g., Google',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),

        PaddingGap.xs(),
        
        // Portfolio Field
        FabTextfield(
          formControl: form.control('portfolio') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'LinkedIn or Portfolio URL',
          hintText: 'e.g., https://www.linkedin.com/in/yourprofile',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }
}