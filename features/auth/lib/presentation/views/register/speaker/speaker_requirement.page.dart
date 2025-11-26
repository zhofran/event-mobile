import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SpeakerRequirementPage extends StatefulWidget {
  const SpeakerRequirementPage({required this.data, super.key});

  final Map<String, dynamic> data;

  @override
  State<SpeakerRequirementPage> createState() => _SpeakerRequirementPageState();
}

class _SpeakerRequirementPageState extends State<SpeakerRequirementPage> {
  // Honorarium single-select
  String? _selectedHonorarium;
  Set<String> _selectedTravel = {};

  // Special requirements
  final TextEditingController _specialReqController = TextEditingController();

  final List<SelectOption<String>> _travelOptions = [
    const SelectOption(value: 'flight', label: 'Need Flight'),
    const SelectOption(value: 'hotel', label: 'Need Hotel'),
    const SelectOption(value: 'own', label: 'Own Arrangement'),
  ];

  @override
  void dispose() {
    _specialReqController.dispose();
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaddingGap.sm(),

                        // Honorarium Preference
                        const Text('Honorarium Preference'),

                        const SizedBox(height: 8),
                        
                        DropdownButtonFormField<String>(
                          hint: Text(
                            'Select Preference',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400
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
                          initialValue: _selectedHonorarium,

                          items: const [
                            DropdownMenuItem(value: 'Fixed', child: Text('Fixed')),
                            DropdownMenuItem(value: 'Negotiable', child: Text('Negotiable')),
                            DropdownMenuItem(value: 'Voluntary', child: Text('Voluntary')),
                          ],
                          onChanged: (val) => setState(() => _selectedHonorarium = val),
                          icon: Icon(
                            UIcons.boldRounded.angle_small_down,
                            size: 20,
                          ),
                        ),

                        PaddingGap.md(),

                        // Travel Arrangement (multi-select)
                        _buildTravel(),

                        PaddingGap.md(),

                        const Text('Special Requirements'),
                        
                        const SizedBox(height: 8),

                        TextField(
                          controller: _specialReqController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'e.g., Ballroom venue only',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: FabColors.greyscale200),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // Proceed to location page
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

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'Speaking Requirements',
            style: FabTypography.displaySemiBold22,
          ),

          PaddingGap.xs(),
          
          FabTextStyled(
            'Share your preferences to make event arrangements smoother',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Arrangement',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Travel Arrangement',
              primaryColor: FabColors.primary,
              options: _travelOptions, 
              initialSelected: _selectedTravel, 
              onConfirm: (selected) {
                setState(() {
                  _selectedTravel = selected;
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
                Expanded(child: _buildSelectedTravelChips()),
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

  Widget _buildSelectedTravelChips() {
    if (_selectedTravel.isEmpty) {
      return const Text(
        'Select Arrangement',
        style: TextStyle(color: Colors.black54),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _selectedTravel.map((option) {
        return Chip(
          label: Text(
            option,
            style: FabTypography.displaySemiBold14.copyWith(
              color: FabColors.textPrimary
            ),
          ),
          onDeleted: () {
            setState(() {
              _selectedTravel.remove(option);
            });
          },
          deleteIcon: const Icon(Icons.close, size: 18),
          backgroundColor: FabColors.background,
        );
      }).toList(),
    );
  }

}