import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VisaAccomodationPage extends StatefulWidget {
  const VisaAccomodationPage({super.key});

  @override
  State<VisaAccomodationPage> createState() => _VisaAccomodationPageState();
}

class _VisaAccomodationPageState extends State<VisaAccomodationPage> {
  late FormGroup formGroup;
  bool useBookedHotel = false;

  @override
  void initState() {
    super.initState();
    
    formGroup = FormGroup({
      'hotelName': FormControl<String>(
        // validators: [Validators.required],
      ),
      'hotelLocation': FormControl<String>(
        // validators: [Validators.required],
      ),
      'checkIn': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'checkOut': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'bookingRef': FormControl<String>(
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
      'Step 3 - Accommodation Details',
      style: FabTypography.displaySemiBold18,
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use my booked hotel toggle
        Row(
          children: [
            CupertinoSwitch(
              value: useBookedHotel,
              activeColor: FabColors.primary,
              onChanged: (value) {
                setState(() {
                  useBookedHotel = value;
                });
              },
            ),
            const SizedBox(width: 8),
            FabTextStyled(
              'Use my booked hotel',
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale900,
              ),
            ),
          ],
        ),
        PaddingGap.md(),

        // Hotel Name
        FabTextfield(
          formControl: formGroup.control('hotelName') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Hotel Name',
          hintText: 'Hotel Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Hotel Location
        FabTextfield(
          formControl: formGroup.control('hotelLocation') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Hotel Location',
          hintText: 'Hotel Location',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Check-In and Check-Out
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Check-In',
                formGroup.control('checkIn') as FormControl<DateTime>,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                'Check-Out',
                formGroup.control('checkOut') as FormControl<DateTime>,
              ),
            ),
          ],
        ),
        PaddingGap.md(),

        // Booking Ref
        FabTextfield(
          formControl: formGroup.control('bookingRef') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Booking Reference',
          hintText: 'Booking Reference',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),
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

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FabButton.primary(
        onPressed: () {
          $.navigator.push(const VisaDocumentRoute());
          // if (formGroup.valid) {
          //   // TODO: Submit all form data
          //   // You'll need to collect data from all 3 steps here
          //   print('Form submitted');
            
          //   // Show success dialog or navigate to success page
          //   showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //       title: const Text('Success'),
          //       content: const Text('Your visa application has been submitted successfully.'),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             // Navigate back to home or main page
          //           },
          //           child: const Text('OK'),
          //         ),
          //       ],
          //     ),
          //   );
          // } else {
          //   formGroup.markAllAsTouched();
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
