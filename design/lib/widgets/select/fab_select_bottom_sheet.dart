import 'package:deps/features/features.dart';
import 'package:deps/packages/smooth_sheets.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../design.dart';
import '../textfield/fab_textfield.dart';
import '../textfield/fab_textfield_theme.dart';
import 'models/select_option.dart';

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
    super.key,
  });

  /// Daftar opsi yang tersedia
  final List<SelectOption<T>> options;
  
  /// Form control untuk reactive forms
  final FormControl<T> formControl;
  
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

  @override
  State<FabSelectBottomSheet<T>> createState() => _FabSelectBottomSheetState<T>();
}

class _FabSelectBottomSheetState<T> extends State<FabSelectBottomSheet<T>> {
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
    if (mounted) setState(() {});
  }

  void _showBottomSheet() {
    if (!widget.enabled) return;

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

  @override
  Widget build(BuildContext context) {
    final config = FabTextfieldTheme.getConfig(
      context: context,
      variant: widget.variant,
      size: widget.size,
      state: FabTextfieldState.defaultState,
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
                      vertical: 0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _selectedOption?.label ?? widget.hintText ?? '',
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
      ],
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
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: FabColors.greyscale500,
                  ),
                  size: FabTextfieldSize.medium,
                  variant: FabTextfieldVariant.primary,
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
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: FabColors.greyscale200,
                    ),
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected = option == widget.selectedOption;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 8,
                        ),
                        leading: option.icon,
                        title: Text(
                          option.label,
                          style: FabTypography.body.copyWith(
                            color: isSelected 
                                ? FabColors.primary 
                                : FabColors.greyscale700,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                CupertinoIcons.checkmark,
                                color: FabColors.primary,
                                size: 20,
                              )
                            : null,
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