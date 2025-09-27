// ignore_for_file: max_lines_for_file, prefer_underscore_for_unused_callback_parameters

import 'package:deps/features/features.dart';
import 'package:deps/packages/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fab_textfield_types.dart';
import 'fab_textfield_theme.dart';

class FabTextfield extends StatefulWidget {
  const FabTextfield({
    required this.formControl,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = FabTextfieldVariant.primary,
    this.size = FabTextfieldSize.large,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validationMessages,
    this.showErrors = true,
    super.key,
  });

  final FormControl formControl;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FabTextfieldVariant variant;
  final FabTextfieldSize size;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final Map<String, String Function(Object messages)>? validationMessages;
  final bool showErrors;

  @override
  State<FabTextfield> createState() => _FabTextfieldState();
}

class _FabTextfieldState extends State<FabTextfield> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  FabTextfieldState _getCurrentState() {
    if (!widget.enabled) {
      return FabTextfieldState.disabled;
    }
    
    if (widget.formControl.hasErrors && widget.showErrors && widget.formControl.touched) {
      return FabTextfieldState.error;
    }
    
    if (_isFocused) {
      return FabTextfieldState.focused;
    }
    
    return FabTextfieldState.defaultState;
  }

  Map<String, String Function(Object messages)> get _validationMessages => {
        ValidationMessage.minLength: (error) => $.tr.design.widgets.reactives.fabReactiveTextfield.minLength(
              field: widget.labelText?.capitalize() ?? 'Field',
              count: (error as Map)['requiredLength'].toString(),
            ),
        ValidationMessage.maxLength: (error) => $.tr.design.widgets.reactives.fabReactiveTextfield.maxLength(
              field: widget.labelText?.capitalize() ?? 'Field',
              count: (error as Map)['requiredLength'].toString(),
            ),
        ValidationMessage.required: (_) => $.tr.design.widgets.reactives.fabReactiveTextfield.required(
              field: widget.labelText?.capitalize() ?? 'Field',
            ),
        ValidationMessage.email: (_) => $.tr.design.widgets.reactives.fabReactiveTextfield.email(
              field: widget.labelText?.capitalize() ?? 'Field',
            ),
        if (widget.validationMessages != null) ...widget.validationMessages!,
      };

  String? _getErrorMessage() {
    if (!widget.formControl.hasErrors) return null;
    
    final errors = widget.formControl.errors;
    final errorKey = errors.keys.first;
    final errorValue = errors[errorKey] ?? {};
    
    // Check if we have a custom validation message for this error
    if (_validationMessages.containsKey(errorKey)) {
      return _validationMessages[errorKey]!(errorValue);
    }
    
    // Fallback to a generic error message
    return 'Invalid ${widget.labelText?.toLowerCase() ?? 'field'}';
  }

  @override
  Widget build(BuildContext context) {
    final currentState = _getCurrentState();
    final config = FabTextfieldTheme.getConfig(
      context: context,
      variant: widget.variant,
      size: widget.size,
      state: currentState,
    );

    return ReactiveFormConsumer(
      builder: (context, _, __) {
        final hasError = widget.formControl.hasErrors && widget.showErrors && widget.formControl.touched;
        final errorMessage = hasError ? _getErrorMessage() : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            if (widget.labelText != null) ...[
              Text(
                widget.labelText!,
                style: config.labelStyle,
              ),
              const SizedBox(height: 8),
            ],

            // Textfield Container
            Container(
              height: config.height,
              decoration: BoxDecoration(
                color: config.backgroundColor,
                border: Border.all(
                  color: config.borderColor,
                  width: config.borderWidth,
                ),
                borderRadius: config.borderRadius,
                boxShadow: _buildBoxShadows(config),
              ),
              child: Row(
                children: [
                  // Prefix Icon
                  if (widget.prefixIcon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: IconTheme(
                        data: IconThemeData(
                          color: config.iconColor,
                          size: widget.size.iconSize,
                        ),
                        child: widget.prefixIcon!,
                      ),
                    ),
                  ],

                  // Text Input
                  Expanded(
                    child: ReactiveTextField(
                      formControl: widget.formControl,
                      focusNode: _focusNode,
                      style: config.textStyle,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: config.hintStyle,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: widget.prefixIcon == null ? 16 : 0,
                          vertical: 0,
                        ),
                        isDense: true,
                      ),
                      readOnly: widget.readOnly,
                      obscureText: widget.obscureText,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      maxLength: widget.maxLength,
                      keyboardType: widget.keyboardType,
                      textCapitalization: widget.textCapitalization,
                      textInputAction: widget.textInputAction,
                      inputFormatters: widget.inputFormatters,
                      autofocus: widget.autofocus,
                      onTap: widget.onTap != null ? (_) => widget.onTap!() : null,
                      onChanged: widget.onChanged != null ? (control) => widget.onChanged!(control.value?.toString() ?? '') : null,
                      onSubmitted: widget.onSubmitted != null 
                          ? (_) => widget.onSubmitted!() 
                          : null,
                      validationMessages: _validationMessages,
                      showErrors: (_) => false, // We handle errors manually
                    ),
                  ),

                  // Suffix Icon
                  if (widget.suffixIcon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 12),
                      child: IconTheme(
                        data: IconThemeData(
                          color: config.iconColor,
                          size: widget.size.iconSize,
                        ),
                        child: widget.suffixIcon!,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Helper/Error Text
            if (hasError || widget.helperText != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  if (hasError) ...[
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: FabTextfieldTheme.getErrorTextColor(),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      hasError ? (errorMessage ?? 'Error') : widget.helperText!,
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

  /// Membuat dua lapisan shadow untuk efek border bold dan outline soft
  List<BoxShadow>? _buildBoxShadows(FabTextfieldConfig config) {
    if (config.elevation <= 0) return null;

    List<BoxShadow> shadows = [];

    // Lapisan 1: Outline soft (lebih besar, lebih halus)
    if (config.outlineColor != null) {
      shadows.add(
        BoxShadow(
          color: config.outlineColor!,
          blurRadius: 0.5, // Blur radius besar untuk efek soft
          spreadRadius: 3.0, // Spread untuk membuat outline lebih lebar
          offset: const Offset(0, 0), // Centered shadow
        ),
      );
    }

    // Lapisan 2: Shadow untuk border bold (lebih kecil, lebih tajam)
    if (config.shadowColor != null) {
      shadows.add(
        BoxShadow(
          color: config.shadowColor!,
          blurRadius: 2.0, // Blur radius kecil untuk efek bold
          spreadRadius: 0.5, // Spread kecil untuk border effect
          offset: const Offset(0, 0), // Centered shadow
        ),
      );
    }

    return shadows.isNotEmpty ? shadows : null;
  }
}
