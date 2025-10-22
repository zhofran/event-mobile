import 'package:flutter/material.dart';

import 'models/select_option.dart';

/// Reusable bottom sheet widget
class FabMultiSelectBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<SelectOption<T>> options;
  final Set<T> initialSelected;
  final ValueChanged<Set<T>> onConfirm;

  /// Optional params
  final double height;
  final Color? primaryColor;
  final Color? backgroundColor;
  final String confirmText;

  const FabMultiSelectBottomSheet({
    Key? key,
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.onConfirm,
    this.height = 600,
    this.primaryColor,
    this.backgroundColor,
    this.confirmText = 'Continue',
  }) : super(key: key);

  @override
  State<FabMultiSelectBottomSheet<T>> createState() =>
      _FabMultiSelectBottomSheetState<T>();

  /// Static helper untuk menampilkan bottom sheet
  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    required List<SelectOption<T>> options,
    required Set<T> initialSelected,
    required ValueChanged<Set<T>> onConfirm,
    double height = 600,
    Color? primaryColor,
    Color? backgroundColor,
    String confirmText = 'Continue',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FabMultiSelectBottomSheet<T>(
        title: title,
        options: options,
        initialSelected: initialSelected,
        onConfirm: onConfirm,
        height: height,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        confirmText: confirmText,
      ),
    );
  }
}

class _FabMultiSelectBottomSheetState<T> extends State<FabMultiSelectBottomSheet<T>> {
  late Set<T> tempSelected;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    tempSelected = Set.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = widget.primaryColor ?? theme.colorScheme.primary;
    final background = widget.backgroundColor ?? theme.colorScheme.surface;

    final filtered = widget.options
        .where((opt) =>
            opt.label.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Search
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primary),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Selected Chips
            if (tempSelected.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: tempSelected.map((value) {
                  final label = widget.options
                          .firstWhere((opt) => opt.value == value)
                          .label;
                  return Chip(
                    label: Text(label),
                    onDeleted: () => setState(() => tempSelected.remove(value)),
                  );
                }).toList(),
              ),

            const SizedBox(height: 8),

            /// List
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final option = filtered[index];
                  final selected = tempSelected.contains(option.value);
                  return CheckboxListTile(
                    title: Text(option.label),
                    value: selected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          tempSelected.add(option.value);
                        } else {
                          tempSelected.remove(option.value);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: primary,
                  );
                },
              ),
            ),

            /// Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onConfirm(tempSelected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.confirmText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
