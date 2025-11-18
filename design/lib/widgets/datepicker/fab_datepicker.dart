import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/syncfusion_flutter_datepicker.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../design.dart';
import '../textfield/fab_textfield_theme.dart';

/// Date picker widget with reactive forms integration
class FabDatepicker extends StatefulWidget {
  const FabDatepicker({
    required this.formControl,
    this.labelText,
    this.hintText = 'Select Date',
    this.size = FabTextfieldSize.large,
    this.variant = FabTextfieldVariant.primary,
    this.prefixIcon,
    this.enabled = true,
    this.onChanged,
    this.validationMessages,
    this.initialSelectedDate,
    this.minDate,
    this.maxDate,
    super.key,
  });

  /// Form control untuk reactive forms
  final FormControl formControl;

  /// Label untuk field
  final String? labelText;

  /// Placeholder text
  final String hintText;

  /// Ukuran field
  final FabTextfieldSize size;

  /// Variant styling
  final FabTextfieldVariant variant;

  /// Icon prefix
  final Widget? prefixIcon;

  /// Apakah field enabled
  final bool enabled;

  /// Callback ketika nilai berubah
  final ValueChanged<DateTime?>? onChanged;

  /// Message Validation / Error
  final Map<String, String Function(Object messages)>? validationMessages;

  /// Initial selected date
  final DateTime? initialSelectedDate;

  /// Minimum selectable date
  final DateTime? minDate;

  /// Maximum selectable date
  final DateTime? maxDate;

  @override
  State<FabDatepicker> createState() => _FabDatepickerState();
}

class _FabDatepickerState extends State<FabDatepicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _updateSelectedDate();
    widget.formControl.valueChanges.listen((_) {
      _updateSelectedDate();
    });
  }

  void _updateSelectedDate() {
    final currentValue = widget.formControl.value;

    if (currentValue is DateTime) {
      _selectedDate = currentValue;
    } else if (currentValue is String && currentValue.isNotEmpty) {
      try {
        _selectedDate = DateTime.parse(currentValue);
      } catch (e) {
        _selectedDate = null;
      }
    } else {
      _selectedDate = widget.initialSelectedDate;
    }

    if (mounted) {
      setState(() {});
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDatePicker() async {
    if (!widget.enabled) return;

    DateTime? tempSelectedDate = _selectedDate;

    await showDialog(
      context: context,
      builder: (context) {
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
                  onSelectionChanged: (args) {
                    tempSelectedDate = args.value as DateTime?;
                  },
                  initialSelectedDate: _selectedDate ?? DateTime.now(),
                  minDate: widget.minDate,
                  maxDate: widget.maxDate,
                ),
                const SizedBox(height: 16),
                FabButton.primary(
                  onPressed: () {
                    setState(() {
                      _selectedDate = tempSelectedDate;
                      widget.formControl.value = _selectedDate;
                      widget.formControl.markAsTouched();
                      widget.onChanged?.call(_selectedDate);
                    });
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
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder(
      formControl: widget.formControl,
      builder: (context, control, child) {
        final hasError = control.hasErrors && control.touched;
        final errorMessage = hasError
            ? FabValidationMessages.getErrorMessage(
                formControl: widget.formControl,
                fieldLabel: widget.labelText,
                customMessages: widget.validationMessages,
              )
            : null;

        final config = FabTextfieldTheme.getConfig(
          context: context,
          variant: widget.variant,
          size: widget.size,
          state: hasError
              ? FabTextfieldState.error
              : FabTextfieldState.defaultState,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label outside container like FabTextfield
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: FabTypography.bodySmallMedium,
              ),
              const SizedBox(height: 8),
            ],

            // Date Picker Container
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                height: config.height,
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? config.backgroundColor
                      : FabColors.greyscale100,
                  border: Border.all(
                    color: config.borderColor,
                    width: config.borderWidth,
                  ),
                  borderRadius: config.borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (widget.prefixIcon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: config.iconColor,
                            size: widget.size.iconSize,
                          ),
                          child: widget.prefixIcon!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : widget.hintText,
                          style: _selectedDate != null
                              ? config.textStyle
                              : config.hintStyle,
                        ),
                      ),
                      Icon(
                        UIcons.boldRounded.angle_small_down,
                        color: config.iconColor,
                        size: widget.size.iconSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Error message
            if (hasError) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: FabTextfieldTheme.getErrorTextColor(),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      errorMessage ?? 'Error',
                      style: hasError
                          ? FabTextfieldTheme.getErrorTextStyle(widget.size)
                          : config.labelStyle.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
