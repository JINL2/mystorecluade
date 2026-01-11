import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Icon button variants following Toss Design System
enum TossIconButtonVariant {
  /// Filled background (primary color)
  filled,

  /// Outlined with border
  outlined,

  /// Ghost - transparent background, shows on hover/press
  ghost,

  /// Danger - red filled for destructive actions
  danger,
}

/// Icon button sizes
enum TossIconButtonSize {
  /// Small: 32x32, icon 16px
  small,

  /// Medium: 40x40, icon 20px (default)
  medium,

  /// Large: 48x48, icon 24px
  large,
}

/// Toss-style icon button for icon-only actions
///
/// Common use cases:
/// - Back/close buttons in app bars
/// - Action buttons (edit, delete, share)
/// - Toggle buttons (favorite, bookmark)
/// - Navigation arrows
///
/// Example:
/// ```dart
/// TossIconButton(
///   icon: Icons.arrow_back,
///   onPressed: () => Navigator.pop(context),
/// )
///
/// TossIconButton.filled(
///   icon: Icons.add,
///   onPressed: () {},
/// )
///
/// TossIconButton.outlined(
///   icon: Icons.edit,
///   onPressed: () {},
/// )
/// ```
class TossIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final TossIconButtonVariant variant;
  final TossIconButtonSize size;
  final bool isEnabled;
  final String? tooltip;

  // Customizable colors
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;

  // Customizable dimensions
  final double? iconSize;
  final double? buttonSize;
  final double? borderRadius;

  const TossIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = TossIconButtonVariant.ghost,
    this.size = TossIconButtonSize.medium,
    this.isEnabled = true,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.iconSize,
    this.buttonSize,
    this.borderRadius,
  });

  /// Filled icon button (primary background)
  factory TossIconButton.filled({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    TossIconButtonSize size = TossIconButtonSize.medium,
    bool isEnabled = true,
    String? tooltip,
    Color? backgroundColor,
    Color? iconColor,
    double? iconSize,
    double? buttonSize,
    double? borderRadius,
  }) {
    return TossIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: TossIconButtonVariant.filled,
      size: size,
      isEnabled: isEnabled,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      iconSize: iconSize,
      buttonSize: buttonSize,
      borderRadius: borderRadius,
    );
  }

  /// Outlined icon button (border only)
  factory TossIconButton.outlined({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    TossIconButtonSize size = TossIconButtonSize.medium,
    bool isEnabled = true,
    String? tooltip,
    Color? borderColor,
    Color? iconColor,
    double? iconSize,
    double? buttonSize,
    double? borderRadius,
  }) {
    return TossIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: TossIconButtonVariant.outlined,
      size: size,
      isEnabled: isEnabled,
      tooltip: tooltip,
      borderColor: borderColor,
      iconColor: iconColor,
      iconSize: iconSize,
      buttonSize: buttonSize,
      borderRadius: borderRadius,
    );
  }

  /// Ghost icon button (transparent, default)
  factory TossIconButton.ghost({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    TossIconButtonSize size = TossIconButtonSize.medium,
    bool isEnabled = true,
    String? tooltip,
    Color? iconColor,
    double? iconSize,
    double? buttonSize,
    double? borderRadius,
  }) {
    return TossIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: TossIconButtonVariant.ghost,
      size: size,
      isEnabled: isEnabled,
      tooltip: tooltip,
      iconColor: iconColor,
      iconSize: iconSize,
      buttonSize: buttonSize,
      borderRadius: borderRadius,
    );
  }

  /// Danger icon button (red, for destructive actions)
  factory TossIconButton.danger({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    TossIconButtonSize size = TossIconButtonSize.medium,
    bool isEnabled = true,
    String? tooltip,
    double? iconSize,
    double? buttonSize,
    double? borderRadius,
  }) {
    return TossIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: TossIconButtonVariant.danger,
      size: size,
      isEnabled: isEnabled,
      tooltip: tooltip,
      iconSize: iconSize,
      buttonSize: buttonSize,
      borderRadius: borderRadius,
    );
  }

  double get _defaultButtonSize {
    switch (size) {
      case TossIconButtonSize.small:
        return 32;
      case TossIconButtonSize.medium:
        return 40;
      case TossIconButtonSize.large:
        return 48;
    }
  }

  double get _defaultIconSize {
    switch (size) {
      case TossIconButtonSize.small:
        return 16;
      case TossIconButtonSize.medium:
        return 20;
      case TossIconButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    if (!isEnabled) {
      return TossColors.gray100;
    }

    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case TossIconButtonVariant.filled:
        return TossColors.primary;
      case TossIconButtonVariant.danger:
        return TossColors.error;
      case TossIconButtonVariant.outlined:
      case TossIconButtonVariant.ghost:
        return TossColors.transparent;
    }
  }

  Color _getIconColor() {
    if (!isEnabled) {
      return TossColors.gray400;
    }

    if (iconColor != null) return iconColor!;

    switch (variant) {
      case TossIconButtonVariant.filled:
        return TossColors.white;
      case TossIconButtonVariant.danger:
        return TossColors.white;
      case TossIconButtonVariant.outlined:
        return TossColors.textPrimary;
      case TossIconButtonVariant.ghost:
        return TossColors.textPrimary;
    }
  }

  Color _getBorderColor() {
    if (!isEnabled) {
      return TossColors.gray200;
    }

    if (borderColor != null) return borderColor!;

    switch (variant) {
      case TossIconButtonVariant.outlined:
        return TossColors.gray200;
      case TossIconButtonVariant.filled:
      case TossIconButtonVariant.danger:
      case TossIconButtonVariant.ghost:
        return TossColors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveButtonSize = buttonSize ?? _defaultButtonSize;
    final effectiveIconSize = iconSize ?? _defaultIconSize;
    final effectiveBorderRadius = borderRadius ?? TossBorderRadius.md;

    final button = SizedBox(
      width: effectiveButtonSize,
      height: effectiveButtonSize,
      child: Material(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: _getBorderColor(),
                width: variant == TossIconButtonVariant.outlined ? 1 : 0,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: effectiveIconSize,
                color: _getIconColor(),
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
