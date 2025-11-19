import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../../cubits/location.cubit.dart';
import '../../../cubits/vendor_registration.cubit.dart';

@RoutePage()
class VendorLocationPage extends StatefulWidget {
  const VendorLocationPage({super.key});

  @override
  State<VendorLocationPage> createState() => _VendorLocationPageState();
}

class _VendorLocationPageState extends State<VendorLocationPage> {
  late FormGroup form;
  late FormControl<String> _countrySelectionFormControl;
  late FormControl<String> _citySelectionFormControl;

  Set<String> _selectedMarketFocus = {};
  List<SelectOption<String>> _countriesOptions = [];
  List<SelectOption<String>> _citiesOptions = [];
  final locationCubit = $.get<LocationCubit>();
  final vendorRegistrationCubit = $.get<VendorRegistrationCubit>();
  String? _selectedCountryIso2;
  String? _selectedCityId;


  
  final List<SelectOption<String>> _marketFocusOptions = [
    const SelectOption(value: 'local', label: 'Local(City/Province)'),
    const SelectOption(value: 'national', label: 'National'),
    const SelectOption(value: 'regional', label: 'Regional(South East Asia)'),
    const SelectOption(value: 'global', label: 'Global(International)'),
  ];




  void _loadCountries() {
    locationCubit.getCountries();
  }

  void _loadCities(String countryIso2, {String? cityQuery}) {
    _selectedCountryIso2 = countryIso2;
    locationCubit.getCities(countryIso2: countryIso2, cityQuery: cityQuery);
  }

  void _onCountryChanged(String countryName) {
    // Find the selected country to get its ISO2 code
    final selectedCountry = locationCubit.countries.firstWhere(
      (country) => country.country == countryName,
      orElse: () => locationCubit.countries.first,
    );
    
    // Clear city selection when country changes
    _citySelectionFormControl.value = null;
    _citiesOptions = [];
    _selectedCityId = null;
    
    // Load cities for selected country
    _loadCities(selectedCountry.iso2);
  }

  void _onCityChanged(String cityName) {
    // Find the selected city to get its ID
    final selectedCity = locationCubit.cities.firstWhere(
      (city) => city.city == cityName,
      orElse: () => locationCubit.cities.first,
    );
    
    _selectedCityId = selectedCity.id.toString();
  }

  void _onSubmitPressed() {
    // Validate location form
    if (form.valid && _selectedCountryIso2 != null) {
      // Save Step 3 data to cubit
      vendorRegistrationCubit.updateStep3(
        country: _countrySelectionFormControl.value,
        countryIso2: _selectedCountryIso2,
        city: _citySelectionFormControl.value,
        cityId: _selectedCityId,
        marketFocus: _selectedMarketFocus.toList(),
      );

      // Submit the complete registration
      _submitRegistration();
    } else {
      // Mark all as touched to show validation errors
      form.markAllAsTouched();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a country to continue'),
          backgroundColor: FabColors.error,
        ),
      );
    }
  }

  Future<void> _submitRegistration() async {
    // Add default values for required API fields
    vendorRegistrationCubit.updateAdditionalData(
      eventTypeIds: [1], // Default event type
      averageEventSize: 'Medium',
      venueTypes: ['Indoor'],
      repName: vendorRegistrationCubit.data.companyName ?? 'Representative',
      repPosition: 'Manager',
      repEmail: 'contact@company.com',
    );

    await vendorRegistrationCubit.submitRegistration();
  }

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'vendor_country': FormControl<String>(value: null),
      'vendor_city': FormControl<String>(value: null),
    });

    _countrySelectionFormControl = form.control('vendor_country') as FormControl<String>;
    _citySelectionFormControl = form.control('vendor_city') as FormControl<String>;
    
    // Load countries when page initializes
    _loadCountries();
    
    // Listen to vendor registration state
    _listenToVendorRegistrationState();
  }

  void _listenToVendorRegistrationState() {
    vendorRegistrationCubit.stream.listen((state) {
      if (state is VendorRegistrationStateSuccess) {
        // Navigate to success page or dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendor registration completed successfully!'),
            backgroundColor: FabColors.success,
          ),
        );
        
        // Navigate to next page (permissions or dashboard)
        $.navigator.push(
          PermissionNotificationRoute(onResult: (bool _) {})
        );
      } else if (state is VendorRegistrationStateFailed) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${state.failure.message}'),
            backgroundColor: FabColors.error,
          ),
        );
      }
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),

                        PaddingGap.lg(),
                        
                        StreamBuilder<LocationState>(
                          stream: locationCubit.stream,
                          initialData: locationCubit.state,
                          builder: (context, snapshot) {
                            final state = snapshot.data ?? locationCubit.state;
                            
                            if (state is LocationStateFailed) {
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: FabColors.error50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: FabColors.error200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: FabColors.error300,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Failed to load countries',
                                                style: FabTypography.bodySmallMedium.copyWith(
                                                  color: FabColors.error300,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              GestureDetector(
                                                onTap: _loadCountries,
                                                child: Text(
                                                  'Tap to retry',
                                                  style: FabTypography.bodySmallMedium.copyWith(
                                                    color: FabColors.primary,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PaddingGap.lg(),
                                ],
                              );
                            }
                            
                            return ReactiveForm(
                              formGroup: form,
                              child: _buildRegisterForm(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: StreamBuilder<VendorRegistrationState>(
                stream: vendorRegistrationCubit.stream,
                initialData: vendorRegistrationCubit.state,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? vendorRegistrationCubit.state;
                  final isLoading = state is VendorRegistrationStateLoading;

                  return FabButton.primary(
                    onPressed: isLoading ? null : _onSubmitPressed,
                    size: FabButtonSize.large,
                    width: double.infinity,
                    child: isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Complete Registration'),
                  );
                },
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
          'Where do you operate?',
          style: FabTypography.displaySemiBold22,
        ),

        PaddingGap.sm(),

        Text(
          'Let’s make it easy for organizers to find you nearby.',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildMarketFocus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Market Focus',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Primary Market Focus',
              primaryColor: FabColors.primary,
              options: _marketFocusOptions, 
              initialSelected: _selectedMarketFocus, 
              onConfirm: (selected) {
                setState(() {
                  _selectedMarketFocus = selected;
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
            child: _selectedMarketFocus.isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Market Focus', style: TextStyle(color: Colors.black54)),
                Icon(
                  UIcons.boldRounded.angle_small_down,
                  size: 20,
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildSelectedMarketFocusChips()),
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

  Widget _buildSelectedMarketFocusChips() {
    if (_selectedMarketFocus.isEmpty) {
      return const Text(
        'Select Market Focus',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 4,
      children: _selectedMarketFocus.map((location) {
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
              _selectedMarketFocus.remove(location);
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
        
        // Market Focus
        _buildMarketFocus(),
      ],
    );
  }

  Widget _buildCountry() {
    return StreamBuilder<LocationState>(
      stream: locationCubit.stream,
      initialData: locationCubit.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? locationCubit.state;
        
        // Update options when countries are loaded
        if (state is LocationStateCountriesLoaded) {
          _countriesOptions = state.countries.map((country) {
            // Generate flag emoji from country code (simple implementation)
            final flag = _getFlagEmoji(country.iso2);
            return SelectOption<String>(
              value: country.country,
              label: country.country,
              icon: Text(flag),
            );
          }).toList();
        }

        return FabSelectBottomSheet<String>(
          formControl: _countrySelectionFormControl,
          labelText: 'Country',
          hintText: state is LocationStateLoading ? 'Loading countries...' : 'Select Country',
          searchHintText: 'Search Country',
          options: _countriesOptions,
          onChanged: (selectedOption) {
            if (selectedOption != null) {
              _countrySelectionFormControl.value = selectedOption.value;
              _onCountryChanged(selectedOption.value);
            }
          },
        );
      },
    );
  }

  String _getFlagEmoji(String countryCode) {
    // Simple flag emoji mapping for common countries
    const flagMap = {
      'ID': '🇮🇩',
      'US': '🇺🇸',
      'GB': '🇬🇧',
      'AU': '🇦🇺',
      'CA': '🇨🇦',
      'DE': '🇩🇪',
      'FR': '🇫🇷',
      'JP': '🇯🇵',
      'KR': '🇰🇷',
      'CN': '🇨🇳',
      'SG': '🇸🇬',
      'MY': '🇲🇾',
      'TH': '🇹🇭',
      'VN': '🇻🇳',
      'PH': '🇵🇭',
      'IN': '🇮🇳',
      'BR': '🇧🇷',
      'AR': '🇦🇷',
      'MX': '🇲🇽',
      'ES': '🇪🇸',
      'IT': '🇮🇹',
      'NL': '🇳🇱',
      'BE': '🇧🇪',
      'CH': '🇨🇭',
      'AT': '🇦🇹',
      'SE': '🇸🇪',
      'NO': '🇳🇴',
      'DK': '🇩🇰',
      'FI': '🇫🇮',
      'RU': '🇷🇺',
      'TR': '🇹🇷',
      'SA': '🇸🇦',
      'AE': '🇦🇪',
      'EG': '🇪🇬',
      'ZA': '🇿🇦',
      'NG': '🇳🇬',
      'KE': '🇰🇪',
      'NZ': '🇳🇿',
    };
    
    return flagMap[countryCode.toUpperCase()] ?? '🏳️';
  }

  Widget _buildCity() {
    return StreamBuilder<LocationState>(
      stream: locationCubit.stream,
      initialData: locationCubit.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? locationCubit.state;
        
        // Update cities options when cities are loaded
        if (state is LocationStateCitiesLoaded) {
          _citiesOptions = state.cities.map((city) {
            return SelectOption<String>(
              value: city.city,
              label: '${city.city}, ${city.adminName}',
            );
          }).toList();
        }

        // Determine if city selection should be enabled
        final isEnabled = _selectedCountryIso2 != null;
        final isLoading = state is LocationStateLoading && _selectedCountryIso2 != null;
        
        // Show message if no country selected
        if (!isEnabled) {
          _citiesOptions = [];
        }

        return FabSelectBottomSheet<String>(
          formControl: _citySelectionFormControl,
          labelText: 'City (optional)',
          hintText: isLoading 
              ? 'Loading cities...' 
              : isEnabled 
                  ? 'Select City' 
                  : 'Select country first',
          searchHintText: 'Search City',
          emptyText: isEnabled ? 'No cities found' : 'Please select a country first',
          enabled: isEnabled,
          options: _citiesOptions,
          onChanged: (selectedOption) {
            if (selectedOption != null) {
              _citySelectionFormControl.value = selectedOption.value;
              _onCityChanged(selectedOption.value);
            }
          },
        );
      },
    );
  }


}