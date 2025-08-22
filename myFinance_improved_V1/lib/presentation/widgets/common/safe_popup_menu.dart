import 'package:flutter/material.dart';

/// A safe wrapper for PopupMenuButton that handles widget lifecycle properly
/// Prevents "disposed widget trying to access inherited widgets" errors
class SafePopupMenuButton<T> extends StatelessWidget {
  const SafePopupMenuButton({
    super.key,
    required this.onSelected,
    required this.itemBuilder,
    this.icon,
    this.offset = Offset.zero,
    this.shape,
    this.color,
    this.elevation,
    this.enabled = true,
    this.child,
  });

  final void Function(T value) onSelected;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final Widget? icon;
  final Offset offset;
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;
  final bool enabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: enabled,
      icon: icon,
      offset: offset,
      shape: shape,
      color: color,
      elevation: elevation,
      child: child,
      onSelected: (T value) {
        // Add lifecycle safety check
        if (context.mounted) {
          onSelected(value);
        }
      },
      itemBuilder: (BuildContext context) {
        // Only build menu items if context is still mounted
        if (!context.mounted) {
          return <PopupMenuEntry<T>>[];
        }
        return itemBuilder(context);
      },
    );
  }
}

/// Safe PopupMenuItem that checks context before executing callbacks
class SafePopupMenuItem<T> extends PopupMenuItem<T> {
  const SafePopupMenuItem({
    super.key,
    super.value,
    super.onTap,
    super.enabled,
    super.height,
    super.padding,
    super.textStyle,
    super.mouseCursor,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<T>(
      key: key,
      value: value,
      enabled: enabled,
      height: height,
      padding: padding,
      textStyle: textStyle,
      mouseCursor: mouseCursor,
      onTap: onTap != null 
          ? () {
              // Add lifecycle safety check
              if (context.mounted) {
                onTap!();
              }
            }
          : null,
      child: child,
    );
  }
}

/// Extension method to make PopupMenuButton calls safer
extension SafePopupMenuExtension on BuildContext {
  /// Show a popup menu with lifecycle safety
  Future<T?> showSafePopupMenu<T>({
    required RelativeRect position,
    required List<PopupMenuEntry<T>> items,
    T? initialValue,
    double? elevation,
    String? semanticLabel,
    ShapeBorder? shape,
    Color? color,
    bool useRootNavigator = false,
  }) async {
    if (!mounted) return null;
    
    return showMenu<T>(
      context: this,
      position: position,
      items: items,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: semanticLabel,
      shape: shape,
      color: color,
      useRootNavigator: useRootNavigator,
    );
  }
}