import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

/// A safe wrapper for PopupMenuButton that handles widget lifecycle properly
/// Prevents "disposed widget trying to access inherited widgets" errors
class SafePopupMenuButton<T> extends StatefulWidget {
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
  State<SafePopupMenuButton<T>> createState() => _SafePopupMenuButtonState<T>();
}

class _SafePopupMenuButtonState<T> extends State<SafePopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: widget.enabled,
      icon: widget.icon,
      offset: widget.offset,
      shape: widget.shape,
      color: widget.color,
      elevation: widget.elevation,
      child: widget.child,
      onSelected: (T value) async {
        // PopupMenuButton automatically closes the popup when an item is selected.
        // DO NOT call Navigator.pop() here - it will pop the entire page in GoRouter.

        // Use a small delay to ensure the popup is fully closed
        await Future<void>.delayed(TossAnimations.instant);

        // Check if widget is still mounted before calling onSelected
        if (mounted) {
          widget.onSelected(value);
        }
      },
      itemBuilder: (BuildContext popupContext) {
        // Check if the widget is still mounted
        if (!mounted) {
          return <PopupMenuEntry<T>>[];
        }
        
        // Build the menu items
        try {
          return widget.itemBuilder(popupContext);
        } catch (e) {
          // If there's an error building menu items, return empty list
          return <PopupMenuEntry<T>>[];
        }
      },
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