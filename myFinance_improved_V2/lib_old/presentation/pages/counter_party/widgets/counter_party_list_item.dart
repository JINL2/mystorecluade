import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../constants/counter_party_colors.dart';
import '../models/counter_party_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

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
          padding: EdgeInsets.all(TossSpacing.space4),
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
              SizedBox(width: TossSpacing.space3),
              
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
                            counterParty.name,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (counterParty.isInternal) ...[
                          SizedBox(width: TossSpacing.space2),
                          Container(
                            padding: EdgeInsets.symmetric(
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
                    
                    SizedBox(height: TossSpacing.space1),
                    
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
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Last transaction: ${_formatDate(counterParty.lastTransactionDate!)}',
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
                icon: Icon(
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
    TossBottomSheet.show(
      context: context,
      title: 'Options',
      content: SizedBox.shrink(),
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
        TossActionItem(
          title: 'Delete',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: () => _showDeleteConfirmation(context),
        ),
      ],
    );
  }


  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Counter Party',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${counterParty.name}"? This action cannot be undone.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: Text(
              'Delete',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}