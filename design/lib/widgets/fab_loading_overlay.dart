import 'package:flutter/material.dart';

import '../_core/constants/fab_colors.dart';

/// A full-screen loading overlay that can be shown/hidden programmatically.
///
/// This uses a modal overlay approach, so you don't need to wrap widgets.
/// Simply call [FabLoadingOverlay.show()] to display and [FabLoadingOverlay.hide()] to dismiss.
///
/// Example usage:
/// ```dart
/// // Show loading
/// FabLoadingOverlay.show(context);
///
/// // Do async work
/// await apiCall();
///
/// // Hide loading
/// FabLoadingOverlay.hide(context);
/// ```
class FabLoadingOverlay {
  FabLoadingOverlay._();

  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// Shows the loading overlay on top of everything.
  ///
  /// The [color] parameter defaults to [FabColors.overlay].
  /// The [indicatorColor] parameter sets the color of the spinner.
  /// The [message] parameter displays optional text below the spinner.
  static void show(
    BuildContext context, {
    Color color = FabColors.overlay,
    Color? indicatorColor,
    String? message,
  }) {
    if (_isShowing) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingOverlayWidget(
        color: color,
        indicatorColor: indicatorColor,
        message: message,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  /// Hides the loading overlay.
  static void hide(BuildContext context) {
    if (!_isShowing) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  /// Returns whether the overlay is currently showing.
  static bool get isShowing => _isShowing;
}

class _LoadingOverlayWidget extends StatelessWidget {
  const _LoadingOverlayWidget({
    required this.color,
    this.indicatorColor,
    this.message,
  });

  final Color color;
  final Color? indicatorColor;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: indicatorColor != null
                    ? AlwaysStoppedAnimation<Color>(indicatorColor!)
                    : null,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    message!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
