import 'package:flutter/material.dart';

/// Model class untuk opsi dalam FabSelectBottomSheet
class SelectOption<T> {
  const SelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.subtitle,
    this.trailing,
    this.customBuilder,
    this.enabled = true,
  });

  /// Nilai yang akan dikembalikan ketika opsi dipilih
  final T value;

  /// Label yang ditampilkan kepada user
  final String label;

  /// Icon opsional (bisa berupa Widget untuk flag negara, avatar, dll)
  final Widget? icon;

  /// Subtitle/description opsional yang ditampilkan di bawah label
  final String? subtitle;

  /// Widget opsional yang ditampilkan di trailing (sebelah kanan)
  /// Contoh: rating, badge, dll
  final Widget? trailing;

  /// Custom builder untuk layout yang lebih kompleks
  /// Jika diset, akan override layout default
  /// Parameters: (context, isSelected, option)
  final Widget Function(BuildContext context, bool isSelected)? customBuilder;

  /// Apakah opsi ini bisa dipilih
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectOption &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'SelectOption(value: $value, label: $label)';
}