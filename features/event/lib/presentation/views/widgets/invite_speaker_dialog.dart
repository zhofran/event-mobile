import 'package:deps/design/design.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _InviteExternalSpeakerDialogState extends State<InviteExternalSpeakerDialog> {
  late FormGroup form;
  String generatedLink = '';

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'speakerName': FormControl<String>(
        validators: [Validators.required],
      ),
      'professionalTitle': FormControl<String>(
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'speakerFee': FormControl<String>(
        validators: [Validators.required],
      ),
    });

    // Generate invite link
    _generateInviteLink();
  }

  void _generateInviteLink() {
    // Generate random code for invite link
    String randomCode = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    setState(() {
      generatedLink = 'https://apni.com/invite/speaker/ABC$randomCode';
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
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
        child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
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
                  formControl: form.control('speakerName') as FormControl<String>,
                  labelText: 'Speaker Name',
                  hintText: 'Speaker Name',
                  textInputAction: TextInputAction.next,
                  size: FabTextfieldSize.large,
                ),

                const SizedBox(height: 16),

                // Professional Title Field
                FabTextfield(
                  formControl: form.control('professionalTitle') as FormControl<String>,
                  labelText: 'Professional Title',
                  hintText: 'e.g., Senior Geologist APNI Indonesia',
                  textInputAction: TextInputAction.next,
                  size: FabTextfieldSize.large,
                ),

                const SizedBox(height: 16),

                // Email Field
                FabTextfield(
                  formControl: form.control('email') as FormControl<String>,
                  labelText: 'Email',
                  hintText: 'Speaker Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  size: FabTextfieldSize.large,
                ),

                const SizedBox(height: 16),

                // Speaker Fee Field
                FabTextfield(
                  formControl: form.control('speakerFee') as FormControl<String>,
                  labelText: 'Speaker Fee',
                  hintText: 'Enter Speaker Fee (e.g. 10.000.000)',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  size: FabTextfieldSize.large,
                  inputFormatters: [
                    ThousandsSeparatorInputFormatter(),
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
                          Clipboard.setData(ClipboardData(text: generatedLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
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
                  onPressed: _handleAddSpeaker,
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
          ),
        ),
      ),
    );
  }

  void _handleAddSpeaker() {
    form.markAllAsTouched();

    if (!form.valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FabTextStyled(
            'Please fill all required fields correctly',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale0,
            ),
          ),
          backgroundColor: FabColors.error,
        ),
      );
      return;
    }

    // Collect form data
    final speakerData = {
      'speakerName': form.control('speakerName').value ?? '',
      'professionalTitle': form.control('professionalTitle').value ?? '',
      'email': form.control('email').value ?? '',
      'speakerFee': form.control('speakerFee').value ?? '',
      'inviteLink': generatedLink,
    };

    // Close dialog
    Navigator.pop(context);

    // Call callback
    widget.onSpeakerAdded(speakerData);
  }
}