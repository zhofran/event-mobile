import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../domain/forms/add_event_7.form.dart';
import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page7.cubit.dart';

@RoutePage()
class AddEvent7Page extends StatefulWidget {
  const AddEvent7Page({super.key, @queryParam this.fromReview = false});

  final bool fromReview;

  @override
  State<AddEvent7Page> createState() => _AddEvent7PageState();
}

class _AddEvent7PageState extends State<AddEvent7Page> {
  late BudgetPlannerCubit budgetPlannerCubit;
  late EventPage7Cubit eventPage7Cubit;
  int currentStep = 8;
  int totalSteps = 10;

  // Local state for editing sponsorship forms
  final Map<String, AddEvent7Form> editingModels = {};
  final Set<String> editingIds = {};

  final List<SelectOption<String>> _sponsorshipTypeOptions = [
    const SelectOption(value: 'Monetary', label: 'Monetary'),
    const SelectOption(value: 'Product', label: 'Product'),
    const SelectOption(value: 'Media', label: 'Media'),
    const SelectOption(value: 'Venue', label: 'Venue'),
    const SelectOption(value: 'Co-Branding', label: 'Co-Branding'),
    const SelectOption(value: 'Services', label: 'Services'),
  ];

  @override
  void initState() {
    super.initState();

    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    eventPage7Cubit = $.get<EventPage7Cubit>();

    // Initialize cubit with sponsorship goal
    eventPage7Cubit.initialize(
      sponsorshipGoal: budgetPlannerCubit.state.sponsorshipIncome.toDouble(),
    );

    // Load saved sponsorships
    _loadSavedSponsorships();
  }

  Future<void> _loadSavedSponsorships() async {
    await eventPage7Cubit.loadSponsorshipsLocally();
  }

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================

  /// =======================================================
  /// ============== CRUD Logic Sponsorship =================
  /// =======================================================
  void addSponsorship() {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      editingModels[tempId] = AddEvent7Form.empty();
      editingIds.add(tempId);
    });
  }

  void removeSponsorship(String id) {
    eventPage7Cubit.removeSponsorship(id);
    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });
  }

  void saveSponsorship(String id, AddEvent7Form model) {
    // Check if this is a new sponsorship or an update
    final existingSponsorship =
        eventPage7Cubit.state.sponsorships.where((s) => s.id == id).firstOrNull;

    if (existingSponsorship != null) {
      // Update existing
      eventPage7Cubit.updateSponsorship(
        id: id,
        title: model.title,
        type: model.type,
        requestedProduct: model.requestedProduct,
        productAmount: model.productAmount,
        description: model.description,
      );
    } else {
      // Add new
      eventPage7Cubit.addSponsorship(
        title: model.title,
        type: model.type,
        requestedProduct: model.requestedProduct,
        productAmount: model.productAmount,
        description: model.description,
      );
    }

    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });

    log('Sponsorship saved: ${model.title}', name: 'add_event_7');
  }

  void editSponsorship(String id) {
    final sponsorship =
        eventPage7Cubit.state.sponsorships.firstWhere((s) => s.id == id);

    setState(() {
      editingModels[id] = AddEvent7Form(
        title: sponsorship.title,
        type: sponsorship.type,
        requestedProduct: sponsorship.requestedProduct,
        productAmount: sponsorship.productAmount,
        description: sponsorship.description,
      );
      editingIds.add(id);
    });
  }

  // Validasi income dan navigasi ke halaman berikutnya
  void handleContinue() {
    // Check if there are unsaved forms
    if (editingIds.isNotEmpty) {
      FabSnackbar.error(
        context: context,
        content: 'Please save or delete all sponsorships before continuing',
      );
      return;
    }

    if (eventPage7Cubit.state.isIncomeBelowTarget) {
      // Tampilkan dialog jika income belum mencapai target
      _showIncomeBelowTargetDialog(eventPage7Cubit.state.shortfallAmount);
    } else {
      // Lanjut ke halaman berikutnya
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() async {
    await eventPage7Cubit.saveSponsorshipsLocally();

    FabSnackbar.success(
      context: context,
      content: 'Sponsorships saved successfully!',
    );

    if (widget.fromReview) {
      context.router.pop(true);
    } else {
      await $.navigator.push(InviteSponsorsRoute());
    }
  }

  // Dialog untuk income below target
  void _showIncomeBelowTargetDialog(double shortfall) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sponsors Income Below Target',
                  style: FabTypography.displaySemiBold18,
                  textAlign: TextAlign.center,
                ),
                PaddingGap.md(),
                Text(
                  "Sponsorship income hasn't met your target by ${FabFunction.formatRupiah(currency: shortfall)}. Reach out to more partners or update your offer packages to boost revenue.",
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale500,
                  ),
                  textAlign: TextAlign.center,
                ),
                PaddingGap.lg(),
                FabButton.primary(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // User bisa menambah sponsorship atau edit
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Adjust Slots',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.greyscale0,
                    ),
                  ),
                ),
                PaddingGap.sm(),
                FabButton.secondary(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToNextPage();
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Continue Anyway',
                    style: FabTypography.displaySemiBold16.copyWith(
                      color: FabColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// =======================================================
  /// ================== UI Builder =========================
  /// =======================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<EventPage7Cubit, EventPage7State>(
        bloc: eventPage7Cubit,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: FabColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  const FabPageHeader(title: 'Create Event'),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AnimatedStepProgressIndicator(
                            currentStep: currentStep,
                            totalSteps: totalSteps,
                          ),
                        ),

                        PaddingGap.xl(),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildWelcomeSection(),
                        ),

                        PaddingGap.sm(),

                        // Info section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildInfoSection(state),
                        ),

                        PaddingGap.md(),

                        // Render all sponsorships (saved + editing)
                        for (final sponsorship in state.sponsorships)
                          editingIds.contains(sponsorship.id)
                              ? _buildSponsorForm(sponsorship.id)
                              : _buildSponsorshipSummary(sponsorship.id, state),

                        // Render editing forms not yet saved
                        for (final entry in editingModels.entries)
                          if (!state.sponsorships.any((s) => s.id == entry.key))
                            _buildSponsorForm(entry.key),

                        PaddingGap.sm(),

                        _buildAddSponsorshipButton(),

                        PaddingGap.xl(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FabButton.primary(
                      onPressed: handleContinue,
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Sponsorship',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Your sponsorship income goal for this event is ${FabFunction.formatRupiah(currency: eventPage7Cubit.state.sponsorshipGoal)}. Adjust slots to reach this target.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
        ),
      ],
    );
  }

  Widget _buildInfoSection(EventPage7State state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Sponsor Slots: ',
              style: FabTypography.displayRegular14,
            ),
            Text(
              '${state.sponsorSlots} Slots',
              style: FabTypography.displaySemiBold14,
            ),
          ],
        ),
        PaddingGap.xxs(),
        Row(
          children: [
            const Text(
              'Total Sponsorship Income: ',
              style: FabTypography.displayRegular14,
            ),
            Text(
              FabFunction.formatRupiah(currency: state.totalSponsorshipIncome),
              style: FabTypography.displaySemiBold14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSponsorForm(String id) {
    final model = editingModels[id];
    if (model == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: AddEvent7FormFormBuilder(
        model: model,
        builder: (context, formModel, child) {
          final inputFormatters = [
            ThousandsSeparatorInputFormatter(separator: ','),
          ];

          return FabCard(
            radius: 12,
            color: FabColors.greyscale0,
            border: Border.all(color: FabColors.greyscale200),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FabTextfield(
                    formControl: formModel.titleControl,
                    labelText: 'Sponsorship Title',
                    hintText: 'e.g. Main Stage Partner',
                    keyboardType: TextInputType.text,
                  ),
                  PaddingGap.md(),
                  FabSelectBottomSheet<String>(
                    formControl: formModel.typeControl,
                    options: _sponsorshipTypeOptions,
                    labelText: 'Sponsorship Type',
                    hintText: 'Select Type',
                    searchHintText: 'Search Type',
                  ),
                  PaddingGap.md(),
                  // Conditional fields based on type
                  ReactiveValueListenableBuilder<String?>(
                    formControl: formModel.typeControl,
                    builder: (context, control, child) {
                      final selectedType = control.value ?? '';

                      if (selectedType == 'Monetary') {
                        return FabTextfield(
                          formControl: formModel.productAmountControl,
                          labelText: 'Requested Amount',
                          hintText: 'e.g. Rp 120.000',
                          keyboardType: TextInputType.number,
                          inputFormatters: inputFormatters,
                        );
                      } else if (selectedType.isNotEmpty) {
                        return Column(
                          children: [
                            FabTextfield(
                              formControl: formModel.requestedProductControl,
                              labelText: 'Requested Product',
                              hintText: 'e.g. 20pcs Backpack, 300pcs Tumblr',
                              maxLines: 2,
                            ),
                            PaddingGap.md(),
                            FabTextfield(
                              formControl: formModel.productAmountControl,
                              labelText: 'Product Amount',
                              hintText: 'e.g. Rp45.000.000',
                              keyboardType: TextInputType.number,
                              inputFormatters: inputFormatters,
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.descriptionControl,
                    labelText: 'Description',
                    hintText: 'Outline the benefits for the sponsor',
                    maxLines: 3,
                  ),
                  PaddingGap.md(),
                  Row(
                    children: [
                      Expanded(
                        child: FabButton.secondary(
                          onPressed: () => removeSponsorship(id),
                          size: FabButtonSize.large,
                          child: Text(
                            'Delete',
                            style: FabTypography.displaySemiBold16.copyWith(
                              color: FabColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      PaddingGap.sm(),
                      Expanded(
                        child: FabButton.primary(
                          onPressed: () {
                            formModel.submit(
                              onValid: (validModel) =>
                                  saveSponsorship(id, validModel),
                              onNotValid: () {
                                FabSnackbar.error(
                                  context: context,
                                  content: 'Please fill all required fields',
                                );
                                setState(() {});
                              },
                            );
                          },
                          size: FabButtonSize.large,
                          child: Text(
                            'Save',
                            style: FabTypography.displaySemiBold16.copyWith(
                              color: FabColors.greyscale0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddSponsorshipButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: addSponsorship,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: FabColors.textPrimary,
              size: 20,
            ),
            PaddingGap.xxs(),
            Text(
              'Sponsor Slots',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorshipSummary(String id, EventPage7State state) {
    final sponsorship = state.sponsorships.firstWhere((s) => s.id == id);

    final title = sponsorship.title;
    final type = sponsorship.type;
    final desc = sponsorship.description;

    String amountDisplay = '';
    String productInfo = '';

    if (type == 'Monetary') {
      amountDisplay = sponsorship.productAmount;
    } else {
      productInfo = sponsorship.requestedProduct;
      amountDisplay = sponsorship.productAmount;
    }

    // Tentukan warna badge berdasarkan type
    Color badgeColor;
    switch (type) {
      case 'Monetary':
        badgeColor = const Color(0xFFD1F4E0); // Light green
        break;
      case 'Product':
        badgeColor = const Color(0xFFD1F0FF); // Light blue
        break;
      case 'Media':
        badgeColor = const Color(0xFFFFF4D1); // Light yellow
        break;
      default:
        badgeColor = FabColors.primary50;
    }

    return GestureDetector(
      onTap: () => editSponsorship(id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: FabCard(
          radius: 12,
          pressedOpacity: 1,
          color: FabColors.greyscale0,
          border: Border.all(color: FabColors.greyscale200),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: FabTypography.displaySemiBold16.copyWith(
                          color: FabColors.textPrimary,
                        ),
                      ),
                    ),
                    PaddingGap.sm(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                PaddingGap.xxs(),

                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    PaddingGap.xxs(),
                    Text(
                      amountDisplay,
                      style: FabTypography.bodySmallMedium.copyWith(
                        color: FabColors.greyscale500,
                      ),
                    ),
                  ],
                ),

                // Show product info if not Monetary
                if (type != 'Monetary' && productInfo.isNotEmpty) ...[
                  PaddingGap.xxs(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: FabColors.greyscale500,
                      ),
                      PaddingGap.xxs(),
                      Expanded(
                        child: Text(
                          productInfo,
                          style: FabTypography.bodySmallMedium.copyWith(
                            color: FabColors.greyscale500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                PaddingGap.xxs(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: FabColors.greyscale500,
                    ),
                    PaddingGap.xxs(),
                    Expanded(
                      child: Text(
                        desc,
                        style: FabTypography.bodySmallMedium.copyWith(
                          color: FabColors.greyscale500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
