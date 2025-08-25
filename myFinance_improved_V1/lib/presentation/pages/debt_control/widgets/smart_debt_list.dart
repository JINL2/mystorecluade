import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../models/debt_control_models.dart';

/// Smart debt list with risk-prioritized sorting and contextual actions
/// 
/// Features intelligent categorization, expandable action panels,
/// and gesture-driven interactions for mobile-optimized debt management.
class SmartDebtList extends StatelessWidget {
  final List<PrioritizedDebt> debts;
  final String? expandedDebtId;
  final Function(String) onDebtTap;
  final Function(String, String) onActionTap;

  const SmartDebtList({
    super.key,
    required this.debts,
    this.expandedDebtId,
    required this.onDebtTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (debts.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(),
      );
    }

    // Group debts by risk category
    final groupedDebts = <String, List<PrioritizedDebt>>{};
    for (final debt in debts) {
      groupedDebts.putIfAbsent(debt.riskCategory, () => []).add(debt);
    }

    // Order categories by priority
    final orderedCategories = ['critical', 'attention', 'watch', 'current'];
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Calculate which category and item we're showing
          int currentIndex = 0;
          for (final category in orderedCategories) {
            final categoryDebts = groupedDebts[category] ?? [];
            
            if (index == currentIndex && categoryDebts.isNotEmpty) {
              // Return category header
              return _buildCategoryHeader(category, categoryDebts.length);
            }
            currentIndex++;
            
            // Check if index falls within this category's debts
            if (index >= currentIndex && index < currentIndex + categoryDebts.length) {
              final debtIndex = index - currentIndex;
              return _buildDebtCard(categoryDebts[debtIndex]);
            }
            currentIndex += categoryDebts.length;
          }
          
          return null;
        },
        childCount: _calculateTotalItems(groupedDebts),
      ),
    );
  }

  int _calculateTotalItems(Map<String, List<PrioritizedDebt>> groupedDebts) {
    int count = 0;
    for (final category in ['critical', 'attention', 'watch', 'current']) {
      final categoryDebts = groupedDebts[category] ?? [];
      if (categoryDebts.isNotEmpty) {
        count += 1 + categoryDebts.length; // header + debts
      }
    }
    return count;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: TossColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'No Debts Found',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'All debts are up to date or no transactions exist for the selected criteria.',
            textAlign: TextAlign.center,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String category, int count) {
    final categoryConfig = _getCategoryConfig(category);
    
    return Container(
      margin: EdgeInsets.only(
        top: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: categoryConfig.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryConfig.icon,
                  color: categoryConfig.color,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  categoryConfig.label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: categoryConfig.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Text(
            '($count)',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtCard(PrioritizedDebt debt) {
    final isExpanded = expandedDebtId == debt.id;
    final categoryConfig = _getCategoryConfig(debt.riskCategory);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onDebtTap(debt.id),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: TossAnimations.fast,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryConfig.color.withOpacity(0.3),
                width: isExpanded ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isExpanded ? 0.15 : 0.08),
                  blurRadius: isExpanded ? 12 : 4,
                  offset: Offset(0, isExpanded ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Main card content
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Counterparty avatar
                      _buildCounterpartyAvatar(debt),
                      
                      SizedBox(width: 16),
                      
                      // Debt details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    debt.counterpartyName,
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TossColors.textPrimary,
                                    ),
                                  ),
                                ),
                                _buildPriorityScore(debt.priorityScore, categoryConfig.color),
                              ],
                            ),
                            
                            SizedBox(height: 8),
                            
                            Row(
                              children: [
                                _buildStatusChip(debt.counterpartyType),
                                SizedBox(width: 12),
                                Text(
                                  '${debt.daysOverdue} days overdue',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            
                            if (debt.lastContactDate != null)
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Last contact: ${_formatDate(debt.lastContactDate!)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.textTertiary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Amount and expand indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberFormatter.formatCurrency(debt.amount, '₫'),
                            style: TossTextStyles.h4.copyWith(
                              color: debt.amount > 0 
                                  ? TossColors.error 
                                  : TossColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: TossAnimations.fast,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: TossColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Expandable actions panel
                if (isExpanded)
                  AnimatedContainer(
                    duration: TossAnimations.medium,
                    child: _buildActionPanel(debt),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterpartyAvatar(PrioritizedDebt debt) {
    final initials = debt.counterpartyName
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');

    Color avatarColor;
    switch (debt.counterpartyType) {
      case 'internal':
        avatarColor = TossColors.info;
        break;
      case 'group':
        avatarColor = TossColors.primary;
        break;
      default:
        avatarColor = TossColors.textSecondary;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: avatarColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: avatarColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TossTextStyles.bodySmall.copyWith(
            color: avatarColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityScore(double score, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${score.toInt()}',
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String type) {
    Color chipColor;
    String label;

    switch (type) {
      case 'internal':
        chipColor = TossColors.success;
        label = 'Internal';
        break;
      case 'group':
        chipColor = TossColors.primary;
        label = 'Group';
        break;
      case 'customer':
        chipColor = TossColors.info;
        label = 'Customer';
        break;
      case 'vendor':
        chipColor = TossColors.warning;
        label = 'Vendor';
        break;
      default:
        chipColor = TossColors.textSecondary;
        label = 'External';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionPanel(PrioritizedDebt debt) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Divider(height: 1, color: TossColors.borderLight),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Primary actions
                if (debt.suggestedActions.isNotEmpty)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: debt.suggestedActions
                        .where((action) => action.isPrimary)
                        .map((action) => _buildActionChip(debt.id, action))
                        .toList(),
                  ),
                
                if (debt.suggestedActions.any((a) => !a.isPrimary))
                  SizedBox(height: 12),
                
                // Secondary actions
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: debt.suggestedActions
                      .where((action) => !action.isPrimary)
                      .map((action) => _buildSecondaryAction(debt.id, action))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String debtId, SuggestedAction action) {
    final color = _parseColor(action.color);
    
    return ActionChip(
      avatar: Icon(
        _getActionIcon(action.type),
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        action.label,
        style: TossTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color,
      onPressed: () => onActionTap(debtId, action.type),
    );
  }

  Widget _buildSecondaryAction(String debtId, SuggestedAction action) {
    final color = _parseColor(action.color);
    
    return OutlinedButton.icon(
      icon: Icon(
        _getActionIcon(action.type),
        size: 16,
        color: color,
      ),
      label: Text(
        action.label,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => onActionTap(debtId, action.type),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
    );
  }

  // Helper methods
  CategoryConfig _getCategoryConfig(String category) {
    switch (category) {
      case 'critical':
        return CategoryConfig(
          label: 'Critical',
          color: TossColors.error,
          icon: Icons.priority_high,
        );
      case 'attention':
        return CategoryConfig(
          label: 'Attention',
          color: TossColors.warning,
          icon: Icons.warning,
        );
      case 'watch':
        return CategoryConfig(
          label: 'Watch',
          color: TossColors.info,
          icon: Icons.visibility,
        );
      case 'current':
        return CategoryConfig(
          label: 'Current',
          color: TossColors.success,
          icon: Icons.check_circle,
        );
      default:
        return CategoryConfig(
          label: 'Other',
          color: TossColors.textSecondary,
          icon: Icons.help_outline,
        );
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'call':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'payment_plan':
        return Icons.payment;
      case 'legal':
        return Icons.gavel;
      case 'dispute':
        return Icons.report_problem;
      case 'statement':
        return Icons.description;
      case 'payment_link':
        return Icons.link;
      case 'credit_note':
        return Icons.receipt;
      default:
        return Icons.arrow_forward;
    }
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      return TossColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class CategoryConfig {
  final String label;
  final Color color;
  final IconData icon;

  CategoryConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}