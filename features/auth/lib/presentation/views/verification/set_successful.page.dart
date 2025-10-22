import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SetSuccessfulPage extends StatefulWidget {
  const SetSuccessfulPage({super.key});

  @override
  State<SetSuccessfulPage> createState() => _SetSuccessfulPageState();
}

class _SetSuccessfulPageState extends State<SetSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Register Form
                        _buildRegisterForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // $.navigator.replace(LoginRoute(onResult: (bool _) {}));
                  $.navigator.replace(LoginRoute(onResult: (bool _) {}));
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  'Login',
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FabTextStyled(
              'Notification Permission',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image from Asset
        Center(
          child: Image.asset(
            Assets.images.setSuccessful.path,
            width: 120,
            height: 120,
            package: 'design',
          ),
        ),

        PaddingGap.md(),

        FabTextStyled(
          'Password updated successfully!',
          textAlign: TextAlign.center,
          style: FabTypography.displaySemiBold22.copyWith(
            color: FabColors.greyscale700,
          ),
        ),

        PaddingGap.sm(),

        FabTextStyled(
          'You can now log in using your new password.',
          textAlign: TextAlign.center,
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale700,
          ),
        ),
      ],
    );
  }

  
}