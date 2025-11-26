import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_shadows.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_confirm_cancel_dialog.dart';
import '../../../domain/entities/account_mapping.dart';

/// Account Mapping List Item Widget
///
/// Displays a single account mapping with edit/delete actions.
class AccountMappingListItem extends StatelessWidget {
  final AccountMapping mapping;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AccountMappingListItem({
    super.key,
    required this.mapping,
    required this.onEdit,
    required this.onDelete,
  });

  void _showDeleteConfirmation(BuildContext context) {
    TossConfirmCancelDialog.showDelete(
      context: context,
      title: 'Delete Mapping',
      message:
          'Are you sure you want to delete this account mapping?\n\nThis action cannot be undone.',
      onConfirm: () {
        Navigator.pop(context);
        onDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direction badge and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  mapping.direction.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: TossColors.gray600,
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: TossColors.error,
                onPressed: () => _showDeleteConfirmation(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // My Account
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Account',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mapping.myAccountName ?? 'Unknown Account',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Arrow
          Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_downward,
                size: 16,
                color: TossColors.gray400,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Linked Account
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: const Icon(
                  Icons.account_balance,
                  size: 16,
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Their Account',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mapping.linkedAccountName ?? 'Unknown Account',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (mapping.linkedCompanyName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        mapping.linkedCompanyName!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
