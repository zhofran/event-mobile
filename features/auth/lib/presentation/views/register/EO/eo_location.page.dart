import 'dart:developer';
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/country.model.dart';
import '../../../cubits/register.cubit.dart';

@RoutePage()
class EOLocationPage extends StatefulWidget {
  const EOLocationPage({required this.dataEO, super.key});

  final Map<String, dynamic> dataEO;

  @override
  State<EOLocationPage> createState() => _EOLocationPageState();
}

class _EOLocationPageState extends State<EOLocationPage> {
  final registerCubit = $.get<RegisterCubit>();
  
  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;

  Set<String> _selectedPreference = {};
  List<SelectOption<String>> _countriesOptions = [];
  List<SelectOption<String>> _citiesOptions = [];
  bool _isLoadingCountries = true;
  bool _isLoadingCities = false;
  bool _hasCitiesError = false;

  final List<SelectOption<String>> _preferencesOptions = [
    const SelectOption(value: 'Indoor', label: 'Indoor'),
    const SelectOption(value: 'Outdoor', label: 'Outdoor'),
    const SelectOption(value: 'Exhibition', label: 'Exhibition'),
    const SelectOption(value: 'Conference', label: 'Conference'),
    const SelectOption(value: 'Ballroom', label: 'Ballroom'),
    const SelectOption(value: 'Auditorium', label: 'Auditorium'),
  ];

  @override
  void initState() {
    super.initState();
    
    form = FormGroup({
      'EO_country': FormControl<String>(
        validators: [Validators.required],
      ),
      'EO_city': FormControl<String>(),
    });

    _countrySelectionFormControl = form.control('EO_country') as FormControl<String>;
    _citySelectionFormControl = form.control('EO_city') as FormControl<String>;

    // Listen to country changes
    _countrySelectionFormControl.valueChanges.listen((countryCode) {
      if (countryCode != null && countryCode.isNotEmpty) {
        _onCountryChanged(countryCode);
      }
    });

    _loadCountries();

    widget.dataEO.forEach((key, value) {
      log('$key : $value', name: 'DETAIL DATA');
    });

    // log('Location Data: ${widget.dataEO}', name: 'EO Location Page');
  }

  Future<void> _loadCountries() async {
    await registerCubit.getAllCountries();
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
    
    log('Country changed to: $countryCode, fetching cities...', name: 'EO Location');
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
      log('Countries loaded: ${_countriesOptions.length}', name: 'EO Location');
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
      log('Cities loaded: ${_citiesOptions.length}', name: 'EO Location');
    } else {
      // No cities available for this country
      setState(() {
        _citiesOptions = [];
        _isLoadingCities = false;
        _hasCitiesError = false;
      });
      log('No cities available for selected country', name: 'EO Location');
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
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
              _buildContinueButton(),
            ],
          ),
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
        const Text(
          'Venue Preferences',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Venue Preferences',
              primaryColor: FabColors.primary,
              options: _preferencesOptions, 
              initialSelected: _selectedPreference, 
              onConfirm: (selected) {
                setState(() {
                  _selectedPreference = selected;
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: FabColors.primary300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedPreference.isEmpty
                      ? Text(
                          'Select Preferences',
                          style: FabTypography.bodySmallMedium.copyWith(
                            color: FabColors.greyscale400,
                          ),
                        )
                      : _buildSelectedPreferencesChips(),
                ),
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
    final selectedLabels = _selectedPreference.map((value) {
      return _preferencesOptions
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
              final valueToRemove = _preferencesOptions
                  .firstWhere((option) => option.label == label)
                  .value;
              _selectedPreference.remove(valueToRemove);
            });
          },
          backgroundColor: FabColors.primary50,
          side: const BorderSide(color: FabColors.primary),
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCountry(),
        PaddingGap.md(),
        _buildCity(),
        PaddingGap.md(),
        _buildVenuePreferences(),
      ],
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
        onRetry: () => registerCubit.getAllCountries(),
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
          log('Country selected: ${selectedOption.label} (${selectedOption.value})', name: 'EO Location');
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
          log('City selected: ${selectedOption.label} (ID: ${selectedOption.value})', name: 'EO Location');
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
                UIcons.boldRounded.angle_small_down,
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
    if (!form.valid) {
      form.markAllAsTouched();
      _showSnackBar('Please select a country');
      return;
    }

    // Get selected country name from code
    final selectedCountryCode = _countrySelectionFormControl.value;
    final selectedCountry = registerCubit.countries.firstWhere(
      (c) => c.code == selectedCountryCode,
      orElse: () => CountryModel(country: '', code: selectedCountryCode ?? ''),
    );

    // log('Country Code: ${selectedCountryCode}', name: 'EO Location Page');
    // log('Country Name: ${selectedCountry.country}', name: 'EO Location Page');
    // log('City ID: ${_citySelectionFormControl.value}', name: 'EO Location Page');
    // log('Venue Preferences: ${_selectedPreference.toList()}', name: 'EO Location Page');

    // Save location data
    widget.dataEO['country_code'] = selectedCountryCode;
    widget.dataEO['country_name'] = selectedCountry.country;
    widget.dataEO['city_id'] = _citySelectionFormControl.value;
    widget.dataEO['venue_preferences'] = _selectedPreference.toList();

    log('Location Data: ${widget.dataEO}', name: 'EO Location Page');

    // Navigate to next page
    $.navigator.push(EORepresentativeRoute(dataEO: widget.dataEO));
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