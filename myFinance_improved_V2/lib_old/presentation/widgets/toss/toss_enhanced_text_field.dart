import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toss_text_field.dart';
import 'toss_keyboard_toolbar.dart';

/// Enhanced text field with keyboard toolbar and intuitive UX
class TossEnhancedTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final bool autocorrect;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  
  // Enhanced keyboard features
  final bool showKeyboardToolbar;
  final VoidCallback? onKeyboardDone;
  final VoidCallback? onKeyboardNext;
  final VoidCallback? onKeyboardPrevious;
  final String keyboardDoneText;
  final bool enableTapDismiss;

  const TossEnhancedTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.autocorrect = true,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.showKeyboardToolbar = true,
    this.onKeyboardDone,
    this.onKeyboardNext,
    this.onKeyboardPrevious,
    this.keyboardDoneText = 'Done',
    this.enableTapDismiss = true,
  });

  @override
  State<TossEnhancedTextField> createState() => _TossEnhancedTextFieldState();
}

class _TossEnhancedTextFieldState extends State<TossEnhancedTextField> {
  late FocusNode _internalFocusNode;
  bool _showToolbar = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {
        _showToolbar = _internalFocusNode.hasFocus && widget.showKeyboardToolbar;
      });
    }
  }

  void _handleDone() {
    if (widget.onKeyboardDone != null) {
      widget.onKeyboardDone!();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  void _handleFieldSubmitted(String value) {
    if (widget.onFieldSubmitted != null) {
      widget.onFieldSubmitted!(value);
    } else {
      _handleDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final showToolbar = _showToolbar && keyboardHeight > 0;

    return Column(
      children: [
        // Main text field
        TossTextField(
          label: widget.label,
          hintText: widget.hintText,
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          suffixIcon: widget.suffixIcon,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          autocorrect: widget.autocorrect,
          focusNode: _internalFocusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          onFieldSubmitted: _handleFieldSubmitted,
          inputFormatters: widget.inputFormatters,
        ),
        
        // Keyboard toolbar - appears when keyboard is visible and field is focused
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: showToolbar ? 44 : 0,
          child: showToolbar
              ? TossKeyboardToolbar(
                  onDone: _handleDone,
                  onNext: widget.onKeyboardNext,
                  onPrevious: widget.onKeyboardPrevious,
                  doneText: widget.keyboardDoneText,
                  showNavigation: widget.onKeyboardNext != null || widget.onKeyboardPrevious != null,
                )
              : null,
        ),
      ],
    );
  }
}

/// Form wrapper that provides tap-to-dismiss and coordinated keyboard navigation
class TossFormWrapper extends StatelessWidget {
  final Widget child;
  final bool enableTapDismiss;
  final EdgeInsets? padding;

  const TossFormWrapper({
    super.key,
    required this.child,
    this.enableTapDismiss = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (enableTapDismiss) {
      content = GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    return content;
  }
}