import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

/// Smart action bar that intelligently positions itself relative to keyboard
/// Solves the "buttons hidden behind keyboard" problem
class TossSmartActionBar extends StatefulWidget {
  final List<TossActionButton> actions;
  final bool showWhenKeyboardVisible;
  final SmartBarPosition position;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool showSeparator;
  final MainAxisAlignment alignment;

  const TossSmartActionBar({
    super.key,
    required this.actions,
    this.showWhenKeyboardVisible = true,
    this.position = SmartBarPosition.aboveKeyboard,
    this.padding,
    this.backgroundColor,
    this.showSeparator = true,
    this.alignment = MainAxisAlignment.spaceEvenly,
  });

  @override
  State<TossSmartActionBar> createState() => _TossSmartActionBarState();
}

class _TossSmartActionBarState extends State<TossSmartActionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    // Don't show if keyboard is visible and showWhenKeyboardVisible is false
    if (isKeyboardVisible && !widget.showWhenKeyboardVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 50),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: _buildActionBar(context, keyboardHeight, isKeyboardVisible),
          ),
        );
      },
    );
  }

  Widget _buildActionBar(
      BuildContext context, double keyboardHeight, bool isKeyboardVisible) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(
        bottom: widget.position == SmartBarPosition.aboveKeyboard
            ? keyboardHeight
            : 0,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TossColors.surface,
        border: widget.showSeparator
            ? const Border(
                top: BorderSide(color: TossColors.gray200, width: 0.5),
              )
            : null,
        boxShadow: isKeyboardVisible ? TossShadows.card : null,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
          child: _buildActions(),
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (widget.actions.isEmpty) return const SizedBox.shrink();

    // Single action
    if (widget.actions.length == 1) {
      return _buildSingleAction(widget.actions.first);
    }

    // Multiple actions
    return Row(
      mainAxisAlignment: widget.alignment,
      children: widget.actions.map((action) => _buildActionButton(action)).toList(),
    );
  }

  Widget _buildSingleAction(TossActionButton action) {
    return SizedBox(
      width: double.infinity,
      child: _buildActionButton(action, isFullWidth: true),
    );
  }

  Widget _buildActionButton(TossActionButton action, {bool isFullWidth = false}) {
    final isPrimary = action.isPrimary;
    final isEnabled = action.isEnabled;

    return Flexible(
      flex: isFullWidth ? 1 : 0,
      child: Container(
        constraints: BoxConstraints(
          minWidth: isFullWidth ? double.infinity : 120,
          minHeight: 48,
        ),
        margin: isFullWidth
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: TossSpacing.space1),
        child: ElevatedButton.icon(
          onPressed: isEnabled ? action.onTap : null,
          icon: action.icon != null
              ? Icon(
                  action.icon,
                  size: TossSpacing.iconSM,
                  color: isPrimary
                      ? TossColors.white
                      : isEnabled
                          ? TossColors.gray700
                          : TossColors.gray400,
                )
              : null,
          label: Text(
            action.label,
            style: TossTextStyles.button.copyWith(
              color: isPrimary
                  ? TossColors.white
                  : isEnabled
                      ? TossColors.gray900
                      : TossColors.gray400,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary
                ? (isEnabled ? TossColors.primary : TossColors.gray300)
                : (isEnabled ? TossColors.gray100 : TossColors.gray50),
            foregroundColor: isPrimary
                ? TossColors.white
                : (isEnabled ? TossColors.gray900 : TossColors.gray400),
            elevation: isPrimary ? 2 : 0,
            shadowColor: isPrimary ? TossColors.primary.withOpacity(0.3) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Smart action bar positioning relative to keyboard
enum SmartBarPosition {
  aboveKeyboard,    // Positioned above the keyboard
  belowKeyboard,    // Positioned below the keyboard  
  fixed,           // Fixed position regardless of keyboard
}

/// Action button configuration for smart action bar
class TossActionButton {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isPrimary;
  final bool isEnabled;
  final String? tooltip;

  const TossActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
    this.isEnabled = true,
    this.tooltip,
  });

  /// Create primary action button
  factory TossActionButton.primary({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    bool isEnabled = true,
    String? tooltip,
  }) {
    return TossActionButton(
      label: label,
      onTap: onTap,
      icon: icon,
      isPrimary: true,
      isEnabled: isEnabled,
      tooltip: tooltip,
    );
  }

  /// Create secondary action button
  factory TossActionButton.secondary({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    bool isEnabled = true,
    String? tooltip,
  }) {
    return TossActionButton(
      label: label,
      onTap: onTap,
      icon: icon,
      isPrimary: false,
      isEnabled: isEnabled,
      tooltip: tooltip,
    );
  }

  /// Common action buttons for amount inputs
  static TossActionButton done({
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return TossActionButton.primary(
      label: 'Done',
      onTap: onTap,
      icon: Icons.check,
      isEnabled: isEnabled,
    );
  }

  static TossActionButton cancel({
    required VoidCallback onTap,
  }) {
    return TossActionButton.secondary(
      label: 'Cancel',
      onTap: onTap,
      icon: Icons.close,
    );
  }

  static TossActionButton save({
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return TossActionButton.primary(
      label: 'Save',
      onTap: onTap,
      icon: Icons.save,
      isEnabled: isEnabled,
    );
  }

  static TossActionButton next({
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return TossActionButton.primary(
      label: 'Next',
      onTap: onTap,
      icon: Icons.arrow_forward,
      isEnabled: isEnabled,
    );
  }

  static TossActionButton submit({
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return TossActionButton.primary(
      label: 'Submit',
      onTap: onTap,
      icon: Icons.send,
      isEnabled: isEnabled,
    );
  }
}

/// Preset action button configurations for common scenarios
class TossActionBarPresets {
  /// Standard Done/Cancel actions for simple forms
  static List<TossActionButton> doneCancel({
    required VoidCallback onDone,
    required VoidCallback onCancel,
    bool isDoneEnabled = true,
  }) {
    return [
      TossActionButton.cancel(onTap: onCancel),
      TossActionButton.done(onTap: onDone, isEnabled: isDoneEnabled),
    ];
  }

  /// Save/Cancel actions for edit forms
  static List<TossActionButton> saveCancel({
    required VoidCallback onSave,
    required VoidCallback onCancel,
    bool isSaveEnabled = true,
  }) {
    return [
      TossActionButton.cancel(onTap: onCancel),
      TossActionButton.save(onTap: onSave, isEnabled: isSaveEnabled),
    ];
  }

  /// Next/Cancel actions for multi-step forms
  static List<TossActionButton> nextCancel({
    required VoidCallback onNext,
    required VoidCallback onCancel,
    bool isNextEnabled = true,
  }) {
    return [
      TossActionButton.cancel(onTap: onCancel),
      TossActionButton.next(onTap: onNext, isEnabled: isNextEnabled),
    ];
  }

  /// Submit only action for final forms
  static List<TossActionButton> submitOnly({
    required VoidCallback onSubmit,
    bool isEnabled = true,
  }) {
    return [
      TossActionButton.submit(onTap: onSubmit, isEnabled: isEnabled),
    ];
  }

  /// Amount input specific actions
  static List<TossActionButton> amountInput({
    required VoidCallback onDone,
    required VoidCallback onCancel,
    bool hasValue = false,
  }) {
    return [
      TossActionButton.secondary(
        label: 'Clear',
        onTap: onCancel,
        icon: Icons.backspace,
        isEnabled: hasValue,
      ),
      TossActionButton.primary(
        label: 'Done',
        onTap: onDone,
        icon: Icons.check,
        isEnabled: hasValue,
      ),
    ];
  }
}