import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EODetailPage extends StatefulWidget {
  const EODetailPage({super.key});

  @override
  State<EODetailPage> createState() => _EODetailPageState();
}

class _EODetailPageState extends State<EODetailPage> {
  late FormGroup form;

  Set<String> _selectedEventType = {};
  String? _selectedEventSize;

  final List<SelectOption<String>> _eventTypeOptions = [
    const SelectOption(value: 'education', label: 'Education'),
    const SelectOption(value: 'finance', label: 'Finance'),
    const SelectOption(value: 'healthcare', label: 'Healthcare'),
    const SelectOption(value: 'hospitality', label: 'Hospitality'),
    const SelectOption(value: 'manufacturing', label: 'Manufacturing'),
    const SelectOption(value: 'retail', label: 'Retail'),
    const SelectOption(value: 'technology', label: 'Technology'),
    const SelectOption(value: 'transportation', label: 'Transportation'),
    const SelectOption(value: 'utilities', label: 'Utilities'),
  ];

  final List<String> _eventSize = [
    '<100',
    '100-500',
    '500-1000',
    '1000+',
    // Add more cities as needed
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'EO_url': FormControl<String>(validators: [Validators.required]),
      'EO_socialMedia': FormControl<String>(validators: [Validators.required]),
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

                  PaddingGap.sm(),

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
                onPressed: () {
                  $.navigator.push(
                    EOLocationRoute(),
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
              'Register Event Organizer',
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
            'A verified profile builds trust with speakers, sponsors, and attendees',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildEventSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Average Event Size',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Event Size',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400
            )
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
          initialValue: _selectedEventSize,
          items: _eventSize.map((size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventSize = value;
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
        
        // Event Type
        _buildEventType(),

        PaddingGap.md(),
        
        // Company Type
        _buildEventSize(),

        PaddingGap.md(),

        // Company Name Field
        FabTextfield(
          formControl: form.control('EO_url') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Website URL',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Company Bio Field
        FabTextfield(
          formControl: form.control('EO_socialMedia') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Social Media URL (optional)',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

  Widget _buildEventType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Type',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Event Type',
              primaryColor: FabColors.primary,
              options: _eventTypeOptions, 
              initialSelected: _selectedEventType, 
              onConfirm: (selected) {
                setState(() {
                  _selectedEventType = selected;
                });
              }
            );
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: FabColors.greyscale200),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSelectedEventType()),
                Icon(
                  UIcons.boldRounded.angle_small_down,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedEventType() {
    if (_selectedEventType.isEmpty) {
      return const Text('Select Event Type', style: TextStyle(color: Colors.black54));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _selectedEventType.map((c) {
        return Chip(
          label: Text(c),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() => _selectedEventType.remove(c));
          },
          backgroundColor: FabColors.primary50,
          side: BorderSide(
            color: FabColors.primary
          ),
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }


}