import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header widget for AddTransactionDialog
///
/// Contains drag handle, title, and close button.
class DialogHeader extends StatelessWidget {
  final bool isEditing;

  const DialogHeader({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: TossColors.gray300,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),

        // Header
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'Edit Transaction' : 'Add Transaction',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: TossColors.gray600),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: TossColors.gray200),
      ],
    );
  }
}
