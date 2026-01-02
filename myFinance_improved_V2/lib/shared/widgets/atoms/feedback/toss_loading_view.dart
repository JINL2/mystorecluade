import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Toss-styled loading indicator
///
/// Usage:
/// - Full page loading: `TossLoadingView()` or `TossLoadingView(message: 'Loading...')`
/// - Inline/small loading: `TossLoadingView.inline()` or `TossLoadingView.inline(size: 20)`
/// - Custom color: `TossLoadingView.inline(color: TossColors.white)`
class TossLoadingView extends StatelessWidget {
  const TossLoadingView({
    super.key,
    this.message,
  })  : size = 36,
        strokeWidth = 3.0,
        color = null,
        _isInline = false;

  /// Inline loading indicator for buttons, list items, etc.
  const TossLoadingView.inline({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
  })  : message = null,
        _isInline = true;

  final String? message;
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool _isInline;

  @override
  Widget build(BuildContext context) {
    if (_isInline) {
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? TossColors.primary),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: TossSpacing.space4),
            Text(
              message!,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
