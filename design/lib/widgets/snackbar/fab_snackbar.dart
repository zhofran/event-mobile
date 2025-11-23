import 'package:flutter/material.dart';

import '../../design.dart';

/// Enum for snackbar types
enum FabSnackbarType {
  success,
  error,
  info,
  warning,
}

/// Reusable snackbar component with predefined styles
///
/// Example usage:
/// ```dart
/// // Success snackbar
/// FabSnackbar.success(
///   context: context,
///   content: 'Data saved successfully!',
/// );
///
/// // Error snackbar
/// FabSnackbar.error(
///   context: context,
///   content: 'Please fill all required fields',
/// );
///
/// // Info snackbar
/// FabSnackbar.info(
///   context: context,
///   content: 'Processing your request...',
/// );
///
/// // Warning snackbar
/// FabSnackbar.warning(
///   context: context,
///   content: 'This action cannot be undone',
/// );
///
/// // Custom duration
/// FabSnackbar.success(
///   context: context,
///   content: 'Quick message',
///   duration: Duration(seconds: 1),
/// );
/// ```
class FabSnackbar {
  /// Private constructor to prevent instantiation
  FabSnackbar._();

  /// Show a snackbar with the specified type and content
  static void show({
    required BuildContext context,
    required String content,
    FabSnackbarType type = FabSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: FabTextStyled(
            content,
            style: FabTypography.bodySmallMedium.copyWith(
              color: FabColors.greyscale0,
            ),
          ),
          backgroundColor: _getBackgroundColor(type),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: duration,
        ),
      );
  }

  /// Show a success snackbar
  static void success({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      content: content,
      type: FabSnackbarType.success,
      duration: duration,
    );
  }

  /// Show an error snackbar
  static void error({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      content: content,
      type: FabSnackbarType.error,
      duration: duration,
    );
  }

  /// Show an info snackbar
  static void info({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      content: content,
      type: FabSnackbarType.info,
      duration: duration,
    );
  }

  /// Show a warning snackbar
  static void warning({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      content: content,
      type: FabSnackbarType.warning,
      duration: duration,
    );
  }

  /// Get background color based on snackbar type
  static Color _getBackgroundColor(FabSnackbarType type) {
    switch (type) {
      case FabSnackbarType.success:
        return FabColors.success;
      case FabSnackbarType.error:
        return FabColors.error;
      case FabSnackbarType.info:
        return FabColors.primary;
      case FabSnackbarType.warning:
        return FabColors.warning;
    }
  }
}
