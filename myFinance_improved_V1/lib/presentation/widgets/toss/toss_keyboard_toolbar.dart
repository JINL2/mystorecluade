import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/index.dart';

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
      decoration: BoxDecoration(
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
            _buildNavButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: enabled ? onNext : null,
              tooltip: 'Next field',
            ),
            const SizedBox(width: TossSpacing.space2),
          ],
          
          const Spacer(),
          
          // Done button - Prominent blue button matching app design
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            child: ElevatedButton(
              onPressed: enabled ? onDone : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: TossColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                minimumSize: const Size(60, 32),
              ),
              child: Text(
                doneText,
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space2,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: onPressed != null ? TossColors.gray600 : TossColors.gray300,
        ),
        tooltip: tooltip,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// Wrapper widget that provides keyboard toolbar functionality to any widget
class TossKeyboardWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onKeyboardDone;
  final VoidCallback? onKeyboardNext;
  final VoidCallback? onKeyboardPrevious;
  final String doneText;
  final bool showNavigation;
  final bool enableTapDismiss;

  const TossKeyboardWrapper({
    super.key,
    required this.child,
    this.onKeyboardDone,
    this.onKeyboardNext,
    this.onKeyboardPrevious,
    this.doneText = 'Done',
    this.showNavigation = false,
    this.enableTapDismiss = true,
  });

  @override
  Widget build(BuildContext context) {
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
        ),
      ],
    );
  }
}