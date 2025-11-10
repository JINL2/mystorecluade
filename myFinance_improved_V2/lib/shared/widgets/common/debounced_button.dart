/// Debounced Button Widgets
///
/// ElevatedButton, TextButton, IconButton with automatic duplicate click prevention.
///
/// Usage:
/// ```dart
/// DebouncedElevatedButton(
///   onPressed: () => context.push('/page'),
///   child: Text('Click me'),
/// )
/// ```

import 'dart:async';
import 'package:flutter/material.dart';

/// Mixin for debouncing button presses
mixin DebouncedButtonMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;
  bool _isDebouncing = false;

  /// Execute callback with debouncing
  void executeDebounced(VoidCallback? callback) {
    if (callback == null) return;

    if (_isDebouncing) {
      debugPrint('[DebouncedButton] Press ignored - debouncing');
      return;
    }

    // Execute callback
    callback();

    // Start debounce timer
    setState(() {
      _isDebouncing = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isDebouncing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// ElevatedButton with duplicate click prevention
class DebouncedElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const DebouncedElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  State<DebouncedElevatedButton> createState() =>
      _DebouncedElevatedButtonState();
}

class _DebouncedElevatedButtonState extends State<DebouncedElevatedButton>
    with DebouncedButtonMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed != null
          ? () => executeDebounced(widget.onPressed)
          : null,
      style: widget.style,
      child: widget.child,
    );
  }
}

/// TextButton with duplicate click prevention
class DebouncedTextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const DebouncedTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  State<DebouncedTextButton> createState() => _DebouncedTextButtonState();
}

class _DebouncedTextButtonState extends State<DebouncedTextButton>
    with DebouncedButtonMixin {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed != null
          ? () => executeDebounced(widget.onPressed)
          : null,
      style: widget.style,
      child: widget.child,
    );
  }
}

/// IconButton with duplicate click prevention
class DebouncedIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double? iconSize;
  final Color? color;
  final String? tooltip;

  const DebouncedIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.color,
    this.tooltip,
  }) : super(key: key);

  @override
  State<DebouncedIconButton> createState() => _DebouncedIconButtonState();
}

class _DebouncedIconButtonState extends State<DebouncedIconButton>
    with DebouncedButtonMixin {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed != null
          ? () => executeDebounced(widget.onPressed)
          : null,
      icon: widget.icon,
      iconSize: widget.iconSize,
      color: widget.color,
      tooltip: widget.tooltip,
    );
  }
}

/// OutlinedButton with duplicate click prevention
class DebouncedOutlinedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const DebouncedOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  State<DebouncedOutlinedButton> createState() =>
      _DebouncedOutlinedButtonState();
}

class _DebouncedOutlinedButtonState extends State<DebouncedOutlinedButton>
    with DebouncedButtonMixin {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed != null
          ? () => executeDebounced(widget.onPressed)
          : null,
      style: widget.style,
      child: widget.child,
    );
  }
}
