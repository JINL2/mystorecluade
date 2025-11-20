// lib/shared/widgets/common/keyboard_toolbar_1.dart

import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';

/// Keyboard Toolbar Widget - Shows above iOS/Android keyboard
///
/// Provides navigation between text fields and a "Done" button to dismiss keyboard.
/// Uses OverlayEntry to position itself above the system keyboard.
///
/// Example usage:
/// ```dart
/// KeyboardToolbar1(
///   focusNode: _myFocusNode,
///   showToolbar: true,
///   onPrevious: _focusPreviousField,
///   onNext: _focusNextField,
///   onDone: _dismissKeyboard,
/// )
/// ```
class KeyboardToolbar1 extends StatefulWidget {
  /// Focus node to monitor keyboard visibility
  /// Can be a single FocusNode or will use controller's currentFocusNode
  final FocusNode? focusNode;

  /// Keyboard toolbar controller for managing multiple focus nodes
  final KeyboardToolbarController? controller;

  /// Whether to show the toolbar (enables on/off control)
  final bool showToolbar;

  /// Callback for "Previous" button (navigate to previous field)
  final VoidCallback? onPrevious;

  /// Callback for "Next" button (navigate to next field)
  final VoidCallback? onNext;

  /// Callback for "Done" button (dismiss keyboard)
  final VoidCallback onDone;

  /// Background color of the toolbar (default: gray200)
  final Color? backgroundColor;

  /// Height of the toolbar (default: 44)
  final double height;

  /// Whether to show previous/next buttons (default: true)
  final bool showNavigation;

  /// Icon for previous button (default: chevron_up)
  final IconData? previousIcon;

  /// Icon for next button (default: chevron_down)
  final IconData? nextIcon;

  const KeyboardToolbar1({
    super.key,
    this.focusNode,
    this.controller,
    required this.showToolbar,
    this.onPrevious,
    this.onNext,
    required this.onDone,
    this.backgroundColor,
    this.height = 44,
    this.showNavigation = true,
    this.previousIcon,
    this.nextIcon,
  }) : assert(focusNode != null || controller != null,
         'Either focusNode or controller must be provided',);

  @override
  State<KeyboardToolbar1> createState() => _KeyboardToolbar1State();
}

class _KeyboardToolbar1State extends State<KeyboardToolbar1> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    _removeFocusListeners();
    _hideToolbar();
    super.dispose();
  }

  @override
  void didUpdateWidget(KeyboardToolbar1 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle focus node/controller changes
    if (oldWidget.focusNode != widget.focusNode ||
        oldWidget.controller != widget.controller) {
      _removeFocusListeners();
      _setupFocusListeners();
    }

    // Handle showToolbar toggle
    if (oldWidget.showToolbar != widget.showToolbar) {
      if (!widget.showToolbar) {
        _hideToolbar();
      } else if (_hasAnyFocus()) {
        _showToolbar();
      }
    }
  }

  /// Setup focus listeners for either single node or controller
  void _setupFocusListeners() {
    if (widget.controller != null) {
      // Listen to all focus nodes in controller
      for (final node in widget.controller!.focusNodes) {
        node.addListener(_onFocusChange);
      }
    } else if (widget.focusNode != null) {
      // Listen to single focus node
      widget.focusNode!.addListener(_onFocusChange);
    }
  }

  /// Remove focus listeners
  void _removeFocusListeners() {
    if (widget.controller != null) {
      for (final node in widget.controller!.focusNodes) {
        node.removeListener(_onFocusChange);
      }
    } else if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_onFocusChange);
    }
  }

  /// Check if any focus node has focus
  bool _hasAnyFocus() {
    if (widget.controller != null) {
      return widget.controller!.focusNodes.any((node) => node.hasFocus);
    } else if (widget.focusNode != null) {
      return widget.focusNode!.hasFocus;
    }
    return false;
  }

  /// Listen to focus changes to show/hide toolbar
  void _onFocusChange() {
    if (_hasAnyFocus() && widget.showToolbar) {
      // Show toolbar immediately when any field gains focus
      // TextField's scrollPadding handles automatic scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _hasAnyFocus()) {
          _showToolbar();
        }
      });
    } else {
      _hideToolbar();
    }

    // Force rebuild to update button states
    if (mounted) {
      setState(() {});
    }
  }

  /// Show the toolbar overlay above keyboard
  void _showToolbar() {
    // Remove existing overlay if any
    _hideToolbar();

    // Get overlay from the root navigator context
    final overlay = Overlay.of(context, rootOverlay: true);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        // Hide toolbar when keyboard is hidden
        if (keyboardHeight == 0) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: keyboardHeight,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? TossColors.gray100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                border: Border.all(
                  color: TossColors.gray200,
                  width: 0.5,
                ),
              ),
              child: Row(
              children: [
                // Previous/Next buttons (left side)
                if (widget.showNavigation) ...[
                  const SizedBox(width: TossSpacing.space2),
                  _buildNavigationButton(
                    icon: widget.previousIcon ?? Icons.keyboard_arrow_up,
                    onPressed: widget.onPrevious,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  _buildNavigationButton(
                    icon: widget.nextIcon ?? Icons.keyboard_arrow_down,
                    onPressed: widget.onNext,
                  ),
                ],

                // Spacer to push "Done" button to the right
                const Spacer(),

                // Done button (right side)
                TextButton(
                  onPressed: widget.onDone,
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
              ],
            ),
          ),
        ),
        );
      },
    );

    // Insert overlay
    overlay.insert(_overlayEntry!);
  }

  /// Hide the toolbar overlay
  void _hideToolbar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Build navigation button (Previous/Next)
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return IconButton(
      icon: Icon(icon),
      iconSize: 24,
      color: isEnabled ? TossColors.gray700 : TossColors.gray300,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget doesn't render anything visible
    // It only manages the overlay
    return const SizedBox.shrink();
  }
}

/// Helper class to manage multiple text fields with keyboard toolbar
///
/// Example usage:
/// ```dart
/// class MyPage extends StatefulWidget {
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
///
/// class _MyPageState extends State<MyPage> {
///   late final KeyboardToolbarController _toolbarController;
///
///   @override
///   void initState() {
///     super.initState();
///     _toolbarController = KeyboardToolbarController(
///       fieldCount: 5, // 5 denomination fields
///     );
///   }
///
///   @override
///   void dispose() {
///     _toolbarController.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         // Build text fields
///         for (int i = 0; i < 5; i++)
///           TextField(
///             focusNode: _toolbarController.focusNodes[i],
///           ),
///
///         // Add toolbar
///         KeyboardToolbar1(
///           focusNode: _toolbarController.currentFocusNode,
///           showToolbar: true,
///           onPrevious: _toolbarController.focusPrevious,
///           onNext: _toolbarController.focusNext,
///           onDone: _toolbarController.unfocusAll,
///         ),
///       ],
///     );
///   }
/// }
/// ```
class KeyboardToolbarController {
  /// List of focus nodes for each field
  final List<FocusNode> focusNodes;

  /// Current focused field index
  int _currentIndex = 0;

  /// Create controller with specified number of fields
  KeyboardToolbarController({required int fieldCount})
      : focusNodes = List.generate(
          fieldCount,
          (_) => FocusNode(),
        ) {
    // Listen to all focus nodes to track current index
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          _currentIndex = i;
        }
      });
    }
  }

  /// Get the currently focused node (or first node if none focused)
  FocusNode get currentFocusNode {
    for (int i = 0; i < focusNodes.length; i++) {
      if (focusNodes[i].hasFocus) {
        _currentIndex = i;
        return focusNodes[i];
      }
    }
    // If no node is focused, return first node but don't change index
    return focusNodes.first;
  }

  /// Focus the previous field (null if already at first)
  VoidCallback? get focusPrevious {
    if (_currentIndex > 0) {
      return () {
        focusNodes[_currentIndex - 1].requestFocus();
      };
    }
    return null;
  }

  /// Focus the next field (null if already at last)
  VoidCallback? get focusNext {
    if (_currentIndex < focusNodes.length - 1) {
      return () {
        focusNodes[_currentIndex + 1].requestFocus();
      };
    }
    return null;
  }

  /// Unfocus all fields (dismiss keyboard)
  void unfocusAll() {
    for (final node in focusNodes) {
      node.unfocus();
    }
  }

  /// Focus a specific field by index
  void focusField(int index) {
    if (index >= 0 && index < focusNodes.length) {
      focusNodes[index].requestFocus();
    }
  }

  /// Dispose all focus nodes
  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }
  }
}
