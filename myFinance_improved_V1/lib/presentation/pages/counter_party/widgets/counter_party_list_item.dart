import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../models/counter_party_models.dart';

class CounterPartyListItem extends StatelessWidget {
  final CounterParty counterParty;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const CounterPartyListItem({
    super.key,
    required this.counterParty,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.cardShadow,
          ),
          child: Row(
            children: [
              // Icon/Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor(counterParty.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  _getTypeIcon(counterParty.type),
                  color: _getTypeColor(counterParty.type),
                  size: 24,
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
                              color: Theme.of(context).colorScheme.onSurface,
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
                              color: TossColors.info.withOpacity(0.1),
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
                            color: _getTypeColor(counterParty.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (counterParty.email != null && counterParty.email!.isNotEmpty) ...[
                          Text(
                            ' • ',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              counterParty.email!,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                        size: 20,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(CounterPartyType type) {
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

  Color _getTypeColor(CounterPartyType type) {
    switch (type) {
      case CounterPartyType.myCompany:
        return const Color(0xFF007AFF); // Blue
      case CounterPartyType.teamMember:
        return const Color(0xFF34C759); // Green
      case CounterPartyType.supplier:
        return const Color(0xFF5856D6); // Purple
      case CounterPartyType.employee:
        return const Color(0xFFFF9500); // Orange
      case CounterPartyType.customer:
        return const Color(0xFFFF3B30); // Red
      case CounterPartyType.other:
        return const Color(0xFF8E8E93); // Gray
    }
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