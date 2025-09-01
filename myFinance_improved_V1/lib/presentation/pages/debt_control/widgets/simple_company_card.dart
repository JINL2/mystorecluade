import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/navigation/safe_navigation.dart';
import '../providers/currency_provider.dart';

/// Simplified company card for debt control
class SimpleCompanyCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // Get currency from provider
    final currency = ref.watch(debtCurrencyProvider);
    
    // Determine debt relationship based on sign
    final isReceivable = netBalance > 0;  // Positive = They owe us
    final isPayable = netBalance < 0;     // Negative = We owe them
    final isInternal = counterpartyType == 'internal';
    
    // Color scheme based on debt direction
    final Color amountColor = isReceivable 
      ? TossColors.success    // Green for receivable
      : isPayable 
        ? TossColors.error     // Red for payable
        : TossColors.gray500;  // Gray for settled

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        // Subtle left border for internal companies
        border: isInternal ? Border(
          left: BorderSide(
            color: TossColors.primary,
            width: 3,
          ),
        ) : null,
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
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
        borderRadius: BorderRadius.circular(16),
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
              
              // Balance with proper sign and colors
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormatter.formatCurrency(netBalance.abs(), currency),
                    style: TossTextStyles.body.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: amountColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isReceivable 
                        ? 'They owe us' 
                        : isPayable 
                          ? 'We owe them'
                          : 'Settled',
                      style: TossTextStyles.caption.copyWith(
                        color: amountColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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