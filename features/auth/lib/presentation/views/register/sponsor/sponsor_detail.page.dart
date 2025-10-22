import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SponsorDetailPage extends StatefulWidget {
  const SponsorDetailPage({super.key});

  @override
  State<SponsorDetailPage> createState() => _SponsorDetailPageState();
}

class _SponsorDetailPageState extends State<SponsorDetailPage> {
  
  final List<SelectOption<String>> _typeOptions = [
    SelectOption(
      value: 'ui_ux_designer',
      label: 'UI UX Designer',
    ),
    SelectOption(
      value: 'ux_analyst',
      label: 'UX Analyst',
    ),
    SelectOption(
      value: 'product_designer',
      label: 'Product Designer',
    ),
    SelectOption(
      value: 'ui_ux_researcher',
      label: 'UI UX Researcher',
    ),
    SelectOption(
      value: 'ux_architect',
      label: 'UX Architect',
    ),
    SelectOption(
      value: 'senior_ui_ux_designer',
      label: 'Senior UI UX Designer',
    ),
    SelectOption(
      value: 'senior_ux_analyst',
      label: 'Senior UX Analyst',
    ),
  ];
  
  late FormGroup form;  
  late FormControl<String> _typeSelectionFormControl;

  List<String> _selectedTypes = [];
  String? _selectedSize;
  String? _selectedBudget;

  final List<String> _sizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '<200 employees',
    // Add more cities as needed
  ];
  
  final List<String> _budget = [
    '< IDR 50M>',
    '50M-200M',
    '250M-1B',
    '1B+',
    // Add more cities as needed
  ];
  
  void _initializeJobSelectionFormControl() {
    _typeSelectionFormControl = FormControl<String>();
  }
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'url': FormControl<String>(validators: [Validators.required]),
    });
    _initializeJobSelectionFormControl();
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
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildRegisterForm(),
                    ),
                  ),
                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.push(
                    SponsorOperateRoute(),
                  );
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
              'Register Sponsor',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Details',
          style: FabTypography.displaySemiBold22,
        ),

        PaddingGap.sm(),
        
        Text(
          'Join the Mining Event Platform, a single space for every event role.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // First Name Field
        FabTextfield(
          formControl: form.control('url') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Website URL',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Industry Type
        _buildIndustryType(),
        
        PaddingGap.md(),
        
        // Company Size
        _buildCompanySize(),

        PaddingGap.md(),

        // Marketing Budget
        _buildCompanyBudget()
      ],
    );
  }

  Widget _buildCompanySize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Size',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Company Size',
            style: FabTypography.bodyLargeMedium,
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
          initialValue: _selectedSize,
          items: _sizes.map((size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSize = value;
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
  
  Widget _buildCompanyBudget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual Marketing Budget Range',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Marketing Budget',
            style: FabTypography.bodyLargeMedium,
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
          initialValue: _selectedBudget,
          items: _budget.map((budget) {
            return DropdownMenuItem<String>(
              value: budget,
              child: Text(budget),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBudget = value;
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
  
  Widget _buildIndustryType() {
    return FabSelectBottomSheet<String>(
      formControl: _typeSelectionFormControl,
      labelText: 'Industry Type',
      hintText: 'Select Industry Type',
      searchHintText: 'Search Industry Type',
      options: _typeOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null && !_selectedTypes.contains(selectedOption.label)) {
          setState(() {
            _selectedTypes.add(selectedOption.label);
          });
          // Clear the selection after adding
          _typeSelectionFormControl.value = null;
        }
      },
    );
  }


}