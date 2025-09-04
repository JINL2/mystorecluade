import 'package:flutter/material.dart';
import 'toss_enhanced_modal.dart';

/// Keyboard-aware modal specifically designed for forms with text inputs
/// Automatically scrolls to keep focused field visible
class TossKeyboardAwareModal extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget Function(ScrollController scrollController) childBuilder;
  final List<Widget>? actions;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final bool showHandleBar;
  final double? height;
  final Color? backgroundColor;
  final bool enableKeyboardToolbar;
  final VoidCallback? onKeyboardDone;
  final String keyboardDoneText;

  const TossKeyboardAwareModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.childBuilder,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.showHandleBar = true,
    this.height,
    this.backgroundColor,
    this.enableKeyboardToolbar = true,
    this.onKeyboardDone,
    this.keyboardDoneText = 'Done',
  });

  /// Show keyboard-aware modal with auto-scroll to focused field
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget Function(ScrollController scrollController) childBuilder,
    List<Widget>? actions,
    VoidCallback? onClose,
    bool showCloseButton = true,
    bool showHandleBar = true,
    double? height,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    bool enableKeyboardToolbar = true,
    VoidCallback? onKeyboardDone,
    String keyboardDoneText = 'Done',
  }) {
    return TossEnhancedModal.show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      child: _KeyboardAwareContent(
        childBuilder: childBuilder,
      ),
      actions: actions,
      onClose: onClose,
      showCloseButton: showCloseButton,
      showHandleBar: showHandleBar,
      height: height,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      enableKeyboardToolbar: enableKeyboardToolbar,
      onKeyboardDone: onKeyboardDone,
      keyboardDoneText: keyboardDoneText,
    );
  }

  @override
  State<TossKeyboardAwareModal> createState() => _TossKeyboardAwareModalState();
}

class _TossKeyboardAwareModalState extends State<TossKeyboardAwareModal> {
  @override
  Widget build(BuildContext context) {
    return TossEnhancedModal(
      title: widget.title,
      subtitle: widget.subtitle,
      child: _KeyboardAwareContent(
        childBuilder: widget.childBuilder,
      ),
      actions: widget.actions,
      onClose: widget.onClose,
      showCloseButton: widget.showCloseButton,
      showHandleBar: widget.showHandleBar,
      height: widget.height,
      backgroundColor: widget.backgroundColor,
      enableKeyboardToolbar: widget.enableKeyboardToolbar,
      onKeyboardDone: widget.onKeyboardDone,
      keyboardDoneText: widget.keyboardDoneText,
    );
  }
}

/// Internal widget that handles scroll management and focus tracking
class _KeyboardAwareContent extends StatefulWidget {
  final Widget Function(ScrollController scrollController) childBuilder;

  const _KeyboardAwareContent({
    required this.childBuilder,
  });

  @override
  State<_KeyboardAwareContent> createState() => _KeyboardAwareContentState();
}

class _KeyboardAwareContentState extends State<_KeyboardAwareContent> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Listen to focus changes to auto-scroll
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Delay to ensure keyboard is fully shown
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _scrollController.hasClients) {
          // Scroll to make focused field visible
          _ensureFocusedFieldVisible();
        }
      });
    }
  }

  void _ensureFocusedFieldVisible() {
    // Get the focused widget's render object
    final FocusScopeNode currentFocus = FocusScope.of(context);
    final FocusNode? focusedNode = currentFocus.focusedChild;
    
    if (focusedNode != null && focusedNode.context != null) {
      final RenderObject? renderObject = focusedNode.context!.findRenderObject();
      if (renderObject != null && _scrollController.hasClients) {
        // Calculate position and scroll to make it visible
        _scrollController.position.ensureVisible(
          renderObject,
          alignment: 0.5, // Center the field in viewport
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: FocusScope(
        node: FocusScopeNode(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            // Dismiss keyboard on scroll for better UX
            if (scrollNotification is UserScrollNotification) {
              FocusScope.of(context).unfocus();
            }
            return false;
          },
          child: widget.childBuilder(_scrollController),
        ),
      ),
    );
  }
}

/// Utility widget for wrapping form content with proper padding
class KeyboardAwareFormContent extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollController? scrollController;

  const KeyboardAwareFormContent({
    super.key,
    required this.children,
    this.padding,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: padding ?? EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}