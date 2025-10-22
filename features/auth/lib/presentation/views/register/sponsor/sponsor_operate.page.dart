import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SponsorOperatePage extends StatefulWidget {
  const SponsorOperatePage({super.key});

  @override
  State<SponsorOperatePage> createState() => _SponsorOperatePageState();
}

class _SponsorOperatePageState extends State<SponsorOperatePage> {
  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;
  
  Set<String> _selectedFocus = {};

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
  
  final List<SelectOption<String>> _focusOptions = [
    const SelectOption(value: 'Local', label: 'Local(City/Province)'),
    const SelectOption(value: 'National', label: 'National'),
    const SelectOption(value: 'Regional', label: 'Regional(South East Asia)'),
    const SelectOption(value: 'Global', label: 'Global'),
  ];

  void _showAddMarketFocusBottomSheet() {
    String searchQuery = '';
    Set<String> tempSelected = Set.from(_selectedFocus);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<SelectOption<String>> filteredLocations = _focusOptions
                .where((opt) => opt.label.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 400, // Adjust height as needed
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Market Focus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    PaddingGap.sm(),
                    
                    TextField(
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        // hintText: 'Q.',
                        prefixIcon: const Icon(Icons.search, color: FabColors.greyscale500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    
                    PaddingGap.sm(),

                    if (tempSelected.isNotEmpty)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: tempSelected.map((location) {
                          return Chip(
                            label: Text(location),
                            onDeleted: () {
                              setModalState(() {
                                tempSelected.remove(location);
                              });
                              setState(() {}); // Update main state
                            },
                            deleteIcon: const Icon(Icons.close, size: 18),
                            backgroundColor: Colors.orange.shade100,
                          );
                        }).toList(),
                      ),
                    
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredLocations.length,
                        itemBuilder: (context, index) {
                          final option = filteredLocations[index];
                          final isSelected = tempSelected.contains(option.value);
                          return CheckboxListTile(
                            title: Text(option.label),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setModalState(() {
                                if (value == true) {
                                  tempSelected.add(option.value);
                                } else {
                                  tempSelected.remove(option.value);
                                }
                              });
                              setState(() {}); // Update main state
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: Colors.orange,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFocus = tempSelected;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'sponsor_country': FormControl<String>(value: null),
      'sponsor_city': FormControl<String>(value: null),
      'sponsor_focus': FormControl<String>(value: null),
    });

    _countrySelectionFormControl = form.control('sponsor_country') as FormControl<String>;
    _citySelectionFormControl = form.control('sponsor_city') as FormControl<String>;
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

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildCompanyOperate(),
                  ),

                ]
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // For now, just navigate to a placeholder page
                  $.navigator.push(SponsorGoalRoute());
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: const Text('Continue'),
              ),
            ),
          ]
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
              'Register Sponsor',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
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
            'Where do you operate?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'We’ll use this to match you with relevant events and audiences in your target markets.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyOperate() {
    return Column(
      children: [
        _buildCountry(),

        PaddingGap.md(),
        
        _buildCity(),

        PaddingGap.md(),

        _buildFocus()
      ],
    );
  }

  Widget _buildSelectedLocationChips() {
    if (_selectedFocus.isEmpty) {
      return const Text(
        'Select preferred location',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 4,
      children: _selectedFocus.map((location) {
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
              _selectedFocus.remove(location);
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

  Widget _buildFocus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Market Focus',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.textPrimary
          )
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: _showAddMarketFocusBottomSheet,
          child: InputDecorator(
            decoration: const InputDecoration(
              hintText: 'Select Market Focus',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedFocus.isEmpty
                  ? const Text('Select Market Focus', style: TextStyle(color: Colors.black54))
                  : _buildSelectedLocationChips(),
                ),
                IconTheme(
                  data: const IconThemeData(
                    color: FabColors.textPrimary,
                    size: 20,
                  ),
                  child: Icon(
                    UIcons.boldRounded.angle_small_down,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}