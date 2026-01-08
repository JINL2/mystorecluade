import 'package:flutter/material.dart';

import '../../themes/index.dart';

/// Compact AI description row for list items
///
/// Displays AI-generated description with a sparkle icon in amber color.
/// Designed for use in list items where space is limited.
///
/// Example:
/// ```dart
/// if (transaction.aiDescription != null)
///   AiDescriptionRow(text: transaction.aiDescription!),
/// ```
class AiDescriptionRow extends StatelessWidget {
  /// The AI-generated description text to display
  final String text;

  /// Maximum number of lines before truncating (default: 1)
  final int maxLines;

  /// Size of the sparkle icon (default: 12)
  final double iconSize;

  /// Font size of the description text (default: 12)
  final double fontSize;

  /// Cross axis alignment for the row (default: center)
  final CrossAxisAlignment alignment;

  const AiDescriptionRow({
    super.key,
    required this.text,
    this.maxLines = 1,
    this.iconSize = 12,
    this.fontSize = 12,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: alignment,
      children: [
        Icon(
          Icons.auto_awesome,
          size: iconSize,
          color: TossColors.warning,
        ),
        SizedBox(width: TossSpacing.space1),
        Expanded(
          child: Text(
            text,
            style: TossTextStyles.caption.copyWith(
              fontSize: fontSize,
              color: TossColors.warning,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
