import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EOLocationPage extends StatefulWidget {
  const EOLocationPage({super.key});

  @override
  State<EOLocationPage> createState() => _EOLocationPageState();
}

class _EOLocationPageState extends State<EOLocationPage> {
  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;

  Set<String> _selectedPreference = {};

  // Options as SelectOption<String> which the FabSelectBottomSheet expects
  final List<SelectOption<String>> _countriesOptions = [
    const SelectOption(value: 'Albania', label: 'Albania', icon: Text('🇦🇱')),
    const SelectOption(value: 'Argentina', label: 'Argentina', icon: Text('🇦🇷')),
    const SelectOption(value: 'Austria', label: 'Austria', icon: Text('🇦🇹')),
    const SelectOption(value: 'Australia', label: 'Australia', icon: Text('🇦🇺')),
    const SelectOption(value: 'Brazil', label: 'Brazil', icon: Text('🇧🇷')),
    const SelectOption(value: 'Belgium', label: 'Belgium', icon: Text('🇧🇪')),
    const SelectOption(value: 'Canada', label: 'Canada', icon: Text('🇨🇦')),
    const SelectOption(value: 'Denmark', label: 'Denmark', icon: Text('🇩🇰')),
    const SelectOption(value: 'Indonesia', label: 'Indonesia', icon: Text('🇮🇩')),
  ];

  final List<SelectOption<String>> _citiesOptions = [
    const SelectOption(value: 'Bali', label: 'Bali'),
    const SelectOption(value: 'Jakarta', label: 'Jakarta'),
    const SelectOption(value: 'Surabaya', label: 'Surabaya'),
    const SelectOption(value: 'Bandung', label: 'Bandung'),
    const SelectOption(value: 'Medan', label: 'Medan'),
  ];
  
  final List<SelectOption<String>> _preferencesOptions = [
    const SelectOption(value: 'indoor', label: 'Indoor'),
    const SelectOption(value: 'outdoor', label: 'Outdoor'),
    const SelectOption(value: 'exhibition', label: 'Exhibition'),
    const SelectOption(value: 'conference', label: 'Conference'),
  ];


  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'EO_country': FormControl<String>(value: null),
      'EO_city': FormControl<String>(value: null),
    });

    _countrySelectionFormControl = form.control('EO_country') as FormControl<String>;
    _citySelectionFormControl = form.control('EO_city') as FormControl<String>;
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),

                        PaddingGap.lg(),
                        
                        ReactiveForm(
                          formGroup: form,
                          child: _buildRegisterForm(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  $.navigator.push(EORepresentativeRoute());
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: const Text('Continue'),
              ),
            ),
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
        const Text(
          'Where do you organize your events?',
          style: FabTypography.displaySemiBold22,
        ),

        PaddingGap.sm(),

        Text(
          'This helps us recommend venues, connect with local partners, and analyze your reach.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildVenuePreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Venue Preferences',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Event Type',
              primaryColor: FabColors.primary,
              options: _preferencesOptions, 
              initialSelected: _selectedPreference, 
              onConfirm: (selected) {
                setState(() {
                  _selectedPreference = selected;
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: FabColors.primary300),
              ),
            ),
            child: _selectedPreference.isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Preferences', style: TextStyle(color: Colors.black54)),
                Icon(
                  UIcons.boldRounded.angle_small_down,
                  size: 20,
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildSelectedPreferencesChips()),
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

  Widget _buildSelectedPreferencesChips() {
    if (_selectedPreference.isEmpty) {
      return const Text(
        'Select preferred location',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 4,
      children: _selectedPreference.map((location) {
        return Chip(
          label: Text(
            location,
            style: FabTypography.displaySemiBold14.copyWith(
              color: FabColors.textPrimary
            ),
          ),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              _selectedPreference.remove(location);
            });
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

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Event Type
        _buildCountry(),

        PaddingGap.md(),

        // City
        _buildCity(),
        
        PaddingGap.md(),
        
        // Venue Preferences
        _buildVenuePreferences(),
      ],
    );
  }

  Widget _buildCountry() {
    return FabSelectBottomSheet<String>(
      formControl: _countrySelectionFormControl,
      labelText: 'Country',
      hintText: 'Select Country',
      searchHintText: 'Search Country',
      options: _countriesOptions,
      onChanged: (selectedOption) {
        // simply set the form control value to the selected option's value
        if (selectedOption != null) {
          _countrySelectionFormControl.value = selectedOption.value;
        }
      },
    );
  }

  Widget _buildCity() {
    return FabSelectBottomSheet<String>(
      formControl: _citySelectionFormControl,
      labelText: 'City (optional)',
      hintText: 'Select City',
      searchHintText: 'Search City',
      options: _citiesOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null) {
          _citySelectionFormControl.value = selectedOption.value;
        }
      },
    );
  }


}