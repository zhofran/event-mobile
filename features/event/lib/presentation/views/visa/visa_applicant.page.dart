import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class VisaApplicantPage extends StatefulWidget {
  const VisaApplicantPage({super.key});

  @override
  State<VisaApplicantPage> createState() => _VisaApplicantPageState();
}

class _VisaApplicantPageState extends State<VisaApplicantPage> {
  late FormGroup formGroup;
  File? passportScan;

  final List<String> nationalities = [
    'Indonesia',
    'Malaysia',
    'Singapore',
    'Thailand',
    'Philippines',
  ];

  @override
  void initState() {
    super.initState();
    
    formGroup = FormGroup({
      'fullName': FormControl<String>(
        // validators: [Validators.required],
      ),
      'nationality': FormControl<String>(
        // validators: [Validators.required],
      ),
      'passportNumber': FormControl<String>(
        // validators: [Validators.required],
      ),
      'birthdate': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'passportExpiryDate': FormControl<DateTime>(
        // validators: [Validators.required],
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
              child: ReactiveForm(
                formGroup: formGroup,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildHeader(),

                    PaddingGap.lg(),

                    _buildStepTitle(),

                    PaddingGap.lg(),
                    
                    _buildForm(),
                  ],
                ),
              ),
            ),
            _buildContinueButton(),
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
            onPressed: () => $.navigator.pop(),
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
              'Visa Application',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Apply for Visa Assistance',
          style: FabTypography.displaySemiBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Let us help you prepare your travel documents for this event.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildStepTitle() {
    return const FabTextStyled(
      'Step 1 - Applicant Information',
      style: FabTypography.displaySemiBold18,
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        FabTextfield(
          formControl: formGroup.control('fullName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Full Name (As in Passport)',
          hintText: 'Full Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Nationality Dropdown
        FabTextStyled(
          'Nationality *',
          style: FabTypography.displayMedium14.copyWith(
            color: FabColors.greyscale900,
          ),
        ),
        PaddingGap.xs(),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('nationality') as FormControl<String>,
          decoration: InputDecoration(
            hintText: 'Select',
            hintStyle: FabTypography.displayRegular16.copyWith(
              color: FabColors.greyscale300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: FabColors.greyscale200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: FabColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: nationalities
              .map((nationality) => DropdownMenuItem(
                    value: nationality,
                    child: Text(nationality),
                  ))
              .toList(),
        ),
        PaddingGap.md(),

        // Passport Number
        FabTextfield(
          formControl: formGroup.control('passportNumber') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Passport Number',
          hintText: 'Passport Number',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Birthdate
        _buildDateField(
          'Birthdate',
          formGroup.control('birthdate') as FormControl<DateTime>,
        ),
        PaddingGap.md(),

        // Passport Expiry Date
        _buildDateField(
          'Passport Expiry Date',
          formGroup.control('passportExpiryDate') as FormControl<DateTime>,
        ),
        PaddingGap.md(),

        // Upload Passport Scan
        FabTextStyled(
          'Upload Passport Scan *',
          style: FabTypography.displayMedium14.copyWith(
            color: FabColors.greyscale900,
          ),
        ),
        PaddingGap.xs(),
        _buildPassportUpload(),
      ],
    );
  }

  Widget _buildDateField(String label, FormControl<DateTime> control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FabTextStyled(
          '$label *',
          style: FabTypography.displayMedium14.copyWith(
            color: FabColors.greyscale900,
          ),
        ),
        PaddingGap.xs(),
        ReactiveDatePicker<DateTime>(
          formControl: control,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, picker, child) {
            return InkWell(
              onTap: () => picker.showPicker(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: FabColors.greyscale200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FabTextStyled(
                      control.value != null
                          ? '${control.value!.day.toString().padLeft(2, '0')}-${control.value!.month.toString().padLeft(2, '0')}-${control.value!.year}'
                          : 'Select',
                      style: FabTypography.displayRegular16.copyWith(
                        color: control.value != null
                            ? FabColors.greyscale900
                            : FabColors.greyscale300,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: FabColors.greyscale400,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPassportUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final picker = ImagePicker();
            final image = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              setState(() {
                passportScan = File(image.path);
              });
            }
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: FabColors.greyscale200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: passportScan == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: FabColors.primary,
                  ),                  
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  passportScan!,
                  fit: BoxFit.cover,
                ),
              ),
          ),
        ),
        PaddingGap.sm(),
        FabTextStyled(
          'Supported formats: JPG, PNG, or PDF (max 5MB)',
          style: FabTypography.displayRegular12.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FabButton.primary(
        onPressed: () {
            $.navigator.push(VisaTravelDetailRoute());
          // if (formGroup.valid && passportScan != null) {
          //   // TODO: Save data to a shared state/provider
          // } else {
          //   formGroup.markAllAsTouched();
          //   // Show error message if passport not uploaded
          //   if (passportScan == null) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Please upload your passport scan'),
          //       ),
          //     );
          //   }
          // }
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
    );
  }
}
