import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

@RoutePage()
class AddEvent2Page extends StatefulWidget {
  const AddEvent2Page({required this.format, required this.budget, super.key});

  final String format;
  final Map<String, dynamic> budget;

  @override
  State<AddEvent2Page> createState() => _AddEvent2PageState();
}

class _AddEvent2PageState extends State<AddEvent2Page> {
  late FormGroup form;

  int currentStep = 3;
  int totalSteps = 8;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _selectedEventPlatform;
  
  final List<String> _eventPlatform = [
    'Zoom',
    'Microsoft Teams',
    'Google Meet',
    'Others',
    // Add more cities as needed
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'venue': FormControl<String>(validators: [Validators.required],),
      'address': FormControl<String>(),
      'location': FormControl<String>(),
      'link': FormControl<String>(),
      'price': FormControl<String>(validators: [Validators.required],),
      'capacity': FormControl<String>(validators: [Validators.required],),
    });
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedStepProgressIndicator(
                      currentStep: currentStep, 
                      totalSteps: totalSteps
                    ),
                  ),

                  PaddingGap.xl(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildWelcomeSection(),
                  ),

                  PaddingGap.md(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ReactiveForm(
                      formGroup: form,
                      child: _buildAddEventForm(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FabButton.primary(
                onPressed: _handleContinue,
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
          'Schedule & Venue',
          style: FabTypography.displayBold22,
        ),

        PaddingGap.xs(),

        FabTextStyled(
          'You’ve set a maximum budget of ${FabFunction.formatRupiah(currency: double.parse(widget.budget['venueBudget'].toString()))} Make sure your input stays within this limit.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
          // textAlign: TextAlign.center,
        ),
      ]
    );
  }
  
  Widget _buildAddEventForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDatepicker(),

        PaddingGap.md(),

        _buildTimePicker(),

        PaddingGap.md(),
        
        widget.format == 'Offline'
        ? _buildOfflinePlatform()
        : _buildOnlinePlatform(),
      ],
    );
  }
  
  Widget _buildEventPlatform() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Platform',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8,),
        DropdownButtonFormField<String>(
          hint: Text(
            'Select Event Platform',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale400
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
          initialValue: _selectedEventPlatform,
          items: _eventPlatform.map((event) {
            return DropdownMenuItem<String>(
              value: event,
              child: Text(event),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventPlatform = value;
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

  Widget _buildOfflinePlatform() {
    return Column(
      children: [
        // Venue Field
        FabTextfield(
          formControl: form.control('venue') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Venue',
          hintText: 'e.g., Jakarta Convention Center',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ), 
        
        PaddingGap.md(),

        // First Name Field
        FabTextfield(
          formControl: form.control('address') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Address',
          hintText: 'e.g., Jl. Jend. Gatot Subroto',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),
        
        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('location') as FormControl<String>,
          keyboardType: TextInputType.text,
          labelText: 'Location',
          hintText: 'e.g., https://share.google.com/jcc',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),

        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('price') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Price',
          hintText: 'e.g., 100.000.000',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('capacity') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Capacity',
          hintText: 'e.g., 500',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),
      ],
    );
  }

  Widget _buildOnlinePlatform() {
    return Column(
      children: [
        _buildEventPlatform(),

        PaddingGap.md(),

        // Venue Field
        FabTextfield(
          formControl: form.control('link') as FormControl<String>,
          keyboardType: TextInputType.name,
          labelText: 'Link',
          hintText: 'e.g., meet.zoom.com/abc-123',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
        ),

        PaddingGap.md(),
        
        // Last Name Field
        FabTextfield(
          formControl: form.control('price') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Price',
          hintText: 'e.g., 100.000.000',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),

        PaddingGap.md(),

        // Last Name Field
        FabTextfield(
          formControl: form.control('capacity') as FormControl<String>,
          keyboardType: TextInputType.number,
          labelText: 'Capacity',
          hintText: 'e.g., 500',
          textInputAction: TextInputAction.next,
          size: FabTextfieldSize.large,
          inputFormatters: [
            ThousandsSeparatorInputFormatter()
          ],
        ),
      ],
    );
  }

  Widget _buildDatepicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.single,
                          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                            setState(() {
                              selectedDate = args.value as DateTime?;
                            });
                          },
                          initialSelectedDate: selectedDate,
                        ),
                        const SizedBox(height: 16),
                        FabButton.primary(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: FabColors.greyscale200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    style: FabTypography.bodySmallRegular,
                  ),
                ),
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

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: FabTypography.bodySmallMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: FabColors.greyscale200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                  selectedTime == null
                  ? 'Select Time'
                  : selectedTime!.format(context),
                  style: FabTypography.bodySmallRegular.copyWith(
                    color: selectedTime == null ? FabColors.greyscale400 : FabColors.textPrimary,
                  ),
                  ),
                ),
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
  
  void _handleContinue() {
  // 1) Pastikan semua field ditandai touched supaya validasi tampil
  form.markAllAsTouched();

  // 2) Jika form tidak valid, hentikan dan biarkan user melihat error
  // if (!form.valid) return;

  // 3) Ambil string value dari control 'price'
  final priceRaw = (form.control('price').value ?? '').toString();

  // 4) Parse menggunakan helper formatter (menghapus titik ribuan, dll)
  //    Jika parseFormattedNumber mengembalikan int, konversi ke double
  final parsedPriceNum = ThousandsSeparatorInputFormatter.parseFormattedNumber(priceRaw) ?? 0;
  final venuePrice = parsedPriceNum.toDouble();

  // 5) Ambil netBudget dari widget.budget dengan aman
  final venueBudget = double.parse(widget.budget['venueBudget']?.toString() ?? '');

  log('Testing result $venueBudget', name: 'Log handle continue');

  // 6) Bandingkan dan navigasi
  if (venuePrice > venueBudget) {
    log('Testing result $venueBudget', name: 'Log handle continue');
    final exceeded = venuePrice - venueBudget;
    BudgetExceededDialog.show(
      context: context,
      title: 'Schedule & Venue Exceeded',
      exceededAmount: FabFunction.formatRupiah(currency: exceeded),
      onAdjustBudget: () {
      },
      onContinueAnyway: () {
        // Jika kamu menggunakan AutoRoute dan context.router, ganti sesuai itu
        $.navigator.push(AddEvent3Route(budget: widget.budget, capacity: ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('capacity').value ?? '0') ?? 0));
      },
    );
  } else {
    log('Testing result $venueBudget', name: 'Log handle continue');
    $.navigator.push(AddEvent3Route(budget: widget.budget, capacity: ThousandsSeparatorInputFormatter.parseFormattedNumber(form.control('capacity').value ?? '0') ?? 0));
  }

}


}