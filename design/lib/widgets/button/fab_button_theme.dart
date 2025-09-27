import 'package:flutter/material.dart';
import '../../design.dart';
import 'fab_button_types.dart';

/// Helper class untuk mendapatkan konfigurasi button berdasarkan variant dan state
class FabButtonTheme {
  FabButtonTheme._();

  /// Mendapatkan konfigurasi button berdasarkan variant, size, dan state
  static FabButtonConfig getConfig({
    required BuildContext context,
    required FabButtonVariant variant,
    required FabButtonSize size,
    FabButtonState state = FabButtonState.defaultState,
    bool isIconOnly = false,
  }) {
    final theme = context.fabTheme;
    
    // Base configuration berdasarkan size
    final baseConfig = _getBaseConfig(size, isIconOnly, theme);
    
    // Apply variant styling
    final variantConfig = _applyVariantStyling(baseConfig, variant, theme);
    
    // Apply state modifications
    return _applyStateStyling(variantConfig, state, variant);
  }

  /// Mendapatkan konfigurasi dasar berdasarkan size
  static FabButtonConfig _getBaseConfig(
    FabButtonSize size,
    bool isIconOnly,
    FabTheme theme,
  ) {
    // For icon-only buttons, use full rounded (circular) shape
    final borderRadius = isIconOnly 
        ? BorderRadius.circular(size.height / 2) 
        : BorderRadius.circular(10.0);
    
    return FabButtonConfig(
      backgroundColor: Colors.transparent,
      foregroundColor: theme.onBackgroundColor,
      borderColor: Colors.transparent,
      borderWidth: 0,
      padding: isIconOnly ? size.iconOnlyPadding : size.padding,
      height: size.height,
      textStyle: _getTextStyleForSize(size, theme),
      borderRadius: borderRadius,
    );
  }

  /// Mendapatkan text style berdasarkan size
  static TextStyle _getTextStyleForSize(FabButtonSize size, FabTheme theme) {
    switch (size) {
      case FabButtonSize.large:
        return FabTypography.displayMedium16;
      case FabButtonSize.medium:
        return FabTypography.displayMedium16;
      case FabButtonSize.small:
        return FabTypography.displayMedium14;
      case FabButtonSize.xsmall:
        return FabTypography.displayMedium12;
    }
  }

  /// Apply styling berdasarkan variant
  static FabButtonConfig _applyVariantStyling(
    FabButtonConfig baseConfig,
    FabButtonVariant variant,
    FabTheme theme,
  ) {
    switch (variant) {
      case FabButtonVariant.primary:
        return baseConfig.copyWith(
          backgroundColor: FabColors.primary,
          foregroundColor: FabColors.greyscale0,
          borderColor: FabColors.primary,
          borderWidth: 0,
        );

      case FabButtonVariant.secondary:
        return baseConfig.copyWith(
          backgroundColor: FabColors.greyscale0,
          foregroundColor: FabColors.greyscale700,
          borderColor: FabColors.greyscale100,
          borderWidth: 1.5,
        );

      case FabButtonVariant.tertiary:
        return baseConfig.copyWith(
          backgroundColor: Colors.transparent,
          foregroundColor: FabColors.greyscale700,
          borderColor: Colors.transparent,
          borderWidth: 0,
        );

      case FabButtonVariant.destructive:
        return baseConfig.copyWith(
          backgroundColor: FabColors.error,
          foregroundColor: FabColors.greyscale0,
          borderColor: FabColors.error,
          borderWidth: 0,
        );
    }
  }

  /// Apply styling berdasarkan state
  static FabButtonConfig _applyStateStyling(
    FabButtonConfig config,
    FabButtonState state,
    FabButtonVariant variant,
  ) {
    switch (state) {
      case FabButtonState.defaultState:
        return config;

      case FabButtonState.hover:
        return _applyHoverState(config, variant);

      case FabButtonState.focus:
        return _applyFocusState(config, variant);

      case FabButtonState.disabled:
        return _applyDisabledState(config);

      case FabButtonState.loading:
        return config; // Loading state handled in widget
    }
  }

  /// Apply hover state styling
  static FabButtonConfig _applyHoverState(
    FabButtonConfig config,
    FabButtonVariant variant,
  ) {
    switch (variant) {
      case FabButtonVariant.primary:
        return config.copyWith(
          backgroundColor: FabColors.primary300, // Darker primary for better hover feedback
          elevation: 2.0, // Subtle elevation for hover state
        );

      case FabButtonVariant.secondary:
        return config.copyWith(
          backgroundColor: FabColors.primary25, // Light primary background
        );

      case FabButtonVariant.tertiary:
        return config.copyWith(
          backgroundColor: FabColors.primary25, // Light primary background
        );

      case FabButtonVariant.destructive:
        return config.copyWith(
          backgroundColor: FabColors.error300, // Darker error
        );
    }
  }

  /// Apply focus state styling
  static FabButtonConfig _applyFocusState(
    FabButtonConfig config,
    FabButtonVariant variant,
  ) {
    return config.copyWith(
      shadowColor: variant == FabButtonVariant.primary || variant == FabButtonVariant.destructive
          ? config.backgroundColor.withOpacity(0.4)
          : FabColors.primary.withOpacity(0.4),
      elevation: 6.0, // More prominent focus indication
    );
  }

  /// Apply disabled state styling
  static FabButtonConfig _applyDisabledState(FabButtonConfig config) {
    // For primary buttons, use primary50 for disabled state
    Color disabledBgColor = FabColors.primary50;
    Color disabledTextColor = FabColors.greyscale0;
    
    // For other variants, use greyscale
    if (config.backgroundColor == Colors.transparent) {
      disabledBgColor = Colors.transparent;
    } else if (config.backgroundColor != FabColors.primary && 
               config.backgroundColor != FabColors.primary200) {
      disabledBgColor = FabColors.greyscale100;
      disabledTextColor = FabColors.greyscale400;
    }
    
    return config.copyWith(
      backgroundColor: disabledBgColor,
      foregroundColor: disabledTextColor,
      borderColor: config.borderColor == Colors.transparent
          ? Colors.transparent
          : disabledBgColor,
      elevation: 0.0,
      shadowColor: Colors.transparent,
    );
  }

  /// Mendapatkan warna untuk loading indicator
  static Color getLoadingIndicatorColor(
    FabButtonVariant variant,
    FabButtonState state,
  ) {
    if (state == FabButtonState.disabled) {
      return FabColors.disabledText;
    }

    switch (variant) {
      case FabButtonVariant.primary:
      case FabButtonVariant.destructive:
        return FabColors.greyscale0;
      case FabButtonVariant.secondary:
      case FabButtonVariant.tertiary:
        return FabColors.primary;
    }
  }

  /// Mendapatkan ukuran loading indicator berdasarkan size
  static double getLoadingIndicatorSize(FabButtonSize size) {
    switch (size) {
      case FabButtonSize.large:
        return 20.0;
      case FabButtonSize.medium:
        return 18.0;
      case FabButtonSize.small:
        return 16.0;
      case FabButtonSize.xsmall:
        return 14.0;
    }
  }
}