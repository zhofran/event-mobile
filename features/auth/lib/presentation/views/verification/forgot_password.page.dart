import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late FormGroup form;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
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
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeText(),

                    PaddingGap.lg(),
                
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ReactiveForm(
                        formGroup: form,
                        child: _buildRegisterForm(),
                      ),
                    ),
                
                  ],
                ),
              )
            ),

            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _isLoading ? null : () {
                    $.navigator.replace(VerifyEmailRoute(onResult: (bool _) {}, title: 'Forgot Password', move: SetNewPasswordRoute()));
                  // if (form.valid) {
                  //   // Handle forgot password logic here
                  // } else {
                  //   setState(() {
                  //     form.markAllAsTouched();
                  //   });
                  // }
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Send Reset Link'),
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
              'Forgot Password',
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

  Widget _buildWelcomeText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Forgot Your Password?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'No worries, we’ll send you a link to reset it.\nJust enter the email address you use to log in.',
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
        
        // Email Field
        FabTextfield(
          formControl: form.control('email') as FormControl<String>,
          keyboardType: TextInputType.emailAddress,
          // labelText: 'Email',
          hintText: 'Email',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          prefixIcon: Icon(CupertinoIcons.mail, color: FabColors.primary300,),
        ),

      ],
    );
  }
}