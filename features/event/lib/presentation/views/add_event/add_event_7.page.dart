import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddEvent7Page extends StatefulWidget {
  const AddEvent7Page({super.key});

  @override
  State<AddEvent7Page> createState() => _AddEvent7PageState();
}

class _AddEvent7PageState extends State<AddEvent7Page> {
  int currentStep = 7;
  int totalSteps = 8;

  // Sponsorship income goal (dari gambar: Rp60.000.000)
  final double sponsorshipGoal = 60000000;

  final List<SponsorshipData> sponsorship = [];

  final List<String> _sponsorshipType = [
    'Monetary',
    'Product',
    'Media',
    'Venue',
    'Co-Branding',
    'Services',
  ];

  /// =======================================================
  /// ============== Helper Methods =========================
  /// =======================================================
  
  // Menghitung total sponsorship income
  double get totalSponsorshipIncome {
    double total = 0;
    for (var sponsor in sponsorship) {
      if (!sponsor.isEditing) {
        final form = sponsor.form;
        final type = form.control('type').value ?? '';
        
        if (type == 'Monetary') {
          // Untuk Monetary, ambil dari 'request' field
          final amountStr = form.control('request').value?.toString() ?? '0';
          final amount = double.tryParse(amountStr.replaceAll('.', '').replaceAll(',', '').replaceAll('Rp', '').trim()) ?? 0;
          total += amount;
        } else {
          // Untuk Product/lainnya, ambil dari 'productAmount' field
          final amountStr = form.control('productAmount').value?.toString() ?? '0';
          final amount = double.tryParse(amountStr.replaceAll('.', '').replaceAll(',', '').replaceAll('Rp', '').trim()) ?? 0;
          total += amount;
        }
      }
    }
    return total;
  }

  // Menghitung jumlah sponsor slots yang sudah disimpan
  int get sponsorSlots {
    return sponsorship.where((s) => !s.isEditing).length;
  }

  /// =======================================================
  /// ============== CRUD Logic Sponsorship =================
  /// =======================================================
  void addSponsorship() {
    final newForm = FormGroup({
      'title': FormControl<String>(validators: [Validators.required]),
      'type': FormControl<String>(validators: [Validators.required]),
      'request': FormControl<String>(), // For Monetary
      'requestedProduct': FormControl<String>(), // For Product
      'productAmount': FormControl<String>(), // For Product
      'description': FormControl<String>(),
    });

    setState(() {
      sponsorship.add(SponsorshipData(form: newForm, isEditing: true));
    });
  }

  void removeSponsorship(int index) {
    setState(() {
      sponsorship.removeAt(index);
    });
  }

  void saveSponsorship(int index) {
    final form = sponsorship[index].form;
    final type = form.control('type').value ?? '';
    
    // Validasi berdasarkan type
    if (type == 'Monetary') {
      form.control('request');
      form.control('requestedProduct').clearValidators();
      form.control('productAmount').clearValidators();
    } else {
      form.control('request').clearValidators();
      form.control('requestedProduct');
      form.control('productAmount');
    }
    
    form.control('request').updateValueAndValidity();
    form.control('requestedProduct').updateValueAndValidity();
    form.control('productAmount').updateValueAndValidity();
    
    if (form.valid) {
      setState(() {
        sponsorship[index].isEditing = false;
      });
      log('Sponsorship saved: ${form.value}', name: 'add_event_6');
    } else {
      form.markAllAsTouched();
    }
  }

  void editSponsorship(int index) {
    setState(() {
      sponsorship[index].isEditing = true;
    });
  }

  // Validasi income dan navigasi ke halaman berikutnya
  void handleContinue() {
    final total = totalSponsorshipIncome;
    final shortfall = sponsorshipGoal - total;

    if (shortfall > 0) {
      // Tampilkan dialog jika income belum mencapai target
      _showIncomeBelowTargetDialog(shortfall);
    } else {
      // Lanjut ke halaman berikutnya
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    $.navigator.push(const AddEvent8Route());
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
                  'Sponsorship income hasn\'t met your target by ${FabFunction.formatRupiah(currency: shortfall)}. Reach out to more partners or update your offer packages to boost revenue.',
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

                  // Render semua sponsorship card
                  for (int i = 0; i < sponsorship.length; i++)
                    sponsorship[i].isEditing
                        ? _buildSponsorForm(i)
                        : _buildSponsorshipSummary(i),

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
          'Sponsorship',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Your sponsorship income goal for this event is ${FabFunction.formatRupiah(currency: sponsorshipGoal)}. Adjust slots to reach this target.',
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
              'Sponsor Slots: ',
              style: FabTypography.displayRegular14,
            ),
            Text(
              '$sponsorSlots Slots',
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
              FabFunction.formatRupiah(currency: totalSponsorshipIncome),
              style: FabTypography.displaySemiBold14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSponsorForm(int index) {
    final form = sponsorship[index].form;

    return ReactiveForm(
      formGroup: form,
      child: FabCardForm(
        form: form,
        buildFields: (form) => [
          FabTextfield(
            formControl: form.control('title') as FormControl<String>,
            labelText: 'Sponsorship Title *',
            hintText: 'e.g. Main Stage Partner',
            keyboardType: TextInputType.text,
            size: FabTextfieldSize.large,
          ),
          
          PaddingGap.md(),
  
          _buildSponsorshipTypeDropdown(form),
          
          PaddingGap.md(),
  
          // Conditional fields based on type
          ReactiveValueListenableBuilder<String?>(
            formControl: form.control('type') as FormControl<String>,
            builder: (context, control, child) {
              final selectedType = control.value;
              
              if (selectedType == 'Monetary') {
                // Show only Requested Amount for Monetary
                return FabTextfield(
                  formControl: form.control('request') as FormControl<String>,
                  labelText: 'Requested Amount *',
                  hintText: 'e.g. Rp 120.000',
                  keyboardType: TextInputType.number,
                  size: FabTextfieldSize.large,
                  inputFormatters: [
                    ThousandsSeparatorInputFormatter()
                  ],
                );
              } else if (selectedType != null && selectedType.isNotEmpty) {
                // Show Requested Product and Product Amount for other types
                return Column(
                  children: [
                    FabTextfield(
                      formControl: form.control('requestedProduct') as FormControl<String>,
                      labelText: 'Requested Product *',
                      hintText: 'e.g. 20pcs Backpack, 300pcs Tumblr',
                      keyboardType: TextInputType.text,
                      size: FabTextfieldSize.large,
                      maxLines: 2,
                    ),
                    PaddingGap.md(),
                    FabTextfield(
                      formControl: form.control('productAmount') as FormControl<String>,
                      labelText: 'Product Amount *',
                      hintText: 'e.g. Rp45.000.000',
                      keyboardType: TextInputType.text,
                      size: FabTextfieldSize.large,
                      inputFormatters: [
                        ThousandsSeparatorInputFormatter()
                      ],
                    ),
                  ],
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          PaddingGap.md(),
          
          FabTextfield(
            formControl: form.control('description') as FormControl<String>,
            labelText: 'Description *',
            hintText: 'Outline the benefits for the sponsor',
            maxLines: 3,
            size: FabTextfieldSize.large,
          ),
        ],
        buildSummary: (form) => _buildSponsorshipSummary(index),
        onSaved: (form) => saveSponsorship(index),
        onEdit: () => editSponsorship(index),
        onDelete: () => removeSponsorship(index),
      ),
    );
  }

  Widget _buildSponsorshipTypeDropdown(FormGroup form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sponsorship Type *',
          style: FabTypography.bodySmallMedium.copyWith(
            color: FabColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ReactiveDropdownField<String>(
          formControlName: 'type',
          hint: Text(
            'Select Sponsorship Type',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400,
            ),
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.primary300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: FabColors.greyscale200),
            ),
          ),
          items: _sponsorshipType
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: FabColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          icon: Icon(
            UIcons.boldRounded.angle_small_down,
            size: 20,
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Sponsorship Type is required',
          },
        ),
      ],
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

  Widget _buildSponsorshipSummary(int index) {
    final form = sponsorship[index].form;

    final title = form.control('title').value ?? '';
    final type = form.control('type').value ?? '';
    final desc = form.control('description').value ?? '';
    
    String amountDisplay = '';
    String productInfo = '';
    
    if (type == 'Monetary') {
      amountDisplay = form.control('request').value ?? '';
    } else {
      productInfo = form.control('requestedProduct').value ?? '';
      amountDisplay = form.control('productAmount').value ?? '';
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
      onTap: () => editSponsorship(index),
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

class SponsorshipData {
  FormGroup form;
  bool isEditing;

  SponsorshipData({
    required this.form,
    this.isEditing = true,
  });
}