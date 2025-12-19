import 'package:flutter/material.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';

/// AI description box for detail sheets
///
/// Displays AI-generated description in a styled container with amber theme.
/// Designed for use in detail sheets/modals where full content is shown.
///
/// Example:
/// ```dart
/// if (hasAiDescription)
///   AiDescriptionBox(text: aiDescription),
/// ```
class AiDescriptionBox extends StatelessWidget {
  /// The AI-generated description text to display
  final String text;

  /// Optional title (default: 'AI Summary')
  final String? title;

  /// Whether to show divider between title and content (default: true)
  final bool showDivider;

  /// Optional icon to display before the title
  final IconData icon;

  const AiDescriptionBox({
    super.key,
    required this.text,
    this.title,
    this.showDivider = true,
    this.icon = Icons.auto_awesome,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? 'AI Summary';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: Colors.amber.shade600,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                displayTitle,
                style: TossTextStyles.caption.copyWith(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: TossSpacing.space2),
            Container(
              height: 1,
              color: Colors.amber.shade200,
            ),
            const SizedBox(height: TossSpacing.space2),
          ] else ...[
            const SizedBox(height: TossSpacing.space1),
          ],
          // Content
          Text(
            text,
            style: TossTextStyles.body.copyWith(
              fontSize: 14,
              color: TossColors.gray700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline AI description row for use within other containers
///
/// Similar to AiDescriptionBox but without the container styling.
/// Useful when placed inside another styled container (e.g., info card).
///
/// Example:
/// ```dart
/// Container(
///   child: Column([
///     _buildUserDescription(),
///     AiDescriptionInline(text: aiDescription),
///   ]),
/// )
/// ```
class AiDescriptionInline extends StatelessWidget {
  /// The AI-generated description text to display
  final String text;

  /// Size of the sparkle icon (default: 14)
  final double iconSize;

  const AiDescriptionInline({
    super.key,
    required this.text,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.auto_awesome,
          size: iconSize,
          color: Colors.amber.shade600,
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Text(
            text,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
      ],
    );
  }
}
