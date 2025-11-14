import 'package:deps/features/features.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:deps/design/design.dart';

/// FabCardForm v3 — Form card fleksibel dengan mode edit dan summary interaktif.
///
/// Didesain agar kompatibel dengan struktur seperti di `add_event_3.page.dart`.
/// - Bisa menampilkan summary yang bisa diklik untuk mengedit (via callback).
/// - Bisa menyimpan data lewat ReactiveForms.
/// - Masing-masing form mandiri dan bisa disesuaikan field-nya.
class FabCardForm extends StatefulWidget {
  final String? title;
  final FormGroup form;

  /// Fungsi untuk membangun field form (mode edit)
  final List<Widget> Function(FormGroup form) buildFields;

  /// Fungsi opsional untuk membangun summary card custom (mode view)
  final Widget Function(FormGroup form)? buildSummary;

  /// Callback ketika user klik "Save"
  final ValueChanged<FormGroup>? onSaved;

  /// Callback ketika user klik "Delete"
  final VoidCallback? onDelete;

  /// Callback ketika summary card diklik untuk mengedit kembali
  final VoidCallback? onEdit;

  const FabCardForm({
    super.key,
    this.title,
    required this.form,
    required this.buildFields,
    this.buildSummary,
    this.onSaved,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<FabCardForm> createState() => _FabCardFormState();
}

class _FabCardFormState extends State<FabCardForm> {
  bool isEditing = true;

  void _save() {
    if (widget.form.valid) {
      widget.onSaved?.call(widget.form);
      setState(() => isEditing = false);
    } else {
      widget.form.markAllAsTouched();
    }
  }

  void _edit() {
    setState(() => isEditing = true);
    widget.onEdit?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: FabCard(
        color: FabColors.greyscale0,
        border: Border.all(color: FabColors.greyscale200),
        pressedOpacity: 1,
        radius: 12,
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isEditing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _buildForm(context),
          secondChild: _buildSummaryCard(context),
        ),
      ),
    );
  }

  /// === Mode Form ===
  Widget _buildForm(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.form,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: FabTypography.bodySmallBold.copyWith(
                  color: FabColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
            ],

            ...widget.buildFields(widget.form),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onDelete != null)
                  TextButton(
                    onPressed: widget.onDelete,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                PaddingGap.sm(),
                FabButton.primary(
                  onPressed: _save,
                  size: FabButtonSize.medium,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// === Mode Summary ===
  Widget _buildSummaryCard(BuildContext context) {
    return GestureDetector(
      onTap: _edit,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: FabTypography.bodySmallBold.copyWith(
                  color: FabColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
            ],

            widget.buildSummary != null
                ? widget.buildSummary!(widget.form)
                : _defaultSummary(widget.form),
          ],
        ),
      ),
    );
  }

  /// Summary default jika developer tidak membuat custom builder
  Widget _defaultSummary(FormGroup form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: form.controls.entries.map((entry) {
        final value = entry.value.value?.toString() ?? '-';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            '${entry.key}: $value',
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale700,
            ),
          ),
        );
      }).toList(),
    );
  }
}
