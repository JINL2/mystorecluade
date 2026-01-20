import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';

/// A minimal bottom sheet wrapper molecule that provides only:
/// - The Surface (where content goes)
/// - The Scrim (background overlay)
///
/// This is a pure wrapper with NO handle and NO title.
/// Use this when you need full control over the content layout.
///
/// ## 2026 UI/UX Design Principles Applied:
/// - **Minimal chrome**: No decorative elements, content-first approach
/// - **Smooth animations**: Uses TossAnimations for consistent motion
/// - **Gesture-driven**: Native drag-to-dismiss behavior
/// - **Keyboard-aware**: Automatically adjusts for keyboard
/// - **Safe area aware**: Respects device safe areas
///
/// ## Example Usage:
/// ```dart
/// BottomSheetWrapper.show(
///   context: context,
///   child: YourCustomContent(),
/// );
/// ```
///
/// Or use as a widget directly:
/// ```dart
/// BottomSheetWrapper(
///   child: Column(
///     children: [
///       // Your custom header
///       // Your content
///     ],
///   ),
/// )
/// ```
class BottomSheetWrapper extends StatelessWidget {
  /// The content to display inside the sheet
  final Widget child;

  /// Maximum height as a ratio of screen height (0.0 to 1.0)
  final double maxHeightRatio;

  /// Minimum height in logical pixels
  final double? minHeight;

  /// Whether the sheet should size itself to fit content
  final bool shrinkWrap;

  /// Custom padding for the content area
  final EdgeInsets? padding;

  /// Whether to add safe area padding at the bottom
  final bool useSafeArea;

  // Design tokens from existing theme
  static const double _defaultMaxHeightRatio = 0.9;
  static const double _defaultMinHeight = 100.0;

  const BottomSheetWrapper({
    super.key,
    required this.child,
    this.maxHeightRatio = _defaultMaxHeightRatio,
    this.minHeight,
    this.shrinkWrap = true,
    this.padding,
    this.useSafeArea = true,
  });

  /// Show the bottom sheet as a modal with scrim
  ///
  /// Returns the result from [Navigator.pop] if any
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double maxHeightRatio = _defaultMaxHeightRatio,
    double? minHeight,
    bool shrinkWrap = true,
    EdgeInsets? padding,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      // Transparent background - we handle decoration ourselves
      backgroundColor: TossColors.transparent,
      // Scrim color - the overlay behind the sheet
      barrierColor: barrierColor ?? TossColors.black54,
      // Allow sheet to be taller than half screen
      isScrollControlled: true,
      // User can tap scrim to dismiss
      isDismissible: isDismissible,
      // User can drag to dismiss
      enableDrag: enableDrag,
      // Smooth spring-like animation
      transitionAnimationController: null, // Use Flutter's default which is good
      // The sheet shape
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => BottomSheetWrapper(
        maxHeightRatio: maxHeightRatio,
        minHeight: minHeight,
        shrinkWrap: shrinkWrap,
        padding: padding,
        useSafeArea: useSafeArea,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = useSafeArea ? MediaQuery.of(context).padding.bottom : 0.0;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: TossAnimations.normal,
      curve: TossAnimations.decelerate,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * maxHeightRatio,
          minHeight: minHeight ?? _defaultMinHeight,
        ),
        decoration: _buildDecoration(),
        child: shrinkWrap
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: _buildContent(bottomPadding),
                  ),
                ],
              )
            : _buildContent(bottomPadding),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return const BoxDecoration(
      color: TossColors.surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(TossBorderRadius.xl),
        topRight: Radius.circular(TossBorderRadius.xl),
      ),
      boxShadow: TossShadows.bottomSheet,
    );
  }

  Widget _buildContent(double bottomPadding) {
    final contentPadding = padding;

    if (contentPadding != null) {
      return Padding(
        padding: contentPadding.copyWith(
          bottom: contentPadding.bottom + bottomPadding,
        ),
        child: child,
      );
    }

    // No padding specified - just add safe area at bottom
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: child,
    );
  }
}
