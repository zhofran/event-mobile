import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VisaTravelDetailPage extends StatefulWidget {
  const VisaTravelDetailPage({super.key});

  @override
  State<VisaTravelDetailPage> createState() => _VisaTravelDetailPageState();
}

class _VisaTravelDetailPageState extends State<VisaTravelDetailPage> {
  late FormGroup formGroup;

  final List<String> purposeOfVisit = [
    'Speaker',
    'Attendee',
    'Business',
    'Tourism',
    'Conference',
  ];

  @override
  void initState() {
    super.initState();
    
    formGroup = FormGroup({
      'eventName': FormControl<String>(
        // validators: [Validators.required],
      ),
      'eventLocation': FormControl<String>(
        // validators: [Validators.required],
      ),
      'eventDate': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'arrivalDate': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'departureDate': FormControl<DateTime>(
        // validators: [Validators.required],
      ),
      'purposeOfVisit': FormControl<String>(
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
      'Step 2 - Travel Details',
      style: FabTypography.displaySemiBold18,
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Name
        FabTextfield(
          formControl: formGroup.control('eventName') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Event Name',
          hintText: 'Event Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Event Location
        FabTextfield(
          formControl: formGroup.control('eventLocation') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Event Location',
          hintText: 'Event Location',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),

        // Event Date
        _buildDateField(
          'Event Date',
          formGroup.control('eventDate') as FormControl<DateTime>,
        ),
        PaddingGap.md(),

        // Arrival and Departure Dates
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Arrival Date',
                formGroup.control('arrivalDate') as FormControl<DateTime>,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                'Departure Date',
                formGroup.control('departureDate') as FormControl<DateTime>,
              ),
            ),
          ],
        ),
        PaddingGap.md(),

        // Purpose of Visit
        FabTextStyled(
          'Purpose of Visit *',
          style: FabTypography.displayMedium14.copyWith(
            color: FabColors.greyscale900,
          ),
        ),
        PaddingGap.xs(),
        ReactiveDropdownField<String>(
          formControl: formGroup.control('purposeOfVisit') as FormControl<String>,
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
          items: purposeOfVisit
              .map((purpose) => DropdownMenuItem(
                    value: purpose,
                    child: Text(purpose),
                  ))
              .toList(),
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
            $.navigator.push(const VisaAccomodationRoute());
          // if (formGroup.valid) {
          //   // TODO: Save data to a shared state/provider
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
