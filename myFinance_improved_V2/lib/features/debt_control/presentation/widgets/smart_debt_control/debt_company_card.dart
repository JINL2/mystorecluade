// lib/features/debt_control/presentation/widgets/smart_debt_control/debt_company_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_badge.dart';
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../domain/entities/prioritized_debt.dart';

/// Debt Company Card Widget
///
/// Displays a single company's debt information with visual indicators
/// for internal/external status and receivable/payable amounts.
class DebtCompanyCard extends StatelessWidget {
  final PrioritizedDebt debt;
  final String currency;

  const DebtCompanyCard({
    super.key,
    required this.debt,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = debt.amount > 0;
    final isInternal = debt.isInternal;

    // Color scheme based on internal/external
    final accentColor = isInternal ? TossColors.primary : TossColors.warning;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: TossCard(
        onTap: () {
          // Navigate to transaction history page to view debt details
          context.push(
            '/transactionHistory?counterpartyId=${debt.counterpartyId}&counterpartyName=${Uri.encodeComponent(debt.counterpartyName)}&scope=all',
          );
        },
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Colored vertical bar indicating internal/external
            Container(
              width: 4,
              height: 68,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Company info with internal/external badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name with type badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          debt.counterpartyName,
                          style: TossTextStyles.h4.copyWith(
                            color: TossColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      TossBadge(
                        label: isInternal ? 'My Group' : 'External',
                        backgroundColor: isInternal
                            ? TossColors.primary.withValues(alpha: 0.1)
                            : TossColors.warning.withValues(alpha: 0.1),
                        textColor: accentColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        borderRadius: TossBorderRadius.full,
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  // Last activity with icon
                  TossBadge(
                    label: _formatLastActivity(debt.lastContactDate),
                    icon: Icons.access_time_rounded,
                    iconSize: 12,
                    backgroundColor: TossColors.transparent,
                    textColor: TossColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Transaction count
                  TossBadge(
                    label: '${debt.transactionCount} transactions',
                    icon: Icons.receipt_long_outlined,
                    iconSize: 12,
                    backgroundColor: TossColors.transparent,
                    textColor: TossColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Amount and status badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Amount with financial number styling
                Text(
                  NumberFormatter.formatCurrency(debt.amount.abs(), currency),
                  style: TossTextStyles.amount.copyWith(
                    color: isPositive ? TossColors.success : TossColors.error,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                // Direction badge with icon
                TossBadge(
                  label: isPositive ? 'Receivable' : 'Payable',
                  icon: isPositive
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  iconSize: 10,
                  backgroundColor: isPositive
                      ? TossColors.success.withValues(alpha: 0.12)
                      : TossColors.error.withValues(alpha: 0.12),
                  textColor: isPositive ? TossColors.success : TossColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  borderRadius: TossBorderRadius.sm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastActivity(DateTime? lastActivity) {
    if (lastActivity == null) return 'no activity';

    final now = DateTime.now();
    final difference = now.difference(lastActivity);
    final days = difference.inDays;

    if (days == 0) return 'today';
    if (days == 1) return '1d ago';
    if (days < 7) return '${days}d ago';
    if (days < 30) return '${(days / 7).floor()}w ago';
    if (days < 365) return '${(days / 30).floor()}mo ago';
    return '${(days / 365).floor()}y ago';
  }
}
