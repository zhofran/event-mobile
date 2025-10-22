import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SponsorGoalPage extends StatefulWidget {
  const SponsorGoalPage({super.key});

  @override
  State<SponsorGoalPage> createState() => _SponsorGoalPageState();
}

class _SponsorGoalPageState extends State<SponsorGoalPage> {
  List<String> _goals = [
    'Brand Awereness',
    'Lead Generation',
    'Product Launch',
    'Market Research',
    'Networking & Partnerships',
    'CSR',
    'Recruitment',
    'Sustainability Visibility',
  ];

  Set<String> _selectedGoals = {};

  bool _showAddField = false;
  final TextEditingController _addController = TextEditingController();

  void _addNewGoal() {
    final newExpertise = _addController.text.trim();
    if (newExpertise.isNotEmpty) {
      setState(() {
        if (!_goals.contains(newExpertise)) {
          _goals.add(newExpertise);
        }
        _selectedGoals.add(newExpertise);
        _addController.clear();
        _showAddField = false;
      });
    }
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

                  _buildExpertiseChips(),
                ]
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _selectedGoals.isEmpty
                    ? null
                    : () {
                        // For now, just navigate to a placeholder page
                        $.navigator.push(SponsorProductRoute());
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

  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'What are your sponsorship goals?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'Select what you want to achieve, we’ll tailor your sponsorship opportunities accordingly.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertiseChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          ..._goals.map((expertise) {
            final isSelected = _selectedGoals.contains(expertise);
            return ChoiceChip(
              showCheckmark: false,
              label: Text(expertise),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedGoals.add(expertise);
                  } else {
                    _selectedGoals.remove(expertise);
                  }
                });
              },
              selectedColor: FabColors.primary25,
              backgroundColor: FabColors.background,
              labelStyle: FabTypography.displaySemiBold14.copyWith(
                color: FabColors.textPrimary
              ),
              side: BorderSide(
                color: isSelected ? FabColors.primary : FabColors.greyscale300,
                width: 1.5,
              ),
            );
          }).toList(),
          if (_showAddField)
            SizedBox(
              width: 120,
              height: 40,
              child: TextField(
                controller: _addController,
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: FabColors.greyscale300,
                      width: 1.5,
                    ),
                  ),
                  hintText: 'Add',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check, color: FabColors.primary300),
                    onPressed: _addNewGoal,
                  ),
                ),
                onSubmitted: (_) => _addNewGoal(),
              ),
            )
          else
            ActionChip(
              label: Text('Add'),
              avatar: Icon(Icons.add, color: FabColors.primary300),
              onPressed: () {
                setState(() {
                  _showAddField = true;
                });
              },
            )
        ],
      ),
    );
  }
}