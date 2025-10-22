import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SponsorCampaignPage extends StatefulWidget {
  const SponsorCampaignPage({super.key});

  @override
  State<SponsorCampaignPage> createState() => _SponsorCampaignPageState();
}

class _SponsorCampaignPageState extends State<SponsorCampaignPage> {
  late FormGroup form;
  // late FormControl<String> _sponsorTypeSelectionFormControl;

  Set<String> _selectedSponsorType = {};
  Set<String> _selectedKPI = {};

  String? _selectedDuration;

  final List<SelectOption<String>> _sponsorTypeOptions = [
    const SelectOption(value: 'booth', label: 'Booth / Exhibition'),
    const SelectOption(value: 'speaking', label: 'Speaking Slot'),
    const SelectOption(value: 'ads', label: 'Digital Ads'),
    const SelectOption(value: 'co-branded', label: 'Co-branded Activities'),
    const SelectOption(value: 'merchandise', label: 'Merchandise / Swag'),
  ];
  
  final List<SelectOption<String>> _KPIOptions = [
    const SelectOption(value: 'leads', label: 'Leads Generated'),
    const SelectOption(value: 'impressions', label: 'Impressions'),
    const SelectOption(value: 'traffic', label: 'Booth Traffic'),
    const SelectOption(value: 'engagement', label: 'Engagement'),
    const SelectOption(value: 'sales', label: 'Sales Conversions'),
  ];

  final List<String> _duration = [
    '1-3 months',
    '3-6 months',
    '6+ months',
    // Add more cities as needed
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
                children: [
                  _buildWelcomeText(),

                  _buildFormCampaign(),
                ],
              )
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // For now, just navigate to a placeholder page
                  $.navigator.push(SponsorVerificationRoute());
                },
                size: FabButtonSize.large,
                width: double.infinity,
                child: const Text('Continue'),
              ),
            ),
          ],
        )
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
              'Register',
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
            'Define Your Campaign Preferences',
            style: FabTypography.displayRegular22,
          ),
          
          PaddingGap.sm(),

          FabTextStyled(
            'We’ll optimize your campaigns and report performance metrics automatically.',
            style: FabTypography.displayRegular14.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCampaign() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildSponsorType(),

          PaddingGap.sm(),

          _buildCampaignDuration(),

          PaddingGap.sm(),

          _buildKPI()
        ],
      ),
    );
  }

  Widget _buildCampaignDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Campaign Duration',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Duration',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
          ),
          initialValue: _selectedDuration,
          items: _duration.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDuration = value;
            });
          },
          icon: Icon(
            UIcons.boldRounded.angle_small_down,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSponsorType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prefered Sponsorship Type',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Sponsorship Type',
              primaryColor: FabColors.primary,
              options: _sponsorTypeOptions, 
              initialSelected: _selectedSponsorType, 
              onConfirm: (selected) {
                setState(() {
                  _selectedSponsorType = selected;
                });
              }
            );
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSelectedSponsorType()),
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

  Widget _buildKPI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KPI Focus',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'KPI Focus',
              primaryColor: FabColors.primary,
              options: _KPIOptions, 
              initialSelected: _selectedKPI, 
              onConfirm: (selected) {
                setState(() {
                  _selectedKPI = selected;
                });
              }
            );
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSelectedKPI()),
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

  Widget _buildSelectedSponsorType() {
    if (_selectedSponsorType.isEmpty) {
      return const Text('Select Sponsorship Type', style: TextStyle(color: Colors.black54));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _selectedSponsorType.map((c) {
        return Chip(
          label: Text(c),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() => _selectedSponsorType.remove(c));
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

  Widget _buildSelectedKPI() {
    if (_selectedKPI.isEmpty) {
      return const Text('Select KPI Focus', style: TextStyle(color: Colors.black54));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _selectedKPI.map((c) {
        return Chip(
          label: Text(c),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() => _selectedKPI.remove(c));
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

}