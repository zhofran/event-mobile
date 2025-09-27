import 'package:flutter/material.dart';
import '../../_core/constants/fab_colors.dart';
import '../../_core/constants/fab_typography.dart';
import 'fab_textfield_types.dart';

/// Theme class untuk FabTextfield yang mengikuti desain Figma
class FabTextfieldTheme {
  /// Mendapatkan konfigurasi textfield berdasarkan context, variant, size, dan state
  static FabTextfieldConfig getConfig({
    required BuildContext context,
    required FabTextfieldVariant variant,
    required FabTextfieldSize size,
    required FabTextfieldState state,
  }) {
    // Get base config
    final baseConfig = _getBaseConfig(size);
    
    // Apply variant styling
    final variantConfig = _applyVariantStyling(baseConfig, variant);
    
    // Apply state styling
    final finalConfig = _applyStateStyling(variantConfig, state, variant);
    
    return finalConfig;
  }

  /// Mendapatkan base configuration berdasarkan size
  static FabTextfieldConfig _getBaseConfig(FabTextfieldSize size) {
    return FabTextfieldConfig(
      backgroundColor: FabColors.background,
      borderColor: FabColors.border, // Border default yang terlihat
      borderWidth: 1.0, // Border width default
      borderRadius: BorderRadius.circular(12.0),
      textStyle: _getTextStyleForSize(size),
      hintStyle: _getHintStyleForSize(size),
      labelStyle: _getLabelStyleForSize(size),
      padding: size.padding,
      height: size.height,
      iconColor: FabColors.textSecondary,
      elevation: 0, // No shadow by default
    );
  }

  /// Mendapatkan text style berdasarkan size
  static TextStyle _getTextStyleForSize(FabTextfieldSize size) {
    switch (size) {
      case FabTextfieldSize.large:
        return FabTypography.regular(16.0).copyWith(
          color: FabColors.textPrimary,
        );
      case FabTextfieldSize.medium:
        return FabTypography.regular(14.0).copyWith(
          color: FabColors.textPrimary,
        );
      case FabTextfieldSize.small:
        return FabTypography.regular(12.0).copyWith(
          color: FabColors.textPrimary,
        );
    }
  }

  /// Mendapatkan hint style berdasarkan size
  static TextStyle _getHintStyleForSize(FabTextfieldSize size) {
    switch (size) {
      case FabTextfieldSize.large:
        return FabTypography.regular(16.0).copyWith(
          color: FabColors.textTertiary,
        );
      case FabTextfieldSize.medium:
        return FabTypography.regular(14.0).copyWith(
          color: FabColors.textTertiary,
        );
      case FabTextfieldSize.small:
        return FabTypography.regular(12.0).copyWith(
          color: FabColors.textTertiary,
        );
    }
  }

  /// Mendapatkan label style berdasarkan size
  static TextStyle _getLabelStyleForSize(FabTextfieldSize size) {
    switch (size) {
      case FabTextfieldSize.large:
        return FabTypography.medium(14.0).copyWith(
          color: FabColors.textSecondary,
        );
      case FabTextfieldSize.medium:
        return FabTypography.medium(12.0).copyWith(
          color: FabColors.textSecondary,
        );
      case FabTextfieldSize.small:
        return FabTypography.medium(10.0).copyWith(
          color: FabColors.textSecondary,
        );
    }
  }

  /// Apply styling berdasarkan variant
  static FabTextfieldConfig _applyVariantStyling(
    FabTextfieldConfig baseConfig,
    FabTextfieldVariant variant,
  ) {
    switch (variant) {
      case FabTextfieldVariant.primary:
        return baseConfig.copyWith(
          backgroundColor: FabColors.background,
          borderColor: FabColors.border,
        );

      case FabTextfieldVariant.secondary:
        return baseConfig.copyWith(
          backgroundColor: FabColors.backgroundSecondary,
          borderColor: FabColors.borderLight,
        );
    }
  }

  /// Apply styling berdasarkan state
  static FabTextfieldConfig _applyStateStyling(
    FabTextfieldConfig config,
    FabTextfieldState state,
    FabTextfieldVariant variant,
  ) {
    switch (state) {
      case FabTextfieldState.defaultState:
        return config;

      case FabTextfieldState.focused:
        return _applyFocusedState(config, variant);

      case FabTextfieldState.error:
        return _applyErrorState(config);

      case FabTextfieldState.disabled:
        return _applyDisabledState(config);
    }
  }

  /// Apply focused state styling (orange border seperti di Figma)
  static FabTextfieldConfig _applyFocusedState(
    FabTextfieldConfig config,
    FabTextfieldVariant variant,
  ) {
    return config.copyWith(
      borderColor: FabColors.primary, // Orange border bold saat focused
      borderWidth: 2.0, // Border lebih tebal saat focused
      shadowColor: FabColors.primary.withOpacity(0.4), // Shadow untuk border bold
      outlineColor: FabColors.primary.withOpacity(0.15), // Outline soft orange
      elevation: 1.0, // Aktifkan shadow effect
    );
  }

  /// Apply error state styling (red border seperti di Figma)
  static FabTextfieldConfig _applyErrorState(FabTextfieldConfig config) {
    return config.copyWith(
      borderColor: FabColors.error, // Red border bold saat error
      borderWidth: 2.0, // Border lebih tebal saat error
      shadowColor: FabColors.error.withOpacity(0.4), // Shadow untuk border bold
      outlineColor: FabColors.error.withOpacity(0.15), // Outline soft merah
      elevation: 1.0, // Aktifkan shadow effect
    );
  }

  /// Apply disabled state styling
  static FabTextfieldConfig _applyDisabledState(FabTextfieldConfig config) {
    return config.copyWith(
      backgroundColor: FabColors.backgroundTertiary,
      borderColor: FabColors.disabled,
      textStyle: config.textStyle.copyWith(color: FabColors.disabledText),
      hintStyle: config.hintStyle.copyWith(color: FabColors.disabled),
      iconColor: FabColors.disabled,
    );
  }

  /// Mendapatkan warna untuk error text
  static Color getErrorTextColor() {
    return FabColors.error;
  }

  /// Mendapatkan style untuk error text
  static TextStyle getErrorTextStyle(FabTextfieldSize size) {
    switch (size) {
      case FabTextfieldSize.large:
        return FabTypography.regular(12.0).copyWith(
          color: FabColors.error,
        );
      case FabTextfieldSize.medium:
        return FabTypography.regular(11.0).copyWith(
          color: FabColors.error,
        );
      case FabTextfieldSize.small:
        return FabTypography.regular(10.0).copyWith(
          color: FabColors.error,
        );
    }
  }
}