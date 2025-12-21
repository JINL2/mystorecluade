import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility functions for keyboard management across the app
class KeyboardUtils {
  /// Check if keyboard is currently visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Get current keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Dismiss keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Focus next field in form
  static void focusNextField(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// Check if device is tablet (affects keyboard behavior)
  static bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final shortestSide = screenWidth < screenHeight ? screenWidth : screenHeight;
    return shortestSide >= 600;
  }

  /// Get safe keyboard padding for bottom sheets
  static EdgeInsets getSafeKeyboardPadding(BuildContext context, {double minPadding = 0}) {
    final keyboardHeight = getKeyboardHeight(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return EdgeInsets.only(
      bottom: keyboardHeight > 0 
          ? keyboardHeight + minPadding
          : bottomPadding + minPadding,
    );
  }

  /// Calculate optimal bottom sheet height with keyboard
  static double getOptimalBottomSheetHeight(
    BuildContext context, {
    double contentHeight = 400,
    double maxHeightFactor = 0.9,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = getKeyboardHeight(context);
    final availableHeight = screenHeight - keyboardHeight;
    
    final maxHeight = screenHeight * maxHeightFactor;
    final optimalHeight = contentHeight + 100; // Add padding for actions
    
    return optimalHeight > availableHeight 
        ? availableHeight * 0.9 
        : optimalHeight.clamp(200, maxHeight);
  }

  /// Smooth scroll to show input field above keyboard
  static void scrollToShowField(
    ScrollController controller,
    GlobalKey fieldKey,
    BuildContext context,
  ) {
    if (!controller.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = fieldKey.currentContext?.findRenderObject();
      if (renderObject == null) return;

      final RenderBox renderBox = renderObject as RenderBox;
      final fieldOffset = renderBox.localToGlobal(Offset.zero);
      final keyboardHeight = getKeyboardHeight(context);
      final screenHeight = MediaQuery.of(context).size.height;
      
      // Calculate if field is hidden by keyboard
      final fieldBottom = fieldOffset.dy + renderBox.size.height;
      final visibleHeight = screenHeight - keyboardHeight;
      
      if (fieldBottom > visibleHeight - 50) { // 50px buffer
        final scrollOffset = fieldBottom - visibleHeight + 100; // Scroll a bit extra
        controller.animateTo(
          (controller.offset + scrollOffset).clamp(0, controller.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

/// Keyboard behavior configuration
class KeyboardBehaviorConfig {
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeOutCubic;
  static const double minKeyboardHeight = 200;
  static const double actionBarHeight = 60;
  static const double defaultBottomPadding = 16;
  
  /// Platform specific keyboard behaviors
  static bool get shouldDismissOnTap => true;
  static bool get shouldScrollToInput => true;
  static bool get shouldAnimateActions => true;
  static bool get shouldUseSystemKeyboard => true;
}

/// Mixin for widgets that need keyboard handling
mixin KeyboardHandlerMixin<T extends StatefulWidget> on State<T> {
  bool _keyboardWasVisible = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleKeyboardChange();
  }

  void _handleKeyboardChange() {
    final isKeyboardVisible = KeyboardUtils.isKeyboardVisible(context);
    
    if (isKeyboardVisible != _keyboardWasVisible) {
      _keyboardWasVisible = isKeyboardVisible;
      onKeyboardVisibilityChanged(isKeyboardVisible);
    }
  }

  /// Override this method to handle keyboard visibility changes
  void onKeyboardVisibilityChanged(bool isVisible) {}

  /// Convenience method to dismiss keyboard
  void dismissKeyboard() {
    KeyboardUtils.dismissKeyboard(context);
  }

  /// Check if keyboard is visible
  bool get isKeyboardVisible => KeyboardUtils.isKeyboardVisible(context);
  
  /// Get keyboard height
  double get keyboardHeight => KeyboardUtils.getKeyboardHeight(context);
}

/// Keyboard-aware scroll behavior for bottom sheets
class KeyboardAwareScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

/// Focus node that auto-disposes
class AutoDisposeFocusNode extends FocusNode {
  @override
  void dispose() {
    super.dispose();
  }
}

/// Extension methods for easier keyboard handling
extension KeyboardExtensions on BuildContext {
  /// Check if keyboard is visible
  bool get isKeyboardVisible => KeyboardUtils.isKeyboardVisible(this);
  
  /// Get keyboard height
  double get keyboardHeight => KeyboardUtils.getKeyboardHeight(this);
  
  /// Dismiss keyboard
  void dismissKeyboard() => KeyboardUtils.dismissKeyboard(this);
  
  /// Get safe keyboard padding
  EdgeInsets keyboardPadding({double minPadding = 0}) => 
      KeyboardUtils.getSafeKeyboardPadding(this, minPadding: minPadding);
}