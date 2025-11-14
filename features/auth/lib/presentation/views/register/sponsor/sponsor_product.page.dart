import 'dart:io';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/photo_avatar.dart';

@RoutePage()
class SponsorProductPage extends StatefulWidget {
  const SponsorProductPage({super.key});

  @override
  State<SponsorProductPage> createState() => _SponsorProductPageState();
}

class _SponsorProductPageState extends State<SponsorProductPage> {
  late FormGroup form;

  Set<String> _selectedCategories = {};

  final List<SelectOption<String>> _categoriesOptions = [
    const SelectOption(value: 'equipment_machinery', label: 'Equipment & Machinery'),
    const SelectOption(value: 'software_technology', label: 'Software & Technology'),
    const SelectOption(value: 'consulting_services', label: 'Consulting Services'),
    const SelectOption(value: 'Others', label: 'Others'),
  ];

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'productName': FormControl<String>(value: ''),
      'offerDesc': FormControl<String>(value: ''),
      'link': FormControl<String>(value: ''),
    });
  }
  
  @override
  void dispose() {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ReactiveForm(
                      formGroup: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),

                          PaddingGap.md(),

                          _buildFormProduct(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: () {
                  // TODO: handle submit
                  // For now, print selected values and pop
                  // debugPrint("Product: ${form.control('productName').value}");
                  // debugPrint("Categories: ${_selectedCategories.join(', ')}");
                  // debugPrint("Link: ${form.control('link').value}");
                  $.navigator.push(SponsorCampaignRoute());
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
            iconWidget: Assets.images.icons.arrowLeftSLine.svg(width: 20, height: 20, package: 'design'),
            child: const SizedBox.shrink(),
          ),
          const Expanded(
            child: FabTextStyled(
              'Register Sponsor',
              style: FabTypography.displaySemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        const FabTextStyled(
          'Showcase Your Products or Offers',
          style: FabTypography.displaySemiBold22,
        ),

        PaddingGap.sm(),

        FabTextStyled(
          "This helps you appear in the platform's marketplace and event sponsor listings.",
          style: FabTypography.displayRegular14.copyWith(color: FabColors.greyscale400),
        ),
      ],
    );
  }

  Widget _buildSelectedCategoryChips() {
    if (_selectedCategories.isEmpty) {
      return const Text('Select Categories', style: TextStyle(color: Colors.black54));
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _selectedCategories.map((c) {
        final label = _categoriesOptions
                .firstWhere((opt) => opt.value == c, orElse: () => SelectOption<String>(value: c, label: c))
                .label;
        return Chip(
          label: Text(label),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setState(() => _selectedCategories.remove(c));
          },
          backgroundColor: FabColors.primary25,
          side: const BorderSide(
            color: FabColors.primary,
          ),
          deleteIconColor: Colors.grey,
        );
      }).toList(),
    );
  }

  Widget _buildFormProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        FabTextfield(
          formControl: form.control('productName') as FormControl<String>,
          labelText: 'Product Name',
          hintText: 'Name your product',
        ),

        PaddingGap.xs(),

        // Product Categories (multi-select)
        _buildCategories(),

        PaddingGap.xs(),

        // Offer Description
        FabTextfield(
          formControl: form.control('offerDesc') as FormControl<String>,
          labelText: 'Offer Description',
          hintText: 'Describe your offer',
        ),

        PaddingGap.xs(),

        // Upload Product Photo
        const Text('Upload Product Photo (optional)'),
        PaddingGap.sm(),
        PhotoAvatar(
          size: 90,
          shape: BoxShape.rectangle,
          backgroundColor: FabColors.background,
          iconColor: FabColors.primary200,
          onImagePicked: (File? image) {
            print('Image picked: ${image?.path}');
          },
        ),
        // GestureDetector(
        //   onTap: () {
            
        //   },
        //   child: Container(
        //     width: 72,
        //     height: 72,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(color: FabColors.greyscale200),
        //     ),
        //     child: const Center(
        //       child: Icon(CupertinoIcons.camera_fill, size: 28, color: FabColors.primary200),
        //     ),
        //   ),
        // ),
        PaddingGap.sm(),
        const Text('Upload up to 3 images (JPG or PNG)', style: TextStyle(color: Colors.grey)),

        PaddingGap.xs(),

        // Link to online store
        FabTextfield(
          formControl: form.control('link') as FormControl<String>,
          labelText: 'Link to Online Store',
          hintText: 'e.g., https://yourshop.com/product',
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Categories',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.textPrimary
          )
        ),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: () {
            FabMultiSelectBottomSheet.show<String>(
              context: context,
              title: 'Product Categories',
              primaryColor: FabColors.primary,
              options: _categoriesOptions,
              initialSelected: _selectedCategories,
              onConfirm: (selected) {
                setState(() {
                  _selectedCategories = selected;
                });
              },
            );
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              hintText: 'Select Product Categories',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedCategories.isEmpty
                  ? const Text('Select Product Categories', style: TextStyle(color: Colors.black54))
                  : _buildSelectedCategoryChips(),
                ),
                IconTheme(
                  data: const IconThemeData(
                    color: FabColors.textPrimary,
                    size: 20,
                  ),
                  child: Icon(
                    UIcons.boldRounded.angle_small_down,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
