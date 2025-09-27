import 'package:deps/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../design.dart';
import 'fab_button_types.dart';
import 'fab_button_theme.dart';

class FabButton extends StatefulWidget {
  /// Constructor utama untuk FabButton dengan konfigurasi manual
  const FabButton({
    required this.child,
    required this.variant,
    this.size = FabButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isIconOnly = false,
    this.icon,
    this.iconWidget,
    this.outerPadding = EdgeInsets.zero,
    this.width,
    super.key,
  });

  /// Legacy constructor untuk kompatibilitas mundur
  @Deprecated('Use FabButton.primary(), FabButton.secondary(), etc. instead')
  const FabButton.legacy({
    required this.child,
    this.onPressed,
    this.width,
    super.key,
    // Legacy parameters yang tidak lagi didukung:
    // height, color, borderRadius, innerPadding, pressedOpacity
    // Gunakan FabButton.primary(), secondary(), dll. untuk konfigurasi penuh
  }) : variant = FabButtonVariant.primary,
       size = FabButtonSize.medium,
       isLoading = false,
       isIconOnly = false,
       icon = null,
       iconWidget = null,
       outerPadding = EdgeInsets.zero;

  /// Primary button constructor
  const FabButton.primary({
    required this.child,
    this.size = FabButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isIconOnly = false,
    this.icon,
    this.iconWidget,
    this.outerPadding = EdgeInsets.zero,
    this.width,
    super.key,
  }) : variant = FabButtonVariant.primary;

  /// Secondary button constructor
  const FabButton.secondary({
    required this.child,
    this.size = FabButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isIconOnly = false,
    this.icon,
    this.iconWidget,
    this.outerPadding = EdgeInsets.zero,
    this.width,
    super.key,
  }) : variant = FabButtonVariant.secondary;

  /// Tertiary button constructor
  const FabButton.tertiary({
    required this.child,
    this.size = FabButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isIconOnly = false,
    this.icon,
    this.iconWidget,
    this.outerPadding = EdgeInsets.zero,
    this.width,
    super.key,
  }) : variant = FabButtonVariant.tertiary;

  /// Destructive button constructor
  const FabButton.destructive({
    required this.child,
    this.size = FabButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.isIconOnly = false,
    this.icon,
    this.iconWidget,
    this.outerPadding = EdgeInsets.zero,
    this.width,
    super.key,
  }) : variant = FabButtonVariant.destructive;

  final Widget child;
  final FabButtonVariant variant;
  final FabButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isIconOnly;
  final IconData? icon;
  final Widget? iconWidget;
  final EdgeInsetsGeometry outerPadding;
  final double? width;

  @override
  State<FabButton> createState() => _FabButtonState();
}

class _FabButtonState extends State<FabButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  FabButtonState get _currentState {
    if (widget.isLoading) return FabButtonState.loading;
    if (widget.onPressed == null) return FabButtonState.disabled;
    if (_isFocused) return FabButtonState.focus;
    if (_isHovered) return FabButtonState.hover;
    return FabButtonState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final config = FabButtonTheme.getConfig(
      context: context,
      variant: widget.variant,
      size: widget.size,
      state: _currentState,
      isIconOnly: widget.isIconOnly,
    );

    return Padding(
      padding: widget.outerPadding,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: AnimatedContainer(
            duration: $.timings.mil200,
            width: widget.isIconOnly ? config.height : widget.width,
            height: config.height,
            decoration: BoxDecoration(
              color: config.backgroundColor,
              border: config.borderWidth > 0
                  ? Border.all(
                      color: config.borderColor,
                      width: config.borderWidth,
                    )
                  : null,
              borderRadius: config.borderRadius,
              boxShadow: config.elevation > 0 && config.shadowColor != null
                  ? [
                      BoxShadow(
                        color: config.shadowColor!,
                        blurRadius: config.elevation * 2,
                        offset: Offset(0, config.elevation),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onPressed,
                borderRadius: config.borderRadius,
                child: Container(
                  padding: config.padding,
                  child: _buildButtonContent(config),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(FabButtonConfig config) {
    if (widget.isLoading) {
      return _buildLoadingContent(config);
    }

    if (widget.isIconOnly) {
      return _buildIconOnlyContent(config);
    }

    if (widget.icon != null) {
      return _buildIconWithTextContent(config);
    }

    return _buildTextOnlyContent(config);
  }

  Widget _buildLoadingContent(FabButtonConfig config) {
    final indicatorColor = FabButtonTheme.getLoadingIndicatorColor(
      widget.variant,
      _currentState,
    );
    final indicatorSize = FabButtonTheme.getLoadingIndicatorSize(widget.size);

    if (widget.isIconOnly) {
      return SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
        SizedBox(width: widget.size.iconSpacing),
        DefaultTextStyle(
          style: config.textStyle.copyWith(color: config.foregroundColor),
          child: widget.child,
        ),
      ],
    );
  }

  Widget _buildIconOnlyContent(FabButtonConfig config) {
    // Prioritize iconWidget (for SVG assets) over icon (for IconData)
    if (widget.iconWidget != null) {
      return widget.iconWidget!;
    }
    
    return Icon(
      widget.icon,
      size: widget.size.iconSize,
      color: config.foregroundColor,
    );
  }

  Widget _buildIconWithTextContent(FabButtonConfig config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prioritize iconWidget (for SVG assets) over icon (for IconData)
        widget.iconWidget ?? Icon(
          widget.icon,
          size: widget.size.iconSize,
          color: config.foregroundColor,
        ),
        SizedBox(width: widget.size.iconSpacing),
        DefaultTextStyle(
          style: config.textStyle.copyWith(color: config.foregroundColor),
          child: widget.child,
        ),
      ],
    );
  }

  Widget _buildTextOnlyContent(FabButtonConfig config) {
    return DefaultTextStyle(
      style: config.textStyle.copyWith(color: config.foregroundColor),
      textAlign: TextAlign.center,
      child: widget.child,
    );
  }
}
