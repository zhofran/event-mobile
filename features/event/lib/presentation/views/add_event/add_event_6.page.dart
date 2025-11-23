import 'dart:developer';
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/add_event_6.form.dart';
import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page6.cubit.dart';

@RoutePage()
class AddEvent6Page extends StatefulWidget {
  const AddEvent6Page({super.key, @queryParam this.fromReview = false});

  final bool fromReview;

  @override
  State<AddEvent6Page> createState() => _AddEvent6PageState();
}

class _AddEvent6PageState extends State<AddEvent6Page> {
  late BudgetPlannerCubit budgetPlannerCubit;
  late EventPage6Cubit eventPage6Cubit;
  int currentStep = 7;
  int totalSteps = 10;

  // Local state for editing vendor forms - store model and ID for editing forms
  final Map<String, AddEvent6Form> editingModels = {};
  final Set<String> editingIds = {};

  final List<SelectOption<String>> _categoriesOptions = [
    const SelectOption(value: 'Catering', label: 'Catering'),
    const SelectOption(value: 'Booth/Stage Setup', label: 'Booth/Stage Setup'),
    const SelectOption(value: 'Decoration', label: 'Decoration'),
    const SelectOption(value: 'Sound System', label: 'Sound System'),
  ];

  final List<SelectOption<String>> _vendorOptions = [
    SelectOption(
      value: 'Gourmet Grub',
      label: 'Gourmet Grub Catering',
      subtitle: 'Exquisite Culinary Creations',
      icon: const CircleAvatar(
        radius: 24,
        backgroundColor: FabColors.greyscale200,
        child: Icon(
          Icons.restaurant,
          color: FabColors.greyscale500,
          size: 24,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            '4.8 • 60+ Events',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    ),
    SelectOption(
      value: 'Spice Route',
      label: 'Spice Route Catering',
      subtitle: 'Authentic Flavors, Modern Presentation',
      icon: const CircleAvatar(
        radius: 24,
        backgroundColor: FabColors.greyscale200,
        child: Icon(
          Icons.restaurant_menu,
          color: FabColors.greyscale500,
          size: 24,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            '4.7 • 45+ Clients',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    ),
    SelectOption(
      value: 'Urban Palate',
      label: 'Urban Palate Catering',
      subtitle: 'Sophisticated Catering Solutions',
      icon: const CircleAvatar(
        radius: 24,
        backgroundColor: FabColors.greyscale200,
        child: Icon(
          Icons.dinner_dining,
          color: FabColors.greyscale500,
          size: 24,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            '4.9 • 70+ Clients',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale500,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    eventPage6Cubit = $.get<EventPage6Cubit>();

    // Initialize cubit with maximum budget
    eventPage6Cubit.initialize(
      maximumBudget: budgetPlannerCubit.state.vendorBudget.toDouble(),
    );

    // Load saved vendors
    _loadSavedVendors();
  }

  Future<void> _loadSavedVendors() async {
    await eventPage6Cubit.loadVendorsLocally();
  }

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================

  /// =======================================================
  /// ============== CRUD Logic Vendor RFQ ==================
  /// =======================================================
  void addVendor() {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      editingModels[tempId] = AddEvent6Form.empty();
      editingIds.add(tempId);
    });
  }

  void removeVendor(String id) {
    eventPage6Cubit.removeVendor(id);
    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });
  }

  void saveVendor(String id, AddEvent6Form model) {
    final budget =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(model.budget)
                ?.toDouble() ??
            0.0;

    // Check if this is a new vendor or an update
    final existingVendor =
        eventPage6Cubit.state.vendors.where((v) => v.id == id).firstOrNull;

    if (existingVendor != null) {
      // Update existing
      eventPage6Cubit.updateVendor(
        id: id,
        categories: model.categories,
        vendor: model.vendor,
        budget: budget,
        description: model.description,
      );
    } else {
      // Add new
      eventPage6Cubit.addVendor(
        categories: model.categories,
        vendor: model.vendor,
        budget: budget,
        description: model.description,
      );
    }

    setState(() {
      editingModels.remove(id);
      editingIds.remove(id);
    });

    log('Vendor saved: ${model.vendor}', name: 'add_event_6');
  }

  void editVendor(String id) {
    final vendor = eventPage6Cubit.state.vendors.firstWhere((v) => v.id == id);

    setState(() {
      editingModels[id] = AddEvent6Form(
        categories: vendor.categories,
        vendor: vendor.vendor,
        budget: ThousandsSeparatorInputFormatter.formatNumber(
            vendor.budget.toInt()),
        description: vendor.description,
      );
      editingIds.add(id);
    });
  }

  // Validasi budget dan navigasi ke halaman berikutnya
  void handleContinue() {
    // Check if there are unsaved forms
    if (editingIds.isNotEmpty) {
      FabSnackbar.error(
        context: context,
        content: 'Please save or delete all vendors before continuing',
      );
      return;
    }

    if (eventPage6Cubit.state.isBudgetExceeded) {
      // Tampilkan dialog jika budget terlampaui
      _showBudgetExceededDialog(eventPage6Cubit.state.exceededAmount);
    } else {
      // Lanjut ke halaman berikutnya
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() async {
    await eventPage6Cubit.saveVendorsLocally();

    FabSnackbar.success(
      context: context,
      content: 'Vendor RFQ saved successfully!',
    );

    if (widget.fromReview) {
      context.router.pop(true);
    } else {
      await $.navigator.push(AddEvent7Route());
    }
  }

  // Dialog untuk budget exceeded
  void _showBudgetExceededDialog(double exceededAmount) {
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
                  'Vendor Cost Exceeded',
                  style: FabTypography.displaySemiBold18,
                  textAlign: TextAlign.center,
                ),
                PaddingGap.md(),
                Text(
                  'Vendor spending is ${FabFunction.formatRupiah(currency: exceededAmount)} above the planned budget. Review your vendor quotes or consolidate services to cut costs.',
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale500,
                  ),
                  textAlign: TextAlign.center,
                ),
                PaddingGap.lg(),
                FabButton.primary(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // User bisa edit budget vendor
                  },
                  size: FabButtonSize.large,
                  width: double.infinity,
                  child: Text(
                    'Adjust Cost',
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
      child: BlocBuilder<EventPage6Cubit, EventPage6State>(
        bloc: eventPage6Cubit,
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
                          child: _buildInfoSection(),
                        ),

                        PaddingGap.md(),

                        // Render all vendors
                        for (final vendor in state.vendors)
                          editingIds.contains(vendor.id)
                              ? _buildVendorForm(vendor.id)
                              : _buildVendorSummary(vendor.id, state),

                        // Render editing forms that are not yet saved
                        for (final entry in editingModels.entries)
                          if (!state.vendors.any((v) => v.id == entry.key))
                            _buildVendorForm(entry.key),

                        PaddingGap.sm(),

                        _buildAddVendorButton(),

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
          'Vendor RFQ',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Maximum vendor spending is ${FabFunction.formatRupiah(currency: eventPage6Cubit.state.maximumBudget)}. Keep all vendor quotes within this limit.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Vendor Selected: ',
              style: FabTypography.displayRegular14,
            ),
            Text(
              '${eventPage6Cubit.state.vendorCount} Vendor',
              style: FabTypography.displaySemiBold14,
            ),
          ],
        ),
        PaddingGap.xxs(),
        Row(
          children: [
            const Text(
              'Vendor Total Fee: ',
              style: FabTypography.displayRegular14,
            ),
            Text(
              FabFunction.formatRupiah(
                  currency: eventPage6Cubit.state.totalVendorFee),
              style: FabTypography.displaySemiBold14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddVendorButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: addVendor,
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
              'Add Vendor',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =======================================================
  /// ============== VENDOR FORM ==============
  /// =======================================================
  Widget _buildVendorForm(String id) {
    final model = editingModels[id];
    if (model == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: AddEvent6FormFormBuilder(
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
                  FabSelectBottomSheet<String>(
                    formControl: formModel.categoriesControl,
                    options: _categoriesOptions,
                    labelText: 'Vendor Categories',
                    hintText: 'Select Category',
                    searchHintText: 'Search Vendor Category',
                  ),
                  PaddingGap.md(),
                  FabSelectBottomSheet<String>(
                    formControl: formModel.vendorControl,
                    options: _vendorOptions,
                    labelText: 'Select Vendor',
                    hintText: 'Select Vendor',
                    searchHintText: 'Search Vendor Name',
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.budgetControl,
                    labelText: 'Budget',
                    hintText: 'Enter budget',
                    keyboardType: TextInputType.number,
                    inputFormatters: inputFormatters,
                  ),
                  PaddingGap.md(),
                  FabTextfield(
                    formControl: formModel.descriptionControl,
                    labelText: 'Description',
                    hintText: 'Write description...',
                    maxLines: 3,
                  ),
                  PaddingGap.md(),
                  Row(
                    children: [
                      Expanded(
                        child: FabButton.secondary(
                          onPressed: () => removeVendor(id),
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
                              onValid: (model) => saveVendor(id, model),
                              onNotValid: () {
                                setState(() {
                                  formModel.form.markAllAsTouched();
                                  FabSnackbar.error(
                                    context: context,
                                    content: 'Please fill all required fields',
                                  );
                                });
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

  /// =======================================================
  /// ================= VENDOR SUMMARY ======================
  /// =======================================================
  Widget _buildVendorSummary(String id, EventPage6State state) {
    final vendor = state.vendors.firstWhere((v) => v.id == id);

    return GestureDetector(
      onTap: () => editVendor(id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: FabCard(
          radius: 12,
          pressedOpacity: 1,
          color: FabColors.greyscale0,
          border: Border.all(color: FabColors.greyscale200),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: FabColors.greyscale200,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: FabColors.greyscale500,
                    size: 24,
                  ),
                ),
                PaddingGap.sm(),
                // Vendor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vendor.vendor,
                              style: FabTypography.displaySemiBold16.copyWith(
                                color: FabColors.textPrimary,
                              ),
                            ),
                          ),
                          PaddingGap.sm(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: FabColors.primary50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'View Profile',
                              style: FabTypography.bodySmallMedium.copyWith(
                                color: FabColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      PaddingGap.xxs(),
                      Text(
                        vendor.categories,
                        style: FabTypography.bodySmallRegular.copyWith(
                          color: FabColors.greyscale500,
                        ),
                      ),
                      PaddingGap.xxs(),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          PaddingGap.xxs(),
                          Text(
                            '4.9 • 50+ Client',
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale500,
                            ),
                          ),
                        ],
                      ),
                      PaddingGap.xs(),
                      Row(
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            size: 16,
                            color: FabColors.greyscale500,
                          ),
                          PaddingGap.xxs(),
                          Text(
                            FabFunction.formatRupiah(currency: vendor.budget),
                            style: FabTypography.bodySmallMedium.copyWith(
                              color: FabColors.greyscale500,
                            ),
                          ),
                        ],
                      ),
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
                              vendor.description,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
