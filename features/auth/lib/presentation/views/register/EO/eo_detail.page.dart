import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EODetailPage extends StatefulWidget {
  const EODetailPage({required this.dataEO, super.key});

  final Map<String, dynamic> dataEO;

  @override
  State<EODetailPage> createState() => _EODetailPageState();
}

class _EODetailPageState extends State<EODetailPage> {
  late FormGroup form;

  Set<String> _selectedEventType = {};
  String? _selectedEventSize;

  final List<SelectOption<String>> _eventTypeOptions = [
    const SelectOption(value: '1', label: 'Education'),
    const SelectOption(value: '2', label: 'Finance'),
    const SelectOption(value: '3', label: 'Healthcare'),
    const SelectOption(value: '4', label: 'Hospitality'),
    const SelectOption(value: '5', label: 'Manufacturing'),
    const SelectOption(value: '6', label: 'Retail'),
    const SelectOption(value: '7', label: 'Technology'),
    const SelectOption(value: '8', label: 'Transportation'),
    const SelectOption(value: '9', label: 'Utilities'),
  ];

  final List<String> _eventSize = [
    '<100',
    '100-500',
    '500-1000',
    '1000+',
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'EO_url': FormControl<String>(),
      'EO_socialMedia': FormControl<String>(),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildRegisterForm(),
                    ),
                  ),
                ],
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
            onPressed: () {},
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
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Event Size',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400,
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
          value: _selectedEventSize,
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
        _buildEventType(),
        PaddingGap.md(),
        _buildEventSize(),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('EO_url') as FormControl<String>,
          keyboardType: TextInputType.url,
          labelText: 'Website URL',
          hintText: 'e.g., https://apple.com/',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: form.control('EO_socialMedia') as FormControl<String>,
          keyboardType: TextInputType.url,
          labelText: 'Social Media URL (optional)',
          hintText: 'e.g., https://instagram.com/username',
          textInputAction: TextInputAction.done,
          size: FabTextfieldSize.large,
        ),
      ],
    );
  }

  Widget _buildEventType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Type',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
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
              },
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
      return Text(
        'Select Event Type',
        style: FabTypography.bodySmallMedium.copyWith(
          color: FabColors.greyscale400,
        ),
      );
    }

    final selectedLabels = _selectedEventType.map((value) {
      return _eventTypeOptions
          .firstWhere((option) => option.value == value)
          .label;
    }).toList();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: selectedLabels.map((label) {
        return Chip(
          label: Text(label),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              final valueToRemove = _eventTypeOptions
                  .firstWhere((option) => option.label == label)
                  .value;
              _selectedEventType.remove(valueToRemove);
            });
          },
          backgroundColor: FabColors.primary50,
          side: const BorderSide(color: FabColors.primary),
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: FabButton.primary(
        onPressed: _handleContinue,
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

  void _handleContinue() {
    if (_selectedEventType.isEmpty) {
      _showSnackBar('Please select at least one event type');
      return;
    }

    if (_selectedEventSize == null) {
      _showSnackBar('Please select event size');
      return;
    }

    if (!form.valid) {
      form.markAllAsTouched();
      _showSnackBar('Please fill in all required fields');
      return;
    }

    widget.dataEO['event_type'] = _selectedEventType.toList();
    widget.dataEO['event_size'] = _selectedEventSize;
    widget.dataEO['website_url'] = form.control('EO_url').value;
    widget.dataEO['social_media'] = form.control('EO_socialMedia').value;

    log('Result Data EO: ${widget.dataEO}', name: 'Log from EO Detail Page');

    // Uncomment when ready to navigate
    $.navigator.push(EOLocationRoute(dataEO: widget.dataEO));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}