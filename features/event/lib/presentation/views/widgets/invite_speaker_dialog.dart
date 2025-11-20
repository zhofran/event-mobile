import 'package:deps/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/forms/invite_speaker.form.dart';

class InviteExternalSpeakerDialog extends StatefulWidget {
  const InviteExternalSpeakerDialog({
    required this.onSpeakerAdded,
    super.key,
  });

  final Function(Map<String, dynamic>) onSpeakerAdded;

  @override
  State<InviteExternalSpeakerDialog> createState() =>
      _InviteExternalSpeakerDialogState();
}

class _InviteExternalSpeakerDialogState
    extends State<InviteExternalSpeakerDialog> {
  String generatedLink = '';

  @override
  void initState() {
    super.initState();

    // Generate invite link
    _generateInviteLink();
  }

  void _generateInviteLink() {
    // Generate random code for invite link
    final randomCode =
        DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    setState(() {
      generatedLink = 'https://apni.com/invite/speaker/ABC$randomCode';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: InviteSpeakerFormFormBuilder(
          builder: (context, formModel, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  const FabTextStyled(
                    'Invite External Speaker',
                    style: FabTypography.displayBold18,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  FabTextStyled(
                    'Send an invitation link to speakers outside your contact list. They\'ll receive an email with a unique link to join your event as a speaker.',
                    style: FabTypography.bodySmallRegular.copyWith(
                      color: FabColors.greyscale600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Speaker Name Field
                  FabTextfield(
                    formControl: formModel.nameControl,
                    labelText: 'Speaker Name',
                    hintText: 'Speaker Name',
                    textInputAction: TextInputAction.next,
                    size: FabTextfieldSize.large,
                  ),
                  const SizedBox(height: 16),

                  // Professional Title Field
                  FabTextfield(
                    formControl: formModel.titleControl,
                    labelText: 'Professional Title',
                    hintText: 'e.g., Senior Geologist APNI Indonesia',
                    textInputAction: TextInputAction.next,
                    size: FabTextfieldSize.large,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  FabTextfield(
                    formControl: formModel.emailControl,
                    labelText: 'Email',
                    hintText: 'Speaker Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    size: FabTextfieldSize.large,
                  ),
                  const SizedBox(height: 16),

                  // Speaker Fee Field
                  FabTextfield(
                    formControl: formModel.feeControl,
                    labelText: 'Speaker Fee',
                    hintText: 'Enter Speaker Fee (e.g. 10.000.000)',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    size: FabTextfieldSize.large,
                    inputFormatters: [
                      ThousandsSeparatorInputFormatter(separator: ','),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Generated invite link
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FabColors.greyscale50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: FabColors.greyscale200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            generatedLink,
                            style: FabTypography.bodySmallRegular.copyWith(
                              color: FabColors.greyscale600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: generatedLink));
                            FabSnackbar.success(
                              context: context,
                              content: 'Link copied to clipboard',
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 20,
                            color: FabColors.greyscale600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add Speaker Button
                  FabButton.primary(
                    onPressed: () => _handleAddSpeaker(formModel),
                    size: FabButtonSize.large,
                    width: double.infinity,
                    child: Text(
                      'Add Speaker',
                      style: FabTypography.displaySemiBold16.copyWith(
                        color: FabColors.greyscale0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: FabTextStyled(
                      'Cancel',
                      style: FabTypography.displayMedium16.copyWith(
                        color: FabColors.greyscale600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleAddSpeaker(InviteSpeakerFormForm formModel) {
    formModel.submit(
      onValid: (model) {
        // Collect form data
        final speakerData = {
          'name': model.name,
          'title': model.title,
          'email': model.email,
          'fee': model.fee,
          'inviteLink': generatedLink,
        };

        // Close dialog
        Navigator.pop(context);

        // Call callback
        widget.onSpeakerAdded(speakerData);
      },
      onNotValid: () {
        setState(() {
          formModel.form.markAllAsTouched();
        });
        FabSnackbar.error(
          context: context,
          content: 'Please fill all required fields correctly',
        );
      },
    );
  }
}