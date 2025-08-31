import 'package:flutter/material.dart';
import 'toss_modal.dart';
import 'toss_keyboard_toolbar.dart';

/// Enhanced modal with integrated keyboard toolbar for better UX
class TossEnhancedModal extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final bool showHandleBar;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool isScrollControlled;
  
  // Enhanced keyboard features
  final bool enableKeyboardToolbar;
  final VoidCallback? onKeyboardDone;
  final String keyboardDoneText;
  final bool enableTapDismiss;

  const TossEnhancedModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.showHandleBar = true,
    this.height,
    this.padding,
    this.backgroundColor,
    this.isScrollControlled = true,
    this.enableKeyboardToolbar = true,
    this.onKeyboardDone,
    this.keyboardDoneText = 'Done',
    this.enableTapDismiss = true,
  });

  /// Show enhanced modal with keyboard toolbar
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
    List<Widget>? actions,
    VoidCallback? onClose,
    bool showCloseButton = true,
    bool showHandleBar = true,
    double? height,
    EdgeInsets? padding,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool enableKeyboardToolbar = true,
    VoidCallback? onKeyboardDone,
    String keyboardDoneText = 'Done',
    bool enableTapDismiss = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => TossEnhancedModal(
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        onClose: onClose ?? (() => Navigator.of(context).pop()),
        showCloseButton: showCloseButton,
        showHandleBar: showHandleBar,
        height: height,
        padding: padding,
        backgroundColor: backgroundColor,
        isScrollControlled: isScrollControlled,
        enableKeyboardToolbar: enableKeyboardToolbar,
        onKeyboardDone: onKeyboardDone,
        keyboardDoneText: keyboardDoneText,
        enableTapDismiss: enableTapDismiss,
      ),
    );
  }

  @override
  State<TossEnhancedModal> createState() => _TossEnhancedModalState();
}

class _TossEnhancedModalState extends State<TossEnhancedModal> {
  bool _showKeyboardToolbar = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final showToolbar = widget.enableKeyboardToolbar && keyboardHeight > 0;

    // Update toolbar visibility state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _showKeyboardToolbar != showToolbar) {
        setState(() {
          _showKeyboardToolbar = showToolbar;
        });
      }
    });

    Widget modalContent = TossModal(
      title: widget.title,
      subtitle: widget.subtitle,
      child: widget.child,
      actions: widget.actions,
      onClose: widget.onClose,
      showCloseButton: widget.showCloseButton,
      showHandleBar: widget.showHandleBar,
      height: widget.height,
      padding: widget.padding,
      backgroundColor: widget.backgroundColor,
      isScrollControlled: widget.isScrollControlled,
    );

    // Don't wrap with GestureDetector - let the modal barrier handle dismissal
    // The TossModal already handles focus management appropriately

    // Calculate the actual modal height including keyboard toolbar
    final modalHeight = widget.height ?? MediaQuery.of(context).size.height * 0.8;
    final toolbarHeight = _showKeyboardToolbar ? 44.0 : 0.0;
    final totalHeight = modalHeight + toolbarHeight;

    return Container(
      height: totalHeight,  // Fixed height container to prevent expansion
      child: Column(
        children: [
          // Modal content with fixed height (not Expanded!)
          SizedBox(
            height: modalHeight,
            child: modalContent,
          ),
          
          // Keyboard toolbar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: toolbarHeight,
            child: _showKeyboardToolbar
                ? TossKeyboardToolbar(
                    onDone: widget.onKeyboardDone ?? () {
                      FocusScope.of(context).unfocus();
                    },
                    doneText: widget.keyboardDoneText,
                    showNavigation: false,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}