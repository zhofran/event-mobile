import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AttendeeTopicPage extends StatefulWidget {
  const AttendeeTopicPage({super.key});

  @override
  State<AttendeeTopicPage> createState() => _AttendeeTopicPageState();
}

class _AttendeeTopicPageState extends State<AttendeeTopicPage> {
  List<String> _topics = [
    'Sustainability',
    'Mining & Energy',
    'Technology',
    'Business',
    'Innovation',
    'Leadership',
    'Networking',
  ];

  Set<String> _selectedTopics = {};

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
                  PaddingGap.md(),

                  _buildWelcomeSection(),

                  PaddingGap.md(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildTopicChips(),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _selectedTopics.length < 3
                    ? null
                    : () {
                        // For now, just navigate to a placeholder page
                        $.navigator.push(AttendeeLocationRoute());
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

  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FabTextStyled(
            'What topics are you interested in?',
            style: FabTypography.displaySemiBold22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'Select a few areas that excite you. We\'ll use them to recommend relevant events and connections.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _topics.map((topic) {
        final isSelected = _selectedTopics.contains(topic);
        return ChoiceChip(
          label: Text(topic),
          selected: isSelected,
          showCheckmark: false,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTopics.add(topic);
              } else {
                _selectedTopics.remove(topic);
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
    );
  }
  
}