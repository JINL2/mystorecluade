import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header widget for dialogs with icon and title
class DialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onClose;

  const DialogHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: TossColors.textTertiary),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}
