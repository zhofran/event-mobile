import 'package:flutter/material.dart';

/// Enum untuk variant button
enum FabButtonVariant {
  /// Primary button dengan background warna utama
  primary,
  
  /// Secondary button dengan border dan background transparan
  secondary,
  
  /// Tertiary button dengan text only, tanpa background
  tertiary,
  
  /// Destructive button untuk aksi berbahaya
  destructive,
}

/// Enum untuk ukuran button
enum FabButtonSize {
  /// Large button - tinggi 56px
  large,
  
  /// Medium button - tinggi 48px (default)
  medium,
  
  /// Small button - tinggi 40px
  small,
  
  /// Extra small button - tinggi 32px
  xsmall,
}

/// Enum untuk state button
enum FabButtonState {
  /// Default state - normal appearance
  defaultState,
  
  /// Hover state - saat di-hover
  hover,
  
  /// Focus state - saat focused
  focus,
  
  /// Disabled state - tidak aktif
  disabled,
  
  /// Loading state - menampilkan loading indicator
  loading,
}

/// Configuration class untuk styling button berdasarkan variant dan state
class FabButtonConfig {
  const FabButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.height,
    required this.textStyle,
    required this.borderRadius,
    this.shadowColor,
    this.elevation = 0,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double height;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
  final Color? shadowColor;
  final double elevation;

  /// Copy with method untuk membuat variasi config
  FabButtonConfig copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    EdgeInsets? padding,
    double? height,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    Color? shadowColor,
    double? elevation,
  }) {
    return FabButtonConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
    );
  }
}

/// Extension untuk mendapatkan konfigurasi berdasarkan size
extension FabButtonSizeExtension on FabButtonSize {
  /// Mendapatkan tinggi button berdasarkan size
  double get height {
    switch (this) {
      case FabButtonSize.large:
        return 56.0;
      case FabButtonSize.medium:
        return 48.0;
      case FabButtonSize.small:
        return 40.0;
      case FabButtonSize.xsmall:
        return 32.0;
    }
  }

  /// Mendapatkan horizontal padding berdasarkan size
  EdgeInsets get padding {
    switch (this) {
      case FabButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
      case FabButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
      case FabButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0);
      case FabButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0);
    }
  }

  /// Mendapatkan padding untuk icon-only button (square)
  EdgeInsets get iconOnlyPadding {
    switch (this) {
      case FabButtonSize.large:
        return const EdgeInsets.all(16.0);
      case FabButtonSize.medium:
        return const EdgeInsets.all(12.0);
      case FabButtonSize.small:
        return const EdgeInsets.all(8.0);
      case FabButtonSize.xsmall:
        return const EdgeInsets.all(6.0);
    }
  }

  /// Mendapatkan ukuran icon berdasarkan size
  double get iconSize {
    switch (this) {
      case FabButtonSize.large:
        return 24.0;
      case FabButtonSize.medium:
        return 20.0;
      case FabButtonSize.small:
        return 18.0;
      case FabButtonSize.xsmall:
        return 16.0;
    }
  }

  /// Mendapatkan spacing antara icon dan text
  double get iconSpacing {
    switch (this) {
      case FabButtonSize.large:
        return 12.0;
      case FabButtonSize.medium:
        return 8.0;
      case FabButtonSize.small:
        return 6.0;
      case FabButtonSize.xsmall:
        return 4.0;
    }
  }
}