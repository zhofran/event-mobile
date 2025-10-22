import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SponsorVerificationPage extends StatefulWidget {
  const SponsorVerificationPage({super.key});

  @override
  State<SponsorVerificationPage> createState() => _SponsorVerificationPageState();
}

class _SponsorVerificationPageState extends State<SponsorVerificationPage> {
  late FormGroup form;
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'repName': FormControl<String>(
        validators: [Validators.required],
      ),
      'role': FormControl<String>(),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ReactiveForm(
                  formGroup: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),

                      PaddingGap.md(),

                      _buildVerifyForm(),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.replace(
                    PermissionNotificationRoute(onResult: (bool _) {}),
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

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Final Step: Verification',
          style: FabTypography.displaySemiBold22,
        ),

        PaddingGap.sm(),
        
        Text(
          'Once verified, your company can access premium sponsorship features and analytics.',
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
        
        // First Name Field
        FabTextfield(
          formControl: form.control('repName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Authorized Representative Name',
          hintText: 'Full Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('role') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Position / Role',
          hintText: 'e.g., Marketing Director',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

  
}