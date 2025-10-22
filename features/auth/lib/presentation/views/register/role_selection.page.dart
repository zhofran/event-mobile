import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({required this.onResult, super.key});

  final Function(bool didRegister) onResult;

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? _selectedRole = 'Attendee';

  final List<Map<String, dynamic>> roles = [
    {
      'icon': Icons.directions_walk,
      'title': 'Attendee',
      'subtitle': 'Attend events and explore new opportunities.',
      'value': 'Attendee',
    },
    {
      'icon': Icons.mic,
      'title': 'Speaker',
      'subtitle': 'Share insights as a speaker',
      'value': 'Speaker',
    },
    {
      'icon': Icons.handshake,
      'title': 'Sponsor',
      'subtitle': 'Grow your brand as a sponsor',
      'value': 'Sponsor',
    },
    {
      'icon': Icons.event,
      'title': 'Event Organizer',
      'subtitle': 'Host and manage your own events',
      'value': 'Event Organizer',
    },
    {
      'icon': Icons.work,
      'title': 'Vendor',
      'subtitle': 'Host and manage your own events',
      'value': 'Vendor',
    },
  ];

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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: roles.map((role) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildRoleTile(
                            icon: role['icon'],
                            title: role['title'],
                            subtitle: role['subtitle'],
                            value: role['value'],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _selectedRole == null ? null : () {
                  if (_selectedRole == 'Attendee') {
                    $.navigator.push(
                      AttendeeRegisterRoute(),
                    );
                  } else if (_selectedRole == 'Speaker') {
                    $.navigator.push(
                      SpeakerRegisterRoute(),
                    );
                  } else if (_selectedRole == 'Sponsor') {
                    $.navigator.push(
                      SponsorRegisterRoute(),
                    );
                  } else if (_selectedRole == 'Event Organizer') {
                    $.navigator.push(
                      EORegisterRoute(),
                    );
                  } else if (_selectedRole == 'Vendor') {
                    $.navigator.push(
                      VendorRegisterRoute(),
                    );
                  }
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: Text(
                  'Continue',
                  style: FabTypography.displaySemiBold16.copyWith(
                    color: FabColors.greyscale0,
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [ 
          FabButton.secondary(
            onPressed: () {
              $.navigator.replace(LoginRoute(onResult: widget.onResult));
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
              'Role Selection',
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
            'Choose Your Role',
            style: FabTypography.displayRegular22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'Tell us how you’ll use the Mining Event Platform. \n We’ll personalize your experience based on your role.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    bool isSelected = _selectedRole == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? FabColors.primary25 : FabColors.greyscale0,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? FabColors.primary : FabColors.greyscale300,
          ),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: FabColors.greyscale0,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: FabColors.greyscale200,
                ),
              ),
              child: Icon(
                icon,
                color: FabColors.textPrimary,
              ),
            ),
            title: Text(
              title,
              style: FabTypography.displayRegular16.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: FabTypography.displayRegular12
              // .copyWith(
              //   color: FabColors.greyscale400,
              // )
              ,
            ),
                ),
        ),)
    );
  }
}
