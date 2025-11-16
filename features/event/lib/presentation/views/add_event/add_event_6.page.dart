import 'dart:developer';
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddEvent6Page extends StatefulWidget {
  const AddEvent6Page({required this.budget, super.key});

  final Map<String, dynamic> budget;

  @override
  State<AddEvent6Page> createState() => _AddEvent6PageState();
}

class _AddEvent6PageState extends State<AddEvent6Page> {
  int currentStep = 6;
  int totalSteps = 8;

  // Maximum budget untuk vendor (dari gambar: Rp90.000.000)
  double get maximumBudget => double.parse(widget.budget['vendorBudget'].toString());

  final List<VendorRFQData> vendorRFQ = [];

  final List<SelectOption<String>> _categoriesOptions = [
    const SelectOption(value: 'Catering', label: 'Catering'),
    const SelectOption(value: 'Booth/Stage Setup', label: 'Booth/Stage Setup'),
    const SelectOption(value: 'Decoration', label: 'Decoration'),
    const SelectOption(value: 'Sound System', label: 'Sound System'),
  ];

  final List<SelectOption<String>> _vendorOptions = [
    const SelectOption(value: 'Catering by Carmela', label: 'Catering by Carmela'),
    const SelectOption(value: 'Iwan Panggung', label: 'Iwan Panggung'),
    const SelectOption(value: 'Agatha Dekorasi', label: 'Agatha Dekorasi'),
    const SelectOption(value: 'Wawan Sound System', label: 'Wawan Sound System'),
  ];

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================
  
  // Menghitung total vendor fee
  double get totalVendorFee {
    double total = 0;
    for (var vendor in vendorRFQ) {
      if (!vendor.isEditing && vendor.form.control('budget').value != null) {
        final budgetStr = vendor.form.control('budget').value.toString();
        final budget = double.tryParse(budgetStr.replaceAll('.', '').replaceAll(',', '')) ?? 0;
        total += budget;
      }
    }
    return total;
  }

  // Menghitung jumlah vendor yang sudah disimpan (tidak sedang diedit)
  int get vendorSelectedCount {
    return vendorRFQ.where((v) => !v.isEditing).length;
  }

  /// =======================================================
  /// ============== CRUD Logic Vendor RFQ ==================
  /// =======================================================
  void addVendor() {
    final newForm = FormGroup({
      'categories': FormControl<String>(),
      'vendor': FormControl<String>(),
      'budget': FormControl<String>(validators: [Validators.required]),
      'description': FormControl<String>(),
    });

    setState(() {
      vendorRFQ.add(VendorRFQData(form: newForm, isEditing: true));
    });
  }

  void removeVendor(int index) {
    setState(() {
      vendorRFQ.removeAt(index);
    });
  }

  void saveVendor(int index) {
    final form = vendorRFQ[index].form;
    if (form.valid) {
      setState(() {
        vendorRFQ[index].isEditing = false;
      });
      log('Vendor saved: ${form.value}', name: 'add_event_5');
    } else {
      form.markAllAsTouched();
    }
  }

  void editVendor(int index) {
    setState(() {
      vendorRFQ[index].isEditing = true;
    });
  }

  // Validasi budget dan navigasi ke halaman berikutnya
  void handleContinue() {
    final total = totalVendorFee;
    final exceeded = total - maximumBudget;

    if (exceeded > 0) {
      // Tampilkan dialog jika budget terlampaui
      _showBudgetExceededDialog(exceeded);
    } else {
      // Lanjut ke halaman berikutnya
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    $.navigator.push(const AddEvent7Route());
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

                  // Render semua vendor card
                  for (int i = 0; i < vendorRFQ.length; i++)
                    vendorRFQ[i].isEditing
                        ? _buildVendorForm(i)
                        : _buildVendorSummary(i),

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
              'Create Event',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Vendor RFQ',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Maximum vendor spending is ${FabFunction.formatRupiah(currency: maximumBudget)}. Keep all vendor quotes within this limit.',
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
              '$vendorSelectedCount Vendor',
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
              FabFunction.formatRupiah(currency: totalVendorFee),
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
  /// ============== VENDOR FORM (FabCardForm) ==============
  /// =======================================================
  Widget _buildVendorForm(int index) {
    final form = vendorRFQ[index].form;

    return FabCardForm(
      form: form,
      buildFields: (form) => [
        FabSelectBottomSheet<String>(
          formControl: form.control('categories') as FormControl<String>,
          labelText: 'Vendor Categories *',
          hintText: 'Select Category',
          searchHintText: 'Search Category',
          options: _categoriesOptions,
          onChanged: (selectedOption) {
            if (selectedOption != null) {
              form.control('categories').value = selectedOption.value;
            }
          },
        ),
        PaddingGap.md(),
        FabSelectBottomSheet<String>(
          formControl: form.control('vendor') as FormControl<String>,
          labelText: 'Select Vendor *',
          hintText: 'Select Vendor',
          searchHintText: 'Search Vendor',
          options: _vendorOptions,
          onChanged: (selectedOption) {
            if (selectedOption != null) {
              form.control('vendor').value = selectedOption.value;
            }
          },
        ),

        PaddingGap.md(),
        
        FabTextfield(
          formControl: form.control('budget') as FormControl<String>,
          labelText: 'Budget *',
          hintText: 'Enter budget',
          keyboardType: TextInputType.number,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),
        
        PaddingGap.md(),
        
        FabTextfield(
          formControl: form.control('description') as FormControl<String>,
          labelText: 'Description *',
          hintText: 'Write description...',
          maxLines: 3,
          size: FabTextfieldSize.large,
        ),
      ],
      buildSummary: (form) => _buildVendorSummary(index),
      onSaved: (form) => saveVendor(index),
      onEdit: () => editVendor(index),
      onDelete: () => removeVendor(index),
    );
  }

  /// =======================================================
  /// ================= VENDOR SUMMARY ======================
  /// =======================================================
  Widget _buildVendorSummary(int index) {
    final form = vendorRFQ[index].form;
    final categories = form.control('categories').value ?? '';
    final vendor = form.control('vendor').value ?? '';
    final budget = form.control('budget').value ?? '';
    final desc = form.control('description').value ?? '';

    return GestureDetector(
      onTap: () => editVendor(index),
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
                              vendor,
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
                        categories,
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
                            'Rp$budget',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// =============== DATA MODEL CLASS ======================
/// =======================================================
class VendorRFQData {
  FormGroup form;
  bool isEditing;

  VendorRFQData({
    required this.form,
    this.isEditing = true,
  });
}