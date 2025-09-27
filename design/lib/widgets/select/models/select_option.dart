import 'package:flutter/material.dart';

/// Model class untuk opsi dalam FabSelectBottomSheet
class SelectOption<T> {
  const SelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// Nilai yang akan dikembalikan ketika opsi dipilih
  final T value;
  
  /// Label yang ditampilkan kepada user
  final String label;
  
  /// Icon opsional (bisa berupa Widget untuk flag negara, dll)
  final Widget? icon;
  
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