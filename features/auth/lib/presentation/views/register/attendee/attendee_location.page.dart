import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/location.model.dart';
import '../../../cubits/register.cubit.dart';

@RoutePage()
class AttendeeLocationPage extends StatefulWidget {
  AttendeeLocationPage({required this.dataAttendee, super.key});

  Map<String, dynamic> dataAttendee;

  @override
  State<AttendeeLocationPage> createState() => _AttendeeLocationPageState();
}

class _AttendeeLocationPageState extends State<AttendeeLocationPage> {
  final registerCubit = $.get<RegisterCubit>();
  // Convert raw data ke LocationModel
  late final List<LocationModel> _allLocations = [
    {
      'id': 2,
      'city': 'Jakarta',
      'city_ascii': 'Jakarta',
      'latitude': -6.175,
      'longitude': 106.8275,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jakarta',
      'capital': 'primary',
      'population': 33756000,
      'location_id': '1360771077',
    },
    {
      'id': 79,
      'city': 'Surabaya',
      'city_ascii': 'Surabaya',
      'latitude': -7.2458,
      'longitude': 112.7378,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Timur',
      'capital': 'admin',
      'population': 6556000,
      'location_id': '1360484663',
    },
    {
      'id': 208,
      'city': 'Medan',
      'city_ascii': 'Medan',
      'latitude': 3.5894,
      'longitude': 98.6739,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Sumatera Utara',
      'capital': 'admin',
      'population': 3632000,
      'location_id': '1360543171',
    },
    {
      'id': 287,
      'city': 'Malang',
      'city_ascii': 'Malang',
      'latitude': -7.98,
      'longitude': 112.62,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Timur',
      'capital': '',
      'population': 2795209,
      'location_id': '1360141408',
    },
    {
      'id': 350,
      'city': 'Bekasi',
      'city_ascii': 'Bekasi',
      'latitude': -6.2333,
      'longitude': 107,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Barat',
      'capital': '',
      'population': 2381053,
      'location_id': '1360673840',
    },
    {
      'id': 358,
      'city': 'Depok',
      'city_ascii': 'Depok',
      'latitude': -6.394,
      'longitude': 106.8225,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Barat',
      'capital': '',
      'population': 2330333,
      'location_id': '1360962899',
    },
    {
      'id': 373,
      'city': 'Tangerang',
      'city_ascii': 'Tangerang',
      'latitude': -6.1703,
      'longitude': 106.6403,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Barat',
      'capital': '',
      'population': 2237006,
      'location_id': '1360002844',
    },
    {
      'id': 478,
      'city': 'Semarang',
      'city_ascii': 'Semarang',
      'latitude': -6.99,
      'longitude': 110.4225,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Tengah',
      'capital': 'admin',
      'population': 1621384,
      'location_id': '1360745537',
    },
    {
      'id': 503,
      'city': 'Palembang',
      'city_ascii': 'Palembang',
      'latitude': -2.9861,
      'longitude': 104.7556,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Sumatera Selatan',
      'capital': 'admin',
      'population': 1535952,
      'location_id': '1360902897',
    },
    {
      'id': 542,
      'city': 'Sangereng',
      'city_ascii': 'Sangereng',
      'latitude': -6.2889,
      'longitude': 106.7181,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Jawa Barat',
      'capital': '',
      'population': 1404785,
      'location_id': '1360029147',
    },
    {
      'id': 558,
      'city': 'Makassar',
      'city_ascii': 'Makassar',
      'latitude': -5.1331,
      'longitude': 119.4136,
      'country': 'Indonesia',
      'iso2': 'ID',
      'iso3': 'IDN',
      'admin_name': 'Sulawesi Selatan',
      'capital': 'admin',
      'population': 1338663,
      'location_id': '1360051337',
    },
  ].map(LocationModel.fromJson).toList();

  // Track selected location IDs
  Set<int> _selectedLocationIds = {};

  // Helper to get selected LocationModel objects
  List<LocationModel> get _selectedLocations {
    return _allLocations
        .where((loc) => _selectedLocationIds.contains(loc.id))
        .toList();
  }

  void _showAddLocationBottomSheet() {
    var searchQuery = '';
    var tempSelected = Set<int>.from(_selectedLocationIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredLocations = _allLocations
                .where((location) =>
                    location.city
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    location.adminName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FabTextStyled(
                              'Select Locations',
                              style: FabTypography.displaySemiBold18,
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),

                        PaddingGap.md(),

                        // Search Field
                        TextField(
                          onChanged: (value) {
                            setModalState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search city or province...',
                            hintStyle: FabTypography.displayRegular14.copyWith(
                              color: FabColors.greyscale400,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: FabColors.greyscale500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: FabColors.greyscale300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: FabColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),

                        PaddingGap.md(),

                        // Selected Count
                        if (tempSelected.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FabTextStyled(
                              '${tempSelected.length} location${tempSelected.length > 1 ? 's' : ''} selected',
                              style: FabTypography.displayRegular14.copyWith(
                                color: FabColors.primary,
                              ),
                            ),
                          ),

                        // Location List
                        Expanded(
                          child: filteredLocations.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: FabColors.greyscale300,
                                      ),
                                      PaddingGap.md(),
                                      FabTextStyled(
                                        'No locations found',
                                        style: FabTypography.displayRegular14
                                            .copyWith(
                                          color: FabColors.greyscale400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: filteredLocations.length,
                                  itemBuilder: (context, index) {
                                    final location = filteredLocations[index];
                                    final isSelected =
                                        tempSelected.contains(location.id);

                                    return CheckboxListTile(
                                      title: Text(
                                        location.city,
                                        style: FabTypography.displaySemiBold14,
                                      ),
                                      subtitle: Text(
                                        location.adminName,
                                        style: FabTypography.displayRegular12
                                            .copyWith(
                                          color: FabColors.greyscale500,
                                        ),
                                      ),
                                      value: isSelected,
                                      onChanged: (value) {
                                        setModalState(() {
                                          if (value == true) {
                                            tempSelected.add(location.id);
                                          } else {
                                            tempSelected.remove(location.id);
                                          }
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      activeColor: FabColors.primary,
                                      checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        PaddingGap.md(),

                        // Continue Button
                        FabButton.primary(
                          onPressed: tempSelected.isEmpty
                              ? null
                              : () {
                                  setState(() {
                                    _selectedLocationIds = tempSelected;
                                  });
                                  Navigator.pop(context);
                                },
                          size: FabButtonSize.large,
                          width: double.infinity,
                          child: Text(
                            tempSelected.isEmpty
                                ? 'Select at least one location'
                                : 'Apply (${tempSelected.length})',
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    
    // Listen to state changes
    registerCubit.stream.listen((state) {
      state.whenOrNull(
        failed: (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        succeeded: (user) {
          if (mounted) {
            $.navigator.replace(const HomeRoute());
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                children: [
                  PaddingGap.md(),
                  _buildWelcomeText(),
                  PaddingGap.md(),
                  _buildLocationSection(),
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
              'Register Attendee',
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

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Where do you usually attend events?',
            style: FabTypography.displaySemiBold22,
          ),
          PaddingGap.sm(),
          FabTextStyled(
            'Select your preferred locations to get personalized event recommendations near you.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Locations
          if (_selectedLocations.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedLocations.map((location) {
                return Chip(
                  label: Text(
                    location.displayName,
                    style: FabTypography.displaySemiBold14.copyWith(
                      color: FabColors.textPrimary,
                    ),
                  ),
                  onDeleted: () {
                    setState(() {
                      _selectedLocationIds.remove(location.id);
                    });
                  },
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 18,
                    color: FabColors.primaryDark,
                  ),
                  backgroundColor: FabColors.primary25,
                  side: const BorderSide(
                    color: FabColors.primary,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            PaddingGap.md(),
          ],

          // Add Location Button
          FabButton.secondary(
            onPressed: _showAddLocationBottomSheet,
            iconWidget: const Icon(
              Icons.add,
              color: FabColors.textPrimary,
              size: 20,
            ),
            icon: Icons.add,
            child: Text(
              _selectedLocations.isEmpty
                  ? 'Add Location'
                  : 'Add More Locations',
              style: FabTypography.displaySemiBold14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return StreamBuilder<RegisterState>(
      stream: registerCubit.stream,
      initialData: registerCubit.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? registerCubit.state;
        
        final isLoading = state.whenOrNull(
          loading: () => true,
        ) ?? false;

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedLocationIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FabTextStyled(
                    '${_selectedLocationIds.length} location${_selectedLocationIds.length > 1 ? 's' : ''} selected',
                    style: FabTypography.displayRegular14.copyWith(
                      color: FabColors.primary,
                    ),
                  ),
                ),
              FabButton.primary(
                isLoading: isLoading,
                onPressed: _selectedLocationIds.isEmpty || isLoading
                ? null
                : () async {
                    // Save to dataAttendee
                    widget.dataAttendee['city_ids'] = _selectedLocationIds.toList();

                    log('Log Data Attendee: ${widget.dataAttendee}', name: 'Log Attendee Location');

                    // Validasi data sebelum dikirim
                    final avatar = widget.dataAttendee['avatar'];
                    final topics = widget.dataAttendee['topic_ids'];
                    final locations = widget.dataAttendee['city_ids'];

                    // if (avatar == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Avatar is required'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    //   return;
                    // }

                    await registerCubit.registerAttendee(
                      avatar: avatar,
                      firstname: widget.dataAttendee['firstName'],
                      lastname: widget.dataAttendee['lastName'],
                      bio: widget.dataAttendee['bio'],
                      topics: topics,
                      locations: locations,
                    );
                  },
                size: FabButtonSize.large,
                width: double.infinity,
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      },
    );
  }
}
