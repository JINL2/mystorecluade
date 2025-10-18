import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

/// Toss Design System - Icon Button
/// 
/// A consistent icon button implementation following Toss design patterns.
/// Replaces Flutter's IconButton with better defaults and consistency.
/// 
/// Example:
/// ```dart
/// TossIconButton(
///   icon: Icons.close,
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class TossIconButton extends StatelessWidget {
  const TossIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.disabledColor,
    this.size,
    this.tooltip,
    this.padding,
    this.splashRadius,
    this.backgroundColor,
    this.borderRadius,
    this.isEnabled = true,
    this.autofocus = false,
    this.enableFeedback = true,
  });

  /// The icon to display
  final IconData icon;

  /// Callback when button is pressed
  /// If null, button is disabled
  final VoidCallback? onPressed;

  /// Icon color when enabled
  /// Defaults to TossColors.textPrimary
  final Color? color;

  /// Icon color when disabled
  /// Defaults to TossColors.gray400
  final Color? disabledColor;

  /// Size of the icon
  /// Defaults to 24.0
  final double? size;

  /// Tooltip text for accessibility
  final String? tooltip;

  /// Padding around the icon
  /// Defaults to EdgeInsets.all(8.0)
  final EdgeInsetsGeometry? padding;

  /// Custom splash radius
  /// Defaults to Material splash
  final double? splashRadius;

  /// Optional background color
  /// Usually null for standard icon buttons
  final Color? backgroundColor;

  /// Border radius if backgroundColor is set
  final BorderRadius? borderRadius;

  /// Whether the button is enabled
  /// Overrides onPressed null check
  final bool isEnabled;

  /// Whether button should autofocus
  final bool autofocus;

  /// Whether to provide haptic feedback
  final bool enableFeedback;

  /// Factory constructor for close button
  factory TossIconButton.close({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.close,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Close',
    );
  }

  /// Factory constructor for back button
  factory TossIconButton.back({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.arrow_back_ios,
      onPressed: onPressed,
      color: color ?? TossColors.textPrimary,
      tooltip: 'Back',
    );
  }

  /// Factory constructor for more/menu button
  factory TossIconButton.more({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.more_vert,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'More',
    );
  }

  /// Factory constructor for add button
  factory TossIconButton.add({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
    double? size,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.add,
      onPressed: onPressed,
      color: color ?? TossColors.primary,
      size: size,
      tooltip: 'Add',
    );
  }

  /// Factory constructor for delete button
  factory TossIconButton.delete({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.delete_outline,
      onPressed: onPressed,
      color: color ?? TossColors.error,
      tooltip: 'Delete',
    );
  }

  /// Factory constructor for edit button
  factory TossIconButton.edit({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.edit_outlined,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Edit',
    );
  }

  /// Factory constructor for settings button
  factory TossIconButton.settings({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.settings_outlined,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Settings',
    );
  }

  /// Factory constructor for refresh button
  factory TossIconButton.refresh({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.refresh,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Refresh',
    );
  }

  /// Factory constructor for share button
  factory TossIconButton.share({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.share_outlined,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Share',
    );
  }

  /// Factory constructor for filter button
  factory TossIconButton.filter({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
    bool isActive = false,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.filter_list,
      onPressed: onPressed,
      color: isActive ? TossColors.primary : (color ?? TossColors.textSecondary),
      tooltip: 'Filter',
    );
  }

  /// Factory constructor for search button
  factory TossIconButton.search({
    Key? key,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TossIconButton(
      key: key,
      icon: Icons.search,
      onPressed: onPressed,
      color: color ?? TossColors.textSecondary,
      tooltip: 'Search',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool effectivelyEnabled = isEnabled && onPressed != null;
    final Color effectiveColor = effectivelyEnabled
        ? (color ?? TossColors.textPrimary)
        : (disabledColor ?? TossColors.gray400);
    final double effectiveSize = size ?? 24.0;
    final EdgeInsetsGeometry effectivePadding = padding ?? EdgeInsets.all(TossSpacing.space2);

    // If backgroundColor is provided, wrap in a decorated container
    if (backgroundColor != null) {
      return Material(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(effectiveSize),
        child: InkWell(
          onTap: effectivelyEnabled ? onPressed : null,
          borderRadius: borderRadius ?? BorderRadius.circular(effectiveSize),
          child: Padding(
            padding: effectivePadding,
            child: Icon(
              icon,
              color: effectiveColor,
              size: effectiveSize,
            ),
          ),
        ),
      );
    }

    // Standard icon button
    final Widget iconButton = IconButton(
      icon: Icon(icon),
      iconSize: effectiveSize,
      color: effectiveColor,
      onPressed: effectivelyEnabled ? onPressed : null,
      padding: effectivePadding,
      splashRadius: splashRadius,
      autofocus: autofocus,
      enableFeedback: enableFeedback ?? true,
      tooltip: tooltip,
    );

    return iconButton;
  }

  /// Helper method to create from existing IconButton
  /// Useful for gradual migration
  static TossIconButton fromIconButton({
    required IconButton iconButton,
    IconData? iconData,
  }) {
    // Extract icon from IconButton's icon widget
    IconData? extractedIcon = iconData;
    if (iconButton.icon is Icon) {
      final iconWidget = iconButton.icon as Icon;
      extractedIcon = iconWidget.icon;
    }

    return TossIconButton(
      icon: extractedIcon ?? Icons.error,
      onPressed: iconButton.onPressed,
      color: iconButton.color,
      disabledColor: iconButton.disabledColor,
      size: iconButton.iconSize,
      tooltip: iconButton.tooltip,
      padding: iconButton.padding,
      splashRadius: iconButton.splashRadius,
      autofocus: iconButton.autofocus,
      enableFeedback: iconButton.enableFeedback ?? true,
    );
  }
}

/// Extension for easy migration
extension IconButtonMigration on IconButton {
  /// Convert IconButton to TossIconButton
  TossIconButton toTossIconButton() {
    IconData? iconData;
    if (icon is Icon) {
      iconData = (icon as Icon).icon;
    }
    
    return TossIconButton(
      icon: iconData ?? Icons.error,
      onPressed: onPressed,
      color: color,
      disabledColor: disabledColor,
      size: iconSize,
      tooltip: tooltip,
      padding: padding,
      splashRadius: splashRadius,
      autofocus: autofocus,
      enableFeedback: enableFeedback ?? true,
    );
  }
}