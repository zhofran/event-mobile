import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../design.dart';
import '../textfield/fab_textfield_theme.dart';

/// Time picker widget with reactive forms integration
class FabTimepicker extends StatefulWidget {
  const FabTimepicker({
    required this.formControl,
    this.labelText,
    this.hintText = 'Select Time',
    this.size = FabTextfieldSize.large,
    this.variant = FabTextfieldVariant.primary,
    this.prefixIcon,
    this.enabled = true,
    this.onChanged,
    this.validationMessages,
    this.initialTime,
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
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Message Validation / Error
  final Map<String, String Function(Object messages)>? validationMessages;

  /// Initial selected time
  final TimeOfDay? initialTime;

  @override
  State<FabTimepicker> createState() => _FabTimepickerState();
}

class _FabTimepickerState extends State<FabTimepicker> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _updateSelectedTime();
    widget.formControl.valueChanges.listen((_) {
      _updateSelectedTime();
    });
  }

  void _updateSelectedTime() {
    final currentValue = widget.formControl.value;

    if (currentValue is TimeOfDay) {
      _selectedTime = currentValue;
    } else if (currentValue is String && currentValue.isNotEmpty) {
      try {
        // Parse string format "HH:mm"
        final parts = currentValue.split(':');
        if (parts.length == 2) {
          _selectedTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      } catch (e) {
        _selectedTime = null;
      }
    } else {
      _selectedTime = widget.initialTime;
    }

    if (mounted) {
      setState(() {});
    }
  }

  String _formatTimeToString(TimeOfDay time) {
    // Format as "HH:mm" for storage
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }

  Future<void> _showTimePicker() async {
    if (!widget.enabled) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        // Store as "HH:mm" string format
        widget.formControl.value = _formatTimeToString(picked);
        widget.formControl.markAsTouched();
        widget.onChanged?.call(_selectedTime);
      });
    }
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

            // Time Picker Container
            InkWell(
              onTap: _showTimePicker,
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
                          _selectedTime != null
                              ? _formatTime(context, _selectedTime!)
                              : widget.hintText,
                          style: _selectedTime != null
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
