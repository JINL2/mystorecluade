import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Pattern wrappers for consistent keyboard handling in modals
/// Use these patterns for different modal types

/// Pattern 1: Form with fixed bottom buttons (like transaction templates)
/// Keeps buttons always visible above keyboard
class FixedBottomModalWrapper extends StatelessWidget {
  final Widget scrollableContent;
  final Widget fixedBottom;
  final EdgeInsets? contentPadding;
  final bool addKeyboardPadding;

  const FixedBottomModalWrapper({
    super.key,
    required this.scrollableContent,
    required this.fixedBottom,
    this.contentPadding,
    this.addKeyboardPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scrollable content area
        Flexible(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: contentPadding ?? const EdgeInsets.all(TossSpacing.space4),
            child: scrollableContent,
          ),
        ),
        
        // Fixed bottom section that stays above keyboard
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: addKeyboardPadding ? keyboardHeight : 0,
          ),
          decoration: BoxDecoration(
            color: TossColors.background,
            border: keyboardHeight > 0 ? const Border(
              top: BorderSide(color: TossColors.gray200, width: 0.5),
            ) : null,
            boxShadow: keyboardHeight > 0 ? TossShadows.bottomSheet : null,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: fixedBottom,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pattern 2: Simple scrollable form (no fixed buttons)
/// Good for role editing, simple forms
class ScrollableFormWrapper extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool autoScrollToFocus;

  const ScrollableFormWrapper({
    super.key,
    required this.child,
    this.padding,
    this.autoScrollToFocus = true,
  });

  @override
  State<ScrollableFormWrapper> createState() => _ScrollableFormWrapperState();
}

class _ScrollableFormWrapperState extends State<ScrollableFormWrapper> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: widget.padding ?? const EdgeInsets.all(TossSpacing.space4).copyWith(
          bottom: TossSpacing.space4 + keyboardHeight,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Pattern 3: Auto-detecting wrapper
/// Automatically chooses the right pattern based on content
class SmartModalWrapper extends StatelessWidget {
  final Widget child;
  
  const SmartModalWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // For now, just use simple scrollable wrapper
    // Can enhance later with detection logic if needed
    return ScrollableFormWrapper(child: child);
  }
}

/// Pattern 4: Wizard/Stepper modal with smart keyboard handling
/// Keeps modal position fixed, only adjusts internal content
/// MUST be used with Scaffold(resizeToAvoidBottomInset: false)
class WizardModalWrapper extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Widget? actionButtons;
  final bool hideActionsOnKeyboard;
  final double maxHeightFactor;
  
  const WizardModalWrapper({
    super.key,
    required this.header,
    required this.content,
    this.actionButtons,
    this.hideActionsOnKeyboard = true,
    this.maxHeightFactor = 0.8,
  });

  @override
  State<WizardModalWrapper> createState() => _WizardModalWrapperState();
}

class _WizardModalWrapperState extends State<WizardModalWrapper> {
  bool _isKeyboardVisible = false;
  
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * widget.maxHeightFactor;
    
    // Update keyboard visibility state
    _isKeyboardVisible = keyboardHeight > 0;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed header - never scrolls
          widget.header,
          
          // Scrollable content area - add padding to push content above keyboard
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                // When keyboard is visible, add padding to ensure content is visible
                bottom: _isKeyboardVisible ? keyboardHeight : 0,
              ),
              child: widget.content,
            ),
          ),
          
          // Action buttons with intelligent keyboard handling
          if (widget.actionButtons != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: _shouldHideActions() ? 0 : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _shouldHideActions() ? 0.0 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: TossColors.surface,
                    border: _isKeyboardVisible 
                        ? const Border(top: BorderSide(color: TossColors.gray200, width: 0.5))
                        : null,
                    boxShadow: _isKeyboardVisible ? TossShadows.bottomSheet : null,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: widget.actionButtons,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  bool _shouldHideActions() {
    return widget.hideActionsOnKeyboard && _isKeyboardVisible;
  }
}

/// Utility for keyboard-aware padding
class KeyboardAwarePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool includeKeyboard;

  const KeyboardAwarePadding({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(TossSpacing.space4),
    this.includeKeyboard = true,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = includeKeyboard 
        ? MediaQuery.of(context).viewInsets.bottom 
        : 0.0;
        
    return Padding(
      padding: padding.copyWith(
        bottom: padding.bottom + keyboardHeight,
      ),
      child: child,
    );
  }
}