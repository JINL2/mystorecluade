import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_opacity.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/account_mapping.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direction badge and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  mapping.direction.toUpperCase(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: TossSpacing.iconSM),
                color: TossColors.gray600,
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: TossDimensions.minTouchTargetSmall,
                  minHeight: TossDimensions.minTouchTargetSmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: TossSpacing.iconSM),
                color: TossColors.error,
                onPressed: () => _showDeleteConfirmation(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: TossDimensions.minTouchTargetSmall,
                  minHeight: TossDimensions.minTouchTargetSmall,
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
                width: TossDimensions.minTouchTargetSmall,
                height: TossDimensions.minTouchTargetSmall,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: TossSpacing.iconXS,
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
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      mapping.myAccountName ?? 'Unknown Account',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: TossFontWeight.semibold,
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
              SizedBox(width: TossSpacing.iconXS),
              Icon(
                Icons.arrow_downward,
                size: TossSpacing.iconXS,
                color: TossColors.gray400,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Container(
                  height: TossDimensions.dividerThickness,
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
                width: TossDimensions.minTouchTargetSmall,
                height: TossDimensions.minTouchTargetSmall,
                decoration: BoxDecoration(
                  color: TossColors.success.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: const Icon(
                  Icons.account_balance,
                  size: TossSpacing.iconXS,
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
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      mapping.linkedAccountName ?? 'Unknown Account',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                    if (mapping.linkedCompanyName != null) ...[
                      const SizedBox(height: TossSpacing.space0_5),
                      Text(
                        mapping.linkedCompanyName!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
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
