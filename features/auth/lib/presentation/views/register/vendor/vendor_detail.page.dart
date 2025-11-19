import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../cubits/vendor_registration.cubit.dart';


@RoutePage()
class VendorDetailPage extends StatefulWidget {
  const VendorDetailPage({super.key});

  @override
  State<VendorDetailPage> createState() => _VendorDetailPageState();
}

class _VendorDetailPageState extends State<VendorDetailPage> {
  late FormGroup form;  
  
  String? _selectedPaymentTerm;
  final vendorRegistrationCubit = $.get<VendorRegistrationCubit>();

  final List<String> _paymentTerms = [
    '50/50',
    'After Completion',
    'Custom Agreement',
    // Add more cities as needed
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'foundedYear': FormControl<String>(validators: [Validators.required]),
      'websiteURL': FormControl<String>(validators: [Validators.required]),
      'sosmedURL': FormControl<String>(validators: [Validators.required]),
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
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildWelcomeSection(),

                  PaddingGap.md(),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                    child: ReactiveForm(
                      formGroup: form, 
                      child: _buildRegisterForm()
                    ),
                  )
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _onContinuePressed,
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
              'Register Vendor',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Details',
            style: FabTypography.displaySemiBold22,
          ),
      
          PaddingGap.sm(),
      
          Text(
            'Provide more information to help organizers learn about your company.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTerm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Payment Term',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Payment',
            style: FabTypography.bodyLargeMedium.copyWith(
              color: FabColors.greyscale400
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
          ),
          initialValue: _selectedPaymentTerm,
          items: _paymentTerms.map((size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPaymentTerm = value;
            });
          },
          icon: Icon(
            UIcons.boldRounded.angle_small_down,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Company Name Field
        FabTextfield(
          formControl: form.control('foundedYear') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Founded Year',
          hintText: 'e.g., 2020',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),

        // Company Bio Field
        FabTextfield(
          formControl: form.control('websiteURL') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Website URL',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
                
        PaddingGap.md(),
        
        // Company Bio Field
        FabTextfield(
          formControl: form.control('sosmedURL') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Social Media URL',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
                
        PaddingGap.md(),
        
        // Company Type
        _buildPaymentTerm(),

      ],
    );
  }

  void _onContinuePressed() {
    if (form.valid && _selectedPaymentTerm != null) {
      // Save Step 2 data to cubit
      vendorRegistrationCubit.updateStep2(
        foundedYear: form.control('foundedYear').value as String?,
        websiteUrl: form.control('websiteURL').value as String?,
        socialMediaUrl: form.control('sosmedURL').value as String?,
        paymentTerm: _selectedPaymentTerm,
      );

      // Navigate to next step
      $.navigator.push(VendorLocationRoute());
    } else {
      // Mark all as touched to show validation errors
      form.markAllAsTouched();
    }
  }

}