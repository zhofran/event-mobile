import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SpeakerLocationPage extends StatefulWidget {
  const SpeakerLocationPage({super.key});

  @override
  State<SpeakerLocationPage> createState() => _SpeakerLocationPageState();
}

class _SpeakerLocationPageState extends State<SpeakerLocationPage> {
  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;
  
  Set<String> _selectedAvailability = {};
  Set<String> _selectedLocation = {};

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

  final List<SelectOption<String>> _avabilityOptions = [
    const SelectOption(value: 'Morning', label: 'Morning'),
    const SelectOption(value: 'Afternoon', label: 'Afternoon'),
    const SelectOption(value: 'Evening', label: 'Evening'),
    const SelectOption(value: 'Weekdays', label: 'Weekdays'),
    const SelectOption(value: 'Weekend', label: 'Weekend'),
  ];

  final List<SelectOption<String>> _locationOptions = [
    const SelectOption(value: 'local', label: 'Local(same City or Province)'),
    const SelectOption(value: 'national', label: 'National(same Country)'),
    const SelectOption(value: 'global', label: 'Global(International)'),
  ];


  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'EO_country': FormControl<String>(value: null),
      'EO_city': FormControl<String>(value: null),
      'EO_url': FormControl<String>(value: ''),
      'EO_socialMedia': FormControl<String>(value: ''),
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

                  _buildWelcomeText(),

                  PaddingGap.sm(),

                  _buildBasedForm(),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // For now, just navigate to a placeholder page
                  $.navigator.push(SpeakerRequirementRoute());
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
              'Register Speaker',
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

  Widget _buildWelcomeText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Where are you based?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'We use this to match you with relevant events and schedules in your area.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasedForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCountry(),
          
          PaddingGap.md(),
          
          _buildCity(),

          PaddingGap.md(),
          
          // Preferred Availability: show a read-only field that opens a multi-select dialog
          Text(
            'Prefered Availability',
            style: FabTypography.bodySmallMedium,
          ),
          const SizedBox(height: 8,),
          GestureDetector(
            onTap: () {
              FabMultiSelectBottomSheet.show<String>(
                context: context,
                title: 'Prefered Availability',
                primaryColor: FabColors.primary,
                options: _avabilityOptions, 
                initialSelected: _selectedAvailability, 
                onConfirm: (selected) {
                  setState(() {
                    _selectedAvailability = selected;
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
                  Expanded(child: _buildSelectedAvailabilityChips()),
                  Icon(
                    UIcons.boldRounded.angle_small_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          PaddingGap.md(),
          
          Text(
            'Preferred Location',
            style: FabTypography.bodySmallMedium,
          ),
          const SizedBox(height: 8,),
          GestureDetector(
            onTap: () {
              FabMultiSelectBottomSheet.show<String>(
                context: context,
                title: 'Preferred Location',
                primaryColor: FabColors.primary,
                options: _locationOptions, 
                initialSelected: _selectedLocation, 
                onConfirm: (selected) {
                  setState(() {
                    _selectedLocation = selected;
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
                  Expanded(child: _buildSelectedLocationChips()),
                  Icon(
                    UIcons.boldRounded.angle_small_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAvailabilityChips() {
    if (_selectedAvailability.isEmpty) {
      return const Text(
        'Select availability',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 4,
      children: _selectedAvailability.map((option) {
        return Chip(
          label: Text(
            option,
            style: FabTypography.displaySemiBold14.copyWith(
              color: FabColors.textPrimary
            ),
          ),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              _selectedAvailability.remove(option);
            });
          },
          backgroundColor: FabColors.background,
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }

  Widget _buildSelectedLocationChips() {
    if (_selectedLocation.isEmpty) {
      return const Text(
        'Select location',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 4,
      children: _selectedLocation.map((location) {
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
              _selectedLocation.remove(location);
            });
          },
          backgroundColor: FabColors.background,
          deleteIconColor: Colors.grey,
        );
      }).toList(),
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