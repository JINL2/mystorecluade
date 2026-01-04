import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/counter_party.dart';
import '../../domain/value_objects/counter_party_type.dart';
import '../../domain/value_objects/relative_time.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class CounterPartyListItem extends StatelessWidget {
  final CounterParty counterParty;
  final VoidCallback? onEdit;
  final VoidCallback? onAccountSettings;
  final VoidCallback? onDelete;

  const CounterPartyListItem({
    super.key,
    required this.counterParty,
    this.onEdit,
    this.onAccountSettings,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Row(
            children: [
              // Icon/Avatar
              Container(
                width: TossSpacing.inputHeightLG,
                height: TossSpacing.inputHeightLG,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  _getIconForType(counterParty.type),
                  color: TossColors.gray700,
                  size: 20,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            // Show linked company name for internal counterparties
                            counterParty.isInternal && counterParty.linkedCompanyName != null
                                ? counterParty.linkedCompanyName!
                                : counterParty.name,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (counterParty.isInternal) ...[
                          const SizedBox(width: TossSpacing.space2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                            child: Text(
                              'Internal',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.info,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: TossSpacing.space1),
                    
                    // Type and Contact Info
                    Row(
                      children: [
                        Text(
                          counterParty.type.displayName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (counterParty.email != null && counterParty.email!.isNotEmpty) ...[
                          Text(
                            ' • ',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              counterParty.email!,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    // Additional Info
                    if (counterParty.lastTransactionDate != null) ...[
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        'Last transaction: ${RelativeTime.format(counterParty.lastTransactionDate!)}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // More Options Button
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: TossColors.textSecondary,
                  size: TossSpacing.iconMD,
                ),
                onPressed: () => _showOptionsSheet(context),
                tooltip: 'More options',
              ),
            ],
          ),
      ),
    );
  }

  IconData _getIconForType(CounterPartyType type) {
    switch (type) {
      case CounterPartyType.myCompany:
        return Icons.business;
      case CounterPartyType.teamMember:
        return Icons.group;
      case CounterPartyType.supplier:
        return Icons.local_shipping;
      case CounterPartyType.employee:
        return Icons.badge;
      case CounterPartyType.customer:
        return Icons.people;
      case CounterPartyType.other:
        return Icons.category;
    }
  }

  void _showOptionsSheet(BuildContext context) {
    // Internal counterparty는 시스템이 자동 관리하므로 수정/삭제 불가
    final isInternal = counterParty.isInternal;

    TossBottomSheet.show<void>(
      context: context,
      title: 'Options',
      content: const SizedBox.shrink(),
      actions: [
        TossActionItem(
          title: 'Edit',
          icon: Icons.edit_outlined,
          onTap: () => onEdit?.call(),
        ),
        TossActionItem(
          title: 'Account Settings',
          icon: Icons.settings_outlined,
          onTap: () => onAccountSettings?.call(),
        ),
        if (isInternal)
          TossActionItem(
            title: 'Debt Control',
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => _navigateToDebtControl(context),
          ),
        if (!isInternal)
          TossActionItem(
            title: 'Delete',
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: () => _showDeleteConfirmation(context),
          ),
      ],
    );
  }

  void _navigateToDebtControl(BuildContext context) {
    Navigator.pop(context);
    context.push('/debtControl');
  }

  void _showDeleteConfirmation(BuildContext context) {
    TossConfirmCancelDialog.showDelete(
      context: context,
      title: 'Delete Counter Party',
      message: 'Are you sure you want to delete "${counterParty.name}"? This action cannot be undone.',
      onConfirm: () {
        Navigator.pop(context);
        onDelete?.call();
      },
    );
  }
}