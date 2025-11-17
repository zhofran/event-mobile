import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

import '../../design.dart';
import '../textfield/fab_textfield_theme.dart';

/// Simple dropdown widget with native dropdown behavior
class FabDropdown<T> extends StatefulWidget {
  const FabDropdown({
    required this.options,
    required this.formControl,
    this.labelText,
    this.hintText = 'Select an option',
    this.size = FabTextfieldSize.large,
    this.variant = FabTextfieldVariant.primary,
    this.prefixIcon,
    this.enabled = true,
    this.onChanged,
    this.validationMessages,
    super.key,
  });

  /// Daftar opsi yang tersedia
  final List<SelectOption<T>> options;

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
  final ValueChanged<SelectOption<T>?>? onChanged;

  /// Message Validation / Error
  final Map<String, String Function(Object messages)>? validationMessages;

  @override
  State<FabDropdown<T>> createState() => _FabDropdownState<T>();
}

class _FabDropdownState<T> extends State<FabDropdown<T>> {
  SelectOption<T>? _selectedOption;

  @override
  void initState() {
    super.initState();
    _updateSelectedOption();
    widget.formControl.valueChanges.listen((_) {
      _updateSelectedOption();
    });
  }

  void _updateSelectedOption() {
    final currentValue = widget.formControl.value;

    if (currentValue != null) {
      _selectedOption = widget.options.firstWhere(
        (option) => option.value == currentValue,
        orElse: () => widget.options.first,
      );
    } else {
      _selectedOption = null;
    }

    if (mounted) {
      setState(() {});
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
                style: config.labelStyle,
              ),
              const SizedBox(height: 8),
            ],

            // Dropdown Container
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: config.height,
                  decoration: BoxDecoration(
                    color: config.backgroundColor,
                    border: Border.all(
                      color: config.borderColor,
                      width: config.borderWidth,
                    ),
                    borderRadius: config.borderRadius,
                  ),
                  child: PopupMenuButton<T>(
                    enabled: widget.enabled,
                    offset: Offset(0, config.height + 4),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: FabColors.greyscale200),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 300,
                      minWidth: constraints.maxWidth,
                      maxWidth: constraints.maxWidth,
                    ),
                itemBuilder: (context) {
                  return widget.options.map((option) {
                    final isSelected = _selectedOption?.value == option.value;
                    return PopupMenuItem<T>(
                      value: option.value,
                      enabled: option.enabled,
                      child: Row(
                        children: [
                          if (widget.prefixIcon != null && option.icon == null)
                            const SizedBox(width: 28),
                          if (option.icon != null) ...[
                            option.icon!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              option.label,
                              style: config.textStyle.copyWith(
                                color: option.enabled
                                    ? FabColors.greyscale700
                                    : FabColors.greyscale400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: FabColors.greyscale900,
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  final selectedOption = widget.options.firstWhere(
                    (option) => option.value == value,
                  );
                  widget.formControl.value = value;
                  widget.onChanged?.call(selectedOption);
                },
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
                          _selectedOption?.label ?? widget.hintText,
                          style: _selectedOption != null
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
              );
            },
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
