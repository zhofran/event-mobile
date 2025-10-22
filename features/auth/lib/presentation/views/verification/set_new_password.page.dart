import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  late FormGroup form;
  bool _isLoading = false;
  bool _isObscure = true;
  bool _isObscure2 = true;

  Future<void> _handleRegister() async {
    setState(() {
        _isLoading = true;
      });

      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // For now, just call onResult with true
      await $.navigator.replace(const SetSuccessfulRoute());
  }

   @override
   void initState() {
    super.initState();
    form = FormGroup({
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(
        validators: [Validators.required],
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

            // Register Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _isLoading ? null : _handleRegister,
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
            'Set your new password',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'Enter and confirm your new password to regain access to your account.',
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
        // Password Field
        FabTextfield(
          formControl: form.control('password') as FormControl<String>,
          keyboardType: TextInputType.text,
          // labelText: 'Password',
          hintText: 'Password',
          textInputAction: TextInputAction.next,
          obscureText: _isObscure,
          size: FabTextfieldSize.large,
          prefixIcon: Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye, color: FabColors.primary300), 
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
        
        PaddingGap.md(),
        
        // Confirm Password Field
        FabTextfield(
          formControl: form.control('confirmPassword') as FormControl<String>,
          keyboardType: TextInputType.text,
          // labelText: 'Konfirmasi Password',
          hintText: 'Confirm Password',
          textInputAction: TextInputAction.done,
          obscureText: _isObscure2,
          size: FabTextfieldSize.large,
          prefixIcon: Icon(CupertinoIcons.lock, color: FabColors.primary300),
          suffixIcon: IconButton(
            icon: Icon(_isObscure2 ? CupertinoIcons.eye_slash : CupertinoIcons.eye, color: FabColors.primary300),
            onPressed: () {
              setState(() {
                _isObscure2 = !_isObscure2;
              });
            },
          ),
        ),
      ],
    );
  }


}