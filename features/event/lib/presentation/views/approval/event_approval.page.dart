import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EventApprovalPage extends StatelessWidget {
  const EventApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area - properly centered
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Approval Content
                        Image.asset(
                          Assets.images.eventApproval.path,
                          width: 240,
                          height: 240,
                          package: 'design',
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Event Submitted for Approval',
                          style: FabTypography.displayBold.copyWith(
                            fontSize: 24
                          ),
                        ),

                        PaddingGap.sm(),

                        Text(
                          'Your event “TechFest 2025” has been successfully submitted and is now under review.Sponsors and vendors can already view and apply, but attendees will only see it once approved.',
                          style: FabTypography.bodySmallSemiBold.copyWith(
                            color: FabColors.textPrimary
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),
                        Text(
                          'You’ll receive a notification once your event is approved and published to the public.',
                          style: FabTypography.bodySmallRegular.copyWith(
                            color: FabColors.greyscale400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 52,
                child: FabButton.primary(
                  size: FabButtonSize.large,
                  onPressed: () {
                    $.navigator.replace(const HomeRoute());
                  },
                  child: Text(
                    'Go to Dashboard',
                    style: FabTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}