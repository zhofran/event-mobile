// ignore_for_file: max_lines_for_function, max_lines_for_file
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/models/job_listing.model.dart';

@RoutePage()
class JobListingDetailsPage extends StatefulWidget {
  const JobListingDetailsPage({
    required this.product,
    this.selectedItemIndex = 0,
    this.onSelectedItemChanged,
    super.key,
  });

  final JobListingModel product;
  final int selectedItemIndex;
  final ValueChanged<int>? onSelectedItemChanged;

  @override
  State<JobListingDetailsPage> createState() => _JobListingDetailsPageState();
}

class _JobListingDetailsPageState extends State<JobListingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        $.dialog.showCupertinoDialog(
          builder: (_) => CupertinoAlertDialog(
            content: const Text('Back navigation disabled!'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: $.navigator.pop,
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  $.navigator.pop();
                  AutoRouter.of(context).popUntilRoot();
                },
                child: const Text('Force back'),
              ),
            ],
          ),
        );
      },
      child: FabScaffold(
        appBarSettings: FabAppBarSettings(
          title: Text(
            'Job Detail',
            style: FabTypography.heading3Bold.copyWith(
              color: FabColors.greyscale900,
            ),
            textAlign: TextAlign.left,
          ),
          largeTitle: FabAppBarLargeTitleSettings(
            enabled: false,
            text: 'Job Details',
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all($.paddings.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.images.logos.ceriaCorp.image(
                  width: 80,
                  height: 80,
                  package: 'design',
                ),
                // Job Title
                Text(
                  "Mining Operation",
                  style: FabTypography.heading4Bold.copyWith(
                    color: FabColors.greyscale900,
                  ),
                ),
                PaddingGap.xs(),

                // Company Info
                Row(
                  children: [
                    Text(
                      'CeriaCorp',
                      style: FabTypography.bodyLargeRegular.copyWith(
                        color: FabColors.greyscale400,
                      ),
                    ),
                    PaddingGap.xxs(),
                    Assets.images.icons.bussines.verifiedBadgeFill.svg(
                      width: 20,
                      height: 20,
                      package: 'design',
                      colorFilter: ColorFilter.mode(
                        FabColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                PaddingGap.xxs(),

                // Location and Time
                Text(
                  'Jakarta, Indonesia • 2 days ago',
                  style: FabTypography.bodyLargeRegular.copyWith(
                    color: FabColors.greyscale400,
                  ),
                ),
                PaddingGap.lg(),

                // General Information Section
                Text(
                  "General Information",
                  style: FabTypography.subtitleBold.copyWith(
                    color: FabColors.greyscale900,
                  ),
                ),
                PaddingGap.md(),

                // General Info Grid
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Experience',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          PaddingGap.xs(),
                          Text(
                            '2-4 Years',
                            style: FabTypography.bodyLargeMedium.copyWith(
                              color: FabColors.greyscale700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seniority Level',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          PaddingGap.xs(),
                          Text(
                            'Senior Level',
                            style: FabTypography.bodyLargeMedium.copyWith(
                              color: FabColors.greyscale700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                PaddingGap.md(),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employment',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          PaddingGap.xs(),
                          Text(
                            'Full Time',
                            style: FabTypography.bodyLargeMedium.copyWith(
                              color: FabColors.greyscale700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salary',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale400,
                            ),
                          ),
                          PaddingGap.xs(),
                          Text(
                            '\$350-400',
                            style: FabTypography.bodyLargeMedium.copyWith(
                              color: FabColors.greyscale700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                PaddingGap.xl(),

                // Job Description Section
                Text(
                  "Job Description",
                  style: FabTypography.subtitleBold.copyWith(
                    color: FabColors.greyscale700,
                  ),
                ),
                PaddingGap.md(),

                Text(
                  "Collaborate with product management and engineering to define and implement innovative solutions for the product direction, visuals and experience. Execute all visual design stages from concept to final hand-off to engineering.\n\nConceptualize original ideas that bring simplicity and user friendliness to complex design roadblocks. Create wireframes, storyboards, user flows, process flows and site maps to effectively communicate interaction and design ideas.\n\nPresent and defend designs and key milestone deliverables to peers and executive level stakeholders. Conduct user research and evaluate user feedback.",
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.greyscale400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                PaddingGap.xl(),

                // Responsibilities Section
                Text(
                  "Reponsibilities",
                  style: FabTypography.subtitleBold.copyWith(
                    color: FabColors.greyscale700,
                  ),
                ),
                PaddingGap.md(),

                // Responsibility Items
                _buildResponsibilityItem(
                  "Identify problems based on the product vision / requirements and come up with delightful design solutions & deliverables.",
                ),
                PaddingGap.sm(),

                _buildResponsibilityItem(
                  "Conduct design process best practices across projects such as gathering insights, validating problems & solutions, delivering multiple fidelity levels of design, and ensure the final design is implemented properly on production.",
                ),
                PaddingGap.sm(),

                _buildResponsibilityItem(
                  "Collaborate with Interaction Designers (Design System team) to ensure the implementation of proper design components and patterns and/or improving existing design libraries.",
                ),
                PaddingGap.xl(),

                // Placement Section
                Text(
                  "Placement",
                  style: FabTypography.subtitleBold.copyWith(
                    color: FabColors.greyscale700,
                  ),
                ),
                PaddingGap.md(),

                Text(
                  "Job Location",
                  style: FabTypography.bodySmallMedium.copyWith(
                    color: FabColors.greyscale400,
                  ),
                ),
                PaddingGap.xs(),

                Text(
                  "Jakarta Pusat",
                  style: FabTypography.bodyLargeSemiBold.copyWith(
                    color: FabColors.greyscale700,
                  ),
                ),
                PaddingGap.md(),

                // Company Info Card
                Container(
                  padding: EdgeInsets.all($.paddings.md),
                  decoration: BoxDecoration(
                    color: FabColors.greyscale0,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: FabColors.greyscale100,
                      width: 0.78,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Header
                      Text(
                        "About the Company",
                        style: FabTypography.displaySemiBold14.copyWith(
                          color: FabColors.greyscale700,
                        ),
                      ),
                      PaddingGap.md(),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FabColors.greyscale100,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Assets.images.logos.ceriaCorp.image(
                                width: 28,
                                height: 28,
                                package: 'design',
                              ),
                            ),
                          ),
                          PaddingGap.md(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Ceria Corp.",
                                      style: FabTypography.displaySemiBold16
                                          .copyWith(
                                        color: FabColors.greyscale700,
                                      ),
                                    ),
                                    PaddingGap.sm(),
                                    Assets
                                        .images.icons.bussines.verifiedBadgeFill
                                        .svg(
                                      width: 20,
                                      height: 20,
                                      package: 'design',
                                      colorFilter: ColorFilter.mode(
                                        FabColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      PaddingGap.md(),

                      // Company Description
                      Text(
                        "PT Ceria Nugraha Indotama is a leading nickel mining company committed to producing high-grade nickel ore to support the global stainless steel industry.\nWe focus on sustainable practices, safety, and commu...",
                        style: FabTypography.displayRegular14.copyWith(
                          color: FabColors.greyscale400,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      PaddingGap.lg(),

                      // Company Details
                      _buildCompanyDetailItem(
                        icon: Icons.language,
                        label: "Website",
                        value: "www.ptceria.com",
                      ),
                      PaddingGap.md(),

                      _buildCompanyDetailItem(
                        icon: Icons.business,
                        label: "Industry",
                        value: "Mining & Smelter",
                      ),
                      PaddingGap.md(),

                      _buildCompanyDetailItem(
                        icon: Icons.people,
                        label: "Company Size",
                        value: "500 - 1000 Employees",
                      ),
                      PaddingGap.md(),

                      _buildCompanyDetailItem(
                        icon: Icons.location_on,
                        label: "Location",
                        value: "Jakarta, Indonesia",
                      ),
                    ],
                  ),
                ),
                PaddingGap.xl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibilityItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: FabColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        PaddingGap.sm(),
        Expanded(
          child: Text(
            text,
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: FabColors.primary,
        ),
        PaddingGap.sm(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$label : $value",
                style: FabTypography.displayRegular14.copyWith(
                  color: FabColors.greyscale400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
