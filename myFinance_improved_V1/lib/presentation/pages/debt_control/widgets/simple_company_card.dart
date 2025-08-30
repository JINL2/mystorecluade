import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/navigation/safe_navigation.dart';

/// Simplified company card for debt control
class SimpleCompanyCard extends StatelessWidget {
  final String counterpartyId;
  final String counterpartyName;
  final double netBalance;
  final String counterpartyType; // 'internal' or 'external'
  final DateTime? lastTransactionDate;
  final bool isCurrentCompany;

  const SimpleCompanyCard({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
    required this.netBalance,
    required this.counterpartyType,
    this.lastTransactionDate,
    this.isCurrentCompany = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = netBalance >= 0;
    final isGroup = counterpartyType == 'internal';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        // Subtle left border for group companies
        border: isGroup ? Border(
          left: BorderSide(
            color: TossColors.primary,
            width: 3,
          ),
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to debt relationship detail page
          context.safePush(
            '/debtRelationship/${Uri.encodeComponent(counterpartyId)}',
            extra: {
              'counterpartyId': counterpartyId,
              'counterpartyName': counterpartyName,
            },
          );
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Company Info - No avatar for maximum space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name only - badges moved to corner
                    Text(
                      counterpartyName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // Last transaction or status
                    Text(
                      lastTransactionDate != null
                        ? 'Last activity ${_formatDate(lastTransactionDate!)}'
                        : 'No recent activity',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormatter.formatCurrency(netBalance.abs(), '₫'),
                    style: TossTextStyles.body.copyWith(
                      color: isPositive ? TossColors.success : TossColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPositive ? 'They owe us' : 'We owe them',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}m ago';
    }
  }
}