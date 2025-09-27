import 'package:flutter/material.dart';

/// Enum untuk state textfield
enum FabTextfieldState {
  defaultState,
  focused,
  error,
  disabled,
}

/// Enum untuk variant textfield
enum FabTextfieldVariant {
  primary,
  secondary,
}

/// Enum untuk size textfield
enum FabTextfieldSize {
  large,
  medium,
  small,
}

/// Extension untuk FabTextfieldSize
extension FabTextfieldSizeExtension on FabTextfieldSize {
  double get height {
    switch (this) {
      case FabTextfieldSize.large:
        return 56.0;
      case FabTextfieldSize.medium:
        return 48.0;
      case FabTextfieldSize.small:
        return 40.0;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case FabTextfieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
      case FabTextfieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0);
      case FabTextfieldSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    }
  }

  double get fontSize {
    switch (this) {
      case FabTextfieldSize.large:
        return 16.0;
      case FabTextfieldSize.medium:
        return 14.0;
      case FabTextfieldSize.small:
        return 12.0;
    }
  }

  double get iconSize {
    switch (this) {
      case FabTextfieldSize.large:
        return 20.0;
      case FabTextfieldSize.medium:
        return 18.0;
      case FabTextfieldSize.small:
        return 16.0;
    }
  }
}

/// Configuration class untuk styling textfield berdasarkan variant dan state
class FabTextfieldConfig {
  const FabTextfieldConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.textStyle,
    required this.hintStyle,
    required this.labelStyle,
    required this.padding,
    required this.height,
    required this.iconColor,
    this.shadowColor,
    this.outlineColor, // Warna outline yang terpisah dari border
    this.elevation = 0,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final EdgeInsets padding;
  final double height;
  final Color iconColor;
  final Color? shadowColor;
  final Color? outlineColor; // Warna outline yang terpisah dari border
  final double elevation;

  /// Copy with method untuk membuat variasi config
  FabTextfieldConfig copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
    double? height,
    Color? iconColor,
    Color? shadowColor,
    Color? outlineColor,
    double? elevation,
  }) {
    return FabTextfieldConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      iconColor: iconColor ?? this.iconColor,
      shadowColor: shadowColor ?? this.shadowColor,
      outlineColor: outlineColor ?? this.outlineColor,
      elevation: elevation ?? this.elevation,
    );
  }
}