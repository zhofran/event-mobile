import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AttendeeLocationPage extends StatefulWidget {
  const AttendeeLocationPage({super.key});

  @override
  State<AttendeeLocationPage> createState() => _AttendeeLocationPageState();
}

class _AttendeeLocationPageState extends State<AttendeeLocationPage> {
  List<String> _allLocations = [
    'Surabaya',
    'DKI Jakarta',
    'Bandung',
    'Medan',
    'Magetan',
    'Jakarta',
    'Bali',
    'Yogyakarta',
    // Add more locations as needed
  ];

  Set<String> _selectedLocations = {};

  void _showAddLocationBottomSheet() {
    String searchQuery = '';
    Set<String> tempSelected = Set.from(_selectedLocations);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<String> filteredLocations = _allLocations
                .where((location) => location.toLowerCase().contains(searchQuery.toLowerCase()))
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
                      'Add Location',
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
                          final location = filteredLocations[index];
                          final isSelected = tempSelected.contains(location);
                          return CheckboxListTile(
                            title: Text(location),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setModalState(() {
                                if (value == true) {
                                  tempSelected.add(location);
                                } else {
                                  tempSelected.remove(location);
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
                            _selectedLocations = tempSelected;
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
                  _buildWelcomeText(),
                          
                  _buildAddLocationButton()
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // For now, just navigate to a placeholder page
                  $.navigator.push(PermissionNotificationRoute(onResult: (bool _) {}));
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
              'Register Attendee',
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
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Where do you usually attend events?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'Choose your preferred region and language for better recommendations.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLocationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedLocations.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _selectedLocations.map((location) {
                return Chip(
                  label: Text('$location, ID'),
                  onDeleted: () {
                    setState(() {
                      _selectedLocations.remove(location);
                    });
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                  backgroundColor: Colors.orange.shade100,
                );
              }).toList(),
            ),
          OutlinedButton(
            onPressed: _showAddLocationBottomSheet,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: FabColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
                PaddingGap.sm(),
                Text(
                  'Add Location',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
