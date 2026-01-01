import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Footer widget for AddTransactionDialog
///
/// Contains Cancel and Add/Update buttons.
/// Automatically hides when keyboard is visible.
class DialogFooter extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onSave;

  const DialogFooter({
    super.key,
    required this.isEditing,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Hide footer when keyboard is visible
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              Expanded(
                child: TossSecondaryButton(
                  text: 'Cancel',
                  onPressed: () => context.pop(),
                  fullWidth: true,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TossPrimaryButton(
                  text: isEditing ? 'Update' : 'Add',
                  onPressed: onSave,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
