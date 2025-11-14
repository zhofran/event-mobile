import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddEvent1Page extends StatefulWidget {
  AddEvent1Page({required this.budget, super.key});

  final Map<String, dynamic> budget;

  @override
  State<AddEvent1Page> createState() => _AddEvent1PageState();
}

class _AddEvent1PageState extends State<AddEvent1Page> {
  late FormGroup form;
  
  int currentStep = 2;
  int totalSteps = 8;
  
  String? _selectedEventType;
  String? _selectedEventFormat;

  Set<String> _selectedEventCategory = {};

  final List<String> _eventType = [
    'Conference',
    'Exhibition',
    'Workshop',
    'Webinar',
    // Add more cities as needed
  ];
  
  final List<String> _eventFormat = [
    'Online',
    'Offline',
    // Add more cities as needed
  ];

  final List<SelectOption<String>> _eventCategoryOptions = [
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

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'eventName': FormControl<String>(validators: [Validators.required],),
      'description': FormControl<String>(),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedStepProgressIndicator(
                      currentStep: currentStep, 
                      totalSteps: totalSteps
                    ),
                  ),

                  PaddingGap.xl(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  PaddingGap.md(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildAddEventForm(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.push(
                    AddEvent2Route(format: _selectedEventFormat ?? '', budget: widget.budget),
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
        ),
      )
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
              'Create Event',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Event Details',
          style: FabTypography.displayBold22,
        ),

        PaddingGap.xs(),

        FabTextStyled(
          'you can edit this anytime before publishing.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
          // textAlign: TextAlign.center,
        ),
      ]
    );
  }

  Widget _buildAddEventForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // First Name Field
        FabTextfield(
          formControl: form.control('eventName') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Event Name',
          hintText: 'Event Name',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),

        _buildEventType(),
        
        PaddingGap.md(),

        _buildEventCategory(),
        
        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('description') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Description',
          hintText: 'Write a short summary about your event',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),

        PaddingGap.md(),

        _buildEventFormat(),

        PaddingGap.md(),
        
        const Text('Upload Product Photo'),
        PaddingGap.sm(),
        
        Padding(
          padding: const EdgeInsets.only(right: 265),
          child: _buildPhotoProduct(),
        ),

        PaddingGap.sm(),
        Text(
          'Upload 1920x1005 images (JPG or PNG)', 
          style: FabTypography.bodySmallLight.copyWith(
            color: FabColors.greyscale400
          )
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
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Event Type',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
          ),
          initialValue: _selectedEventType,
          items: _eventType.map((event) {
            return DropdownMenuItem<String>(
              value: event,
              child: Text(event),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventType = value;
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

  Widget _buildEventFormat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Format',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Event Format',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
          ),
          initialValue: _selectedEventFormat,
          items: _eventFormat.map((event) {
            return DropdownMenuItem<String>(
              value: event,
              child: Text(event),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventFormat = value;
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

  Widget _buildEventCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Category',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet(
              title: 'Event Category', 
              options: _eventCategoryOptions, 
              initialSelected: _selectedEventCategory, 
              onConfirm: (selected) {
                setState(() {
                  _selectedEventCategory = selected;
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
                Expanded(child: _buildSelectedEventCategoryChips()),
                Icon(
                  UIcons.boldRounded.angle_small_down,
                  size: 20,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSelectedEventCategoryChips() {
    if (_selectedEventCategory.isEmpty) {
      return const Text('Select Event Category', style: TextStyle(color: Colors.black54));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _selectedEventCategory.map((c) {
        return Chip(
          label: Text(c),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() => _selectedEventCategory.remove(c));
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

  Widget _buildPhotoProduct() {
    return FabPhoto(
      size: 90,
      shape: BoxShape.rectangle,
      backgroundColor: FabColors.background,
      iconColor: FabColors.primary200,
      onImagePicked: (File? image) {
        print('Image picked: ${image?.path}');
      },
    );
  }


}