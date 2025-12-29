import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Empty stores state widget for dialogs
class DialogEmptyStores extends StatelessWidget {
  final VoidCallback onClose;

  const DialogEmptyStores({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.store_outlined,
          size: 48,
          color: TossColors.textTertiary,
        ),
        const SizedBox(height: TossSpacing.space3),
        Text(
          'No stores available',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        OutlinedButton(
          onPressed: onClose,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
