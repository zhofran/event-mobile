import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../cubits/register.cubit.dart';

@RoutePage()
class SpeakerLocationPage extends StatefulWidget {
  const SpeakerLocationPage({required this.data, super.key});

  final Map<String, dynamic> data;

  @override
  State<SpeakerLocationPage> createState() => _SpeakerLocationPageState();
}

class _SpeakerLocationPageState extends State<SpeakerLocationPage> {
  final registerCubit = $.get<RegisterCubit>();

  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;

  Set<String> _selectedAvailability = {};
  Set<String> _selectedLocation = {};

  List<SelectOption<String>> _countriesOptions = [];
  List<SelectOption<String>> _citiesOptions = [];
  List<SelectOption<String>> _availabilityOptions = [];
  List<SelectOption<String>> _mobilityOptions = [];
  
  bool _isLoadingCountries = true;
  bool _isLoadingCities = false;
  bool _hasCitiesError = false;
  bool _isLoadingAvailability = true;
  bool _isLoadingMobility = true;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'EO_country': FormControl<String>(
        validators: [Validators.required],
      ),
      'EO_city': FormControl<String>(),
      'EO_url': FormControl<String>(value: ''),
      'EO_socialMedia': FormControl<String>(value: ''),
    });

    _countrySelectionFormControl =
        form.control('EO_country') as FormControl<String>;
    _citySelectionFormControl = form.control('EO_city') as FormControl<String>;

    _countrySelectionFormControl.valueChanges.listen((countryCode) {
      if (countryCode != null && countryCode.isNotEmpty) {
        _onCountryChanged(countryCode);
      }
    });

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadCountries(),
      _loadAvailability(),
      _loadMobility(),
    ]);
  }

  Future<void> _loadCountries() async {
    await registerCubit.getAllCountries();
  }

  Future<void> _loadAvailability() async {
    await registerCubit.getAllAvail();
  }

  Future<void> _loadMobility() async {
    await registerCubit.getAllMobile();
  }

  void _onCountryChanged(String countryCode) {
    // Clear previous city selection
    _citySelectionFormControl.value = null;

    // Fetch cities for selected country
    setState(() {
      _isLoadingCities = true;
      _hasCitiesError = false;
      _citiesOptions = [];
    });

    registerCubit.getAllCities(countrCode: countryCode);

    log('Country changed to: $countryCode, fetching cities...',
        name: 'Speaker Location',);
  }

  void _updateCountriesFromCubit() {
    if (registerCubit.countries.isNotEmpty) {
      setState(() {
        _countriesOptions = registerCubit.countries.map((countryModel) {
          return SelectOption<String>(
            value: countryModel.code,
            label: countryModel.country,
            icon: Text(FabFlags.getFlag(countryModel.code)),
          );
        }).toList();
        _isLoadingCountries = false;
      });
      log('Countries loaded: ${_countriesOptions.length}', name: 'Speaker Location');
    }
  }

  void _updateCitiesFromCubit() {
    if (registerCubit.cities.isNotEmpty) {
      setState(() {
        _citiesOptions = registerCubit.cities.map((city) {
          return SelectOption<String>(
            value: city.id.toString(),
            label: city.city,
          );
        }).toList();
        _isLoadingCities = false;
        _hasCitiesError = false;
      });
      log('Cities loaded: ${_citiesOptions.length}', name: 'Speaker Location');
    } else {
      // No cities available for this country
      setState(() {
        _citiesOptions = [];
        _isLoadingCities = false;
        _hasCitiesError = false;
      });
      log('No cities available for selected country', name: 'Speaker Location');
    }
  }

  void _updateAvailabilityFromCubit() {
    if (registerCubit.availability.isNotEmpty) {
      setState(() {
        _availabilityOptions = registerCubit.availability.map((avail) {
          return SelectOption<String>(
            value: avail.id.toString(),
            label: avail.name,
          );
        }).toList();
        _isLoadingAvailability = false;
      });
      log('Availability loaded: ${_availabilityOptions.length}', name: 'Speaker Location');
    }
  }

  void _updateMobilityFromCubit() {
    if (registerCubit.mobility.isNotEmpty) {
      setState(() {
        _mobilityOptions = registerCubit.mobility.map((mobile) {
          return SelectOption<String>(
            value: mobile.id.toString(),
            label: mobile.name,
          );
        }).toList();
        _isLoadingMobility = false;
      });
      log('Mobility loaded: ${_mobilityOptions.length}', name: 'Speaker Location');
    }
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
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: registerCubit,
        listener: (context, state) {
          state.whenOrNull(
            berhasil: () {
              _updateCountriesFromCubit();
              _updateCitiesFromCubit();
              _updateAvailabilityFromCubit();
              _updateMobilityFromCubit();
            },
            failed: (failure) {
              if (_isLoadingCountries) {
                setState(() {
                  _isLoadingCountries = false;
                });
                _showSnackBar('Failed to load countries: ${failure.message}');
              } else if (_isLoadingCities) {
                setState(() {
                  _isLoadingCities = false;
                  _hasCitiesError = true;
                });
                _showSnackBar('Failed to load cities: ${failure.message}');
              }
            },
          );
        },
        child: SafeArea(
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
                padding: const EdgeInsets.all(24),
                child: FabButton.primary(
                  onPressed: () {
                    final locations = {
                      'country': _countrySelectionFormControl.value,
                      'city_id': _citySelectionFormControl.value,
                      'preferred_availability': _selectedAvailability.toList(),
                      'preferred_location': _selectedLocation.toList()
                    };

                    widget.data['location'] = locations;

                    // For now, just navigate to a placeholder page
                    $.navigator.push(SpeakerRequirementRoute(data: widget.data));
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCountry(),

          PaddingGap.md(),

          _buildCity(),

          PaddingGap.md(),

          _buildAvailabilityField(),

          PaddingGap.md(),

          _buildMobilityField(),
        ],
      ),
    );
  }

  Widget _buildAvailabilityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Availability',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        if (_isLoadingAvailability) _buildLoadingContainer('Loading availability...') else _buildMultiSelectField(
                hintText: 'Select availability',
                selectedValues: _selectedAvailability,
                options: _availabilityOptions,
                onTap: () {
                  FabMultiSelectBottomSheet.show<String>(
                    context: context,
                    title: 'Preferred Availability',
                    primaryColor: FabColors.primary,
                    options: _availabilityOptions,
                    initialSelected: _selectedAvailability,
                    onConfirm: (selected) {
                      setState(() {
                        _selectedAvailability = selected;
                      });
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildMobilityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Location',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        if (_isLoadingMobility) _buildLoadingContainer('Loading location options...') else _buildMultiSelectField(
                hintText: 'Select location',
                selectedValues: _selectedLocation,
                options: _mobilityOptions,
                onTap: () {
                  FabMultiSelectBottomSheet.show<String>(
                    context: context,
                    title: 'Preferred Location',
                    primaryColor: FabColors.primary,
                    options: _mobilityOptions,
                    initialSelected: _selectedLocation,
                    onConfirm: (selected) {
                      setState(() {
                        _selectedLocation = selected;
                      });
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildLoadingContainer(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: FabColors.greyscale200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String hintText,
    required Set<String> selectedValues,
    required List<SelectOption<String>> options,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Expanded(
              child: selectedValues.isEmpty
                  ? Text(
                      hintText,
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: FabColors.greyscale400,
                      ),
                    )
                  : _buildSelectedChips(selectedValues, options),
            ),
            Icon(
              UIcons.boldRounded.angle_small_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChips(
    Set<String> selectedValues,
    List<SelectOption<String>> options,
  ) {
    final selectedLabels = selectedValues.map((value) {
      final option = options.firstWhere(
        (opt) => opt.value == value,
        orElse: () => SelectOption(value: value, label: value),
      );
      return option.label;
    }).toList();

    return Wrap(
      spacing: 4,
      children: selectedLabels.map((label) {
        return Chip(
          label: Text(
            label,
            style: FabTypography.displaySemiBold14.copyWith(
              color: FabColors.textPrimary,
            ),
          ),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() {
              final valueToRemove = options
                  .firstWhere((option) => option.label == label)
                  .value;
              selectedValues.remove(valueToRemove);
            });
          },
          backgroundColor: FabColors.background,
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }

  Widget _buildCountry() {
    if (_isLoadingCountries) {
      return _buildLoadingField('Country', 'Loading countries...');
    }

    if (_countriesOptions.isEmpty) {
      return _buildErrorField(
        'Country',
        'No countries available',
        onRetry: registerCubit.getAllCountries,
      );
    }

    return FabSelectBottomSheet<String>(
      formControl: _countrySelectionFormControl,
      labelText: 'Country',
      hintText: 'Select Country',
      searchHintText: 'Search Country',
      options: _countriesOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null) {
          _countrySelectionFormControl.value = selectedOption.value;
          log('Country selected: ${selectedOption.label} (${selectedOption.value})', name: 'Speaker Location');
        }
      },
    );
  }

  Widget _buildCity() {
    // Show info message if no country selected
    if (_countrySelectionFormControl.value == null || 
        _countrySelectionFormControl.value!.isEmpty) {
      return _buildInfoField(
        'City',
        'Please select a country first',
      );
    }

    // Show loading state
    if (_isLoadingCities) {
      return _buildLoadingField('City', 'Loading cities...');
    }

    // Show error state
    if (_hasCitiesError) {
      return _buildErrorField(
        'City',
        'Failed to load cities',
        onRetry: () {
          final countryCode = _countrySelectionFormControl.value;
          if (countryCode != null) {
            registerCubit.getAllCities(countrCode: countryCode);
          }
        },
      );
    }

    // Show empty state
    if (_citiesOptions.isEmpty) {
      return _buildInfoField(
        'City (optional)',
        'No cities available for selected country',
      );
    }

    // Show city selector
    return FabSelectBottomSheet<String>(
      formControl: _citySelectionFormControl,
      labelText: 'City',
      hintText: 'Select City',
      searchHintText: 'Search City',
      options: _citiesOptions,
      onChanged: (selectedOption) {
        if (selectedOption != null) {
          _citySelectionFormControl.value = selectedOption.value;
          log('City selected: ${selectedOption.label} (ID: ${selectedOption.value})', name: 'Speaker Location');
        }
      },
    );
  }

  Widget _buildLoadingField(String label, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: FabColors.greyscale200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                message,
                style: FabTypography.bodySmallMedium.copyWith(
                  color: FabColors.greyscale400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: FabColors.greyscale200),
            borderRadius: BorderRadius.circular(12),
            color: FabColors.greyscale50,
          ),
          child: Row(
            children: [
              Icon(
                UIcons.boldRounded.info,
                size: 20,
                color: FabColors.greyscale400,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.greyscale400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorField(String label, String message, {VoidCallback? onRetry}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: FabColors.error),
            borderRadius: BorderRadius.circular(12),
            color: FabColors.error.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Icon(
                UIcons.boldRounded.exclamation,
                size: 20,
                color: FabColors.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.error,
                  ),
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: 8),
                FabButton.secondary(
                  onPressed: onRetry,
                  size: FabButtonSize.small,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
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
