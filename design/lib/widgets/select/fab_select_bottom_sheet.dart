import 'package:deps/packages/reactive_forms.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../design.dart';
import '../textfield/fab_textfield_theme.dart';

/// Widget dropdown yang menampilkan opsi dalam bottom sheet
class FabSelectBottomSheet<T> extends StatefulWidget {
  const FabSelectBottomSheet({
    required this.options,
    required this.formControl,
    this.labelText,
    this.hintText = 'Select an option',
    this.searchHintText = 'Search...',
    this.emptyText = 'No options found',
    this.size = FabTextfieldSize.large,
    this.variant = FabTextfieldVariant.primary,
    this.prefixIcon,
    this.enabled = true,
    this.showSearch = true,
    this.maxHeight = 400,
    this.onChanged,
    this.isMultiSelect = false,
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

  /// Placeholder untuk search field
  final String searchHintText;

  /// Text yang ditampilkan ketika tidak ada opsi
  final String emptyText;

  /// Ukuran field
  final FabTextfieldSize size;

  /// Variant styling
  final FabTextfieldVariant variant;

  /// Icon prefix
  final Widget? prefixIcon;

  /// Apakah field enabled
  final bool enabled;

  /// Apakah menampilkan search
  final bool showSearch;

  /// Tinggi maksimal bottom sheet
  final double maxHeight;

  /// Callback ketika nilai berubah
  final ValueChanged<SelectOption<T>?>? onChanged;

  /// Apakah mode multiple select
  final bool isMultiSelect;

  /// Message Validation / Error
  final Map<String, String Function(Object messages)>? validationMessages;

  @override
  State<FabSelectBottomSheet<T>> createState() =>
      _FabSelectBottomSheetState<T>();
}

class _FabSelectBottomSheetState<T> extends State<FabSelectBottomSheet<T>> {
  SelectOption<T>? _selectedOption;
  List<T> _selectedValues = [];

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

    if (widget.isMultiSelect) {
      // For multi-select, expect List<T>
      if (currentValue is List) {
        _selectedValues = List<T>.from(currentValue);
      } else {
        _selectedValues = [];
      }
    } else {
      // For single select
      // Check if value is not null and not empty string
      if (currentValue != null && currentValue.toString().isNotEmpty) {
        _selectedOption = widget.options.firstWhere(
          (option) => option.value == currentValue,
          orElse: () => widget.options.first,
        );
      } else {
        _selectedOption = null;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showBottomSheet() {
    if (!widget.enabled) {
      return;
    }

    if (widget.isMultiSelect) {
      showModalBottomSheet<List<T>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _MultiSelectBottomSheetContent<T>(
          options: widget.options,
          selectedValues: _selectedValues,
          searchHintText: widget.searchHintText,
          emptyText: widget.emptyText,
          showSearch: widget.showSearch,
          maxHeight: widget.maxHeight,
        ),
      ).then((selectedValues) {
        if (selectedValues != null) {
          widget.formControl.value = selectedValues;
          setState(() {
            _selectedValues = selectedValues;
          });
        }
      });
    } else {
      showModalBottomSheet<SelectOption<T>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _BottomSheetContent<T>(
          options: widget.options,
          selectedOption: _selectedOption,
          searchHintText: widget.searchHintText,
          emptyText: widget.emptyText,
          showSearch: widget.showSearch,
          maxHeight: widget.maxHeight,
        ),
      ).then((selectedOption) {
        if (selectedOption != null) {
          widget.formControl.value = selectedOption.value;
          widget.onChanged?.call(selectedOption);
        }
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
                style: config.labelStyle,
              ),
              const SizedBox(height: 8),
            ],

            // Input Container
            GestureDetector(
              onTap: _showBottomSheet,
              child: Container(
                height: config.height,
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  border: Border.all(
                    color: config.borderColor,
                    width: config.borderWidth,
                  ),
                  borderRadius: config.borderRadius,
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

                    // Text Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.prefixIcon == null ? 16 : 0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: widget.isMultiSelect
                              ? _buildMultiSelectText(config)
                              : Text(
                                  _selectedOption?.label ?? widget.hintText,
                                  style: _selectedOption != null
                                      ? config.textStyle
                                      : config.hintStyle,
                                ),
                        ),
                      ),
                    ),

                    // Suffix Icon (dropdown arrow)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 12),
                      child: IconTheme(
                        data: IconThemeData(
                          color: config.iconColor,
                          size: widget.size.iconSize,
                        ),
                        child: Icon(
                          UIcons.boldRounded.angle_small_down,
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildMultiSelectText(FabTextfieldConfig config) {
    if (_selectedValues.isEmpty) {
      return Text(
        widget.hintText,
        style: config.hintStyle,
      );
    }

    final selectedLabels = _selectedValues.map((value) {
      final option = widget.options.firstWhere(
        (opt) => opt.value == value,
        orElse: () => widget.options.first,
      );
      return option.label;
    }).toList();

    return Text(
      selectedLabels.join(', '),
      style: config.textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Content widget untuk multi-select bottom sheet
class _MultiSelectBottomSheetContent<T> extends StatefulWidget {
  const _MultiSelectBottomSheetContent({
    required this.options,
    required this.selectedValues,
    required this.searchHintText,
    required this.emptyText,
    required this.showSearch,
    required this.maxHeight,
  });

  final List<SelectOption<T>> options;
  final List<T> selectedValues;
  final String searchHintText;
  final String emptyText;
  final bool showSearch;
  final double maxHeight;

  @override
  State<_MultiSelectBottomSheetContent<T>> createState() =>
      _MultiSelectBottomSheetContentState<T>();
}

class _MultiSelectBottomSheetContentState<T>
    extends State<_MultiSelectBottomSheetContent<T>> {
  late FormControl<String> _searchFormControl;
  List<SelectOption<T>> _filteredOptions = [];
  late List<T> _tempSelectedValues;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _tempSelectedValues = List<T>.from(widget.selectedValues);
    _searchFormControl = FormControl<String>(value: '');
    _searchFormControl.valueChanges.listen(_filterOptions);
  }

  @override
  void dispose() {
    _searchFormControl.dispose();
    super.dispose();
  }

  void _filterOptions(String? query) {
    final searchQuery = (query ?? '').toLowerCase();
    setState(() {
      _filteredOptions = widget.options.where((option) {
        return option.label.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void _toggleSelection(T value) {
    setState(() {
      if (_tempSelectedValues.contains(value)) {
        _tempSelectedValues.remove(value);
      } else {
        _tempSelectedValues.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: FabColors.greyscale300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header dengan search
          if (widget.showSearch) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ReactiveForm(
                formGroup: FormGroup({
                  'search': _searchFormControl,
                }),
                child: FabTextfield(
                  formControl: _searchFormControl,
                  hintText: widget.searchHintText,
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: FabColors.greyscale500,
                  ),
                  size: FabTextfieldSize.medium,
                ),
              ),
            ),
          ],

          // Options list with checkboxes
          Flexible(
            child: _filteredOptions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      widget.emptyText,
                      style: FabTypography.body.copyWith(
                        color: FabColors.greyscale500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _filteredOptions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: FabColors.greyscale200,
                    ),
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected =
                          _tempSelectedValues.contains(option.value);

                      // Gunakan custom builder jika tersedia
                      if (option.customBuilder != null) {
                        return InkWell(
                          onTap: option.enabled
                              ? () => _toggleSelection(option.value)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  activeColor: FabColors.primary,
                                  checkColor: Colors.white,
                                  onChanged: option.enabled
                                      ? (checked) {
                                          if (checked != null) {
                                            _toggleSelection(option.value);
                                          }
                                        }
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: option.customBuilder!(context, isSelected),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Layout default dengan subtitle dan trailing support
                      return CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 0,
                        ),
                        secondary: option.icon != null
                            ? SizedBox(
                                width: 48,
                                height: 48,
                                child: option.icon,
                              )
                            : null,
                        title: Text(
                          option.label,
                          style: FabTypography.displaySemiBold16.copyWith(
                            color: FabColors.greyscale900,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: option.subtitle != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option.subtitle!,
                                        style: FabTypography.bodySmallRegular
                                            .copyWith(
                                          color: FabColors.greyscale500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (option.trailing != null) ...[
                                      const SizedBox(width: 8),
                                      option.trailing!,
                                    ],
                                  ],
                                ),
                              )
                            : option.trailing,
                        value: isSelected,
                        activeColor: FabColors.primary,
                        checkColor: Colors.white,
                        enabled: option.enabled,
                        onChanged: option.enabled
                            ? (checked) {
                                if (checked != null) {
                                  _toggleSelection(option.value);
                                }
                              }
                            : null,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FabButton.primary(
              onPressed: () {
                Navigator.of(context).pop(_tempSelectedValues);
              },
              size: FabButtonSize.large,
              width: double.infinity,
              child: Text(
                'Confirm (${_tempSelectedValues.length})',
                style: FabTypography.displaySemiBold16.copyWith(
                  color: FabColors.greyscale0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Content widget untuk bottom sheet
class _BottomSheetContent<T> extends StatefulWidget {
  const _BottomSheetContent({
    required this.options,
    required this.selectedOption,
    required this.searchHintText,
    required this.emptyText,
    required this.showSearch,
    required this.maxHeight,
  });

  final List<SelectOption<T>> options;
  final SelectOption<T>? selectedOption;
  final String searchHintText;
  final String emptyText;
  final bool showSearch;
  final double maxHeight;

  @override
  State<_BottomSheetContent<T>> createState() => _BottomSheetContentState<T>();
}

class _BottomSheetContentState<T> extends State<_BottomSheetContent<T>> {
  late FormControl<String> _searchFormControl;
  List<SelectOption<T>> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchFormControl = FormControl<String>(value: '');
    _searchFormControl.valueChanges.listen(_filterOptions);
  }

  @override
  void dispose() {
    _searchFormControl.dispose();
    super.dispose();
  }

  void _filterOptions(String? query) {
    final searchQuery = (query ?? '').toLowerCase();
    setState(() {
      _filteredOptions = widget.options.where((option) {
        return option.label.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: FabColors.greyscale300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header dengan search
          if (widget.showSearch) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ReactiveForm(
                formGroup: FormGroup({
                  'search': _searchFormControl,
                }),
                child: FabTextfield(
                  formControl: _searchFormControl,
                  hintText: widget.searchHintText,
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: FabColors.greyscale500,
                  ),
                  size: FabTextfieldSize.medium,
                ),
              ),
            ),
          ],

          // Options list
          Flexible(
            child: _filteredOptions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      widget.emptyText,
                      style: FabTypography.body.copyWith(
                        color: FabColors.greyscale500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _filteredOptions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: FabColors.greyscale200,
                    ),
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected = option == widget.selectedOption;

                      // Gunakan custom builder jika tersedia
                      if (option.customBuilder != null) {
                        return InkWell(
                          onTap: option.enabled
                              ? () => Navigator.of(context).pop(option)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: option.customBuilder!(context, isSelected),
                          ),
                        );
                      }

                      // Layout default dengan subtitle dan trailing support
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        leading: option.icon != null
                            ? SizedBox(
                                width: 48,
                                height: 48,
                                child: option.icon,
                              )
                            : null,
                        title: Text(
                          option.label,
                          style: FabTypography.displaySemiBold16.copyWith(
                            color: isSelected
                                ? FabColors.primary
                                : FabColors.greyscale900,
                          ),
                        ),
                        subtitle: option.subtitle != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  option.subtitle!,
                                  style: FabTypography.bodySmallRegular.copyWith(
                                    color: FabColors.greyscale500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (option.trailing != null) ...[
                              option.trailing!,
                              const SizedBox(width: 8),
                            ],
                            if (isSelected)
                              const Icon(
                                CupertinoIcons.checkmark,
                                color: FabColors.primary,
                                size: 20,
                              ),
                          ],
                        ),
                        enabled: option.enabled,
                        onTap: option.enabled
                            ? () => Navigator.of(context).pop(option)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
