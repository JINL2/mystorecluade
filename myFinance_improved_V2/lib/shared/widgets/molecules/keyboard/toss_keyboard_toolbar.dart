import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

/// Keyboard toolbar that provides intuitive Done button and navigation
class TossKeyboardToolbar extends StatelessWidget {
  final VoidCallback? onDone;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final String doneText;
  final bool showNavigation;
  final bool enabled;
  const TossKeyboardToolbar({
    super.key,
    this.onDone,
    this.onNext,
    this.onPrevious,
    this.doneText = 'Done',
    this.showNavigation = false,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Navigation buttons (Previous/Next)
          if (showNavigation) ...[
            _buildNavButton(
              icon: Icons.keyboard_arrow_up,
              onPressed: enabled ? onPrevious : null,
              tooltip: 'Previous field',
            ),
              icon: Icons.keyboard_arrow_down,
              onPressed: enabled ? onNext : null,
              tooltip: 'Next field',
            const SizedBox(width: TossSpacing.space2),
          ],
          
          const Spacer(),
          // Done button - Uses TossButton Atom for consistent design
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            child: TossButton.primary(
              text: doneText,
              onPressed: enabled ? onDone : null,
              isEnabled: enabled,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              borderRadius: TossBorderRadius.sm,
              fontSize: TossTextStyles.bodySmall.fontSize,
        ],
    );
  }
  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space2,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: TossSpacing.iconSM,
          color: onPressed != null ? TossColors.gray600 : TossColors.gray300,
        tooltip: tooltip,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        padding: EdgeInsets.zero,
}
/// Wrapper widget that provides keyboard toolbar functionality to any widget
class TossKeyboardWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onKeyboardDone;
  final VoidCallback? onKeyboardNext;
  final VoidCallback? onKeyboardPrevious;
  final bool enableTapDismiss;
  const TossKeyboardWrapper({
    required this.child,
    this.onKeyboardDone,
    this.onKeyboardNext,
    this.onKeyboardPrevious,
    this.enableTapDismiss = true,
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final showToolbar = keyboardHeight > 0;
    Widget content = child;
    // Wrap with tap-to-dismiss if enabled
    if (enableTapDismiss) {
      content = GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }
    return Column(
      children: [
        Expanded(child: content),
        
        // Keyboard toolbar - appears when keyboard is visible
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: showToolbar ? 44 : 0,
          child: showToolbar
              ? TossKeyboardToolbar(
                  onDone: onKeyboardDone ?? () => FocusManager.instance.primaryFocus?.unfocus(),
                  onNext: onKeyboardNext,
                  onPrevious: onKeyboardPrevious,
                  doneText: doneText,
                  showNavigation: showNavigation,
                )
              : null,
      ],
}