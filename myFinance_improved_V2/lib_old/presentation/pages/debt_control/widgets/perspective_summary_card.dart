import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/utils/number_formatter.dart';
import '../models/internal_counterparty_models.dart';
import '../providers/currency_provider.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Enhanced summary card showing perspective-aware debt positions
class PerspectiveSummaryCard extends ConsumerWidget {
  final PerspectiveDebtSummary summary;
  final VoidCallback? onTap;
  
  const PerspectiveSummaryCard({
    super.key,
    required this.summary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(debtCurrencyProvider);
    final netPositive = summary.netPosition >= 0;
    final internalPositive = summary.internalNetPosition >= 0;
    final externalPositive = summary.externalNetPosition >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: netPositive
              ? [TossColors.primary, TossColors.primary.withValues(alpha: 0.8)]
              : [TossColors.error, TossColors.error.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.cardLarge),
          boxShadow: [
            BoxShadow(
              color: (netPositive ? TossColors.primary : TossColors.error)
                .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        _getPerspectiveIcon(),
                        color: TossColors.textInverse.withValues(alpha: 0.9),
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary.entityName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.textInverse,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getPerspectiveLabel(),
                              style: TossTextStyles.small.copyWith(
                                color: TossColors.textInverse.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TossColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(TossBorderRadius.buttonPill),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.handshake,
                              size: 14,
                              color: TossColors.textInverse,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${summary.counterpartyCount} counterparties',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textInverse,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Net Position
                  Text(
                    'Net Position',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textInverse.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormatter.formatCurrency(summary.netPosition.abs(), currency),
                    style: TossTextStyles.display.copyWith(
                      color: TossColors.textInverse,
                    ),
                  ),
                  Text(
                    netPositive ? 'Net Receivable' : 'Net Payable',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textInverse.withValues(alpha: 0.9),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Internal vs External breakdown
                  Row(
                    children: [
                      Expanded(
                        child: _buildBreakdownBox(
                          title: 'Internal',
                          icon: Icons.business,
                          amount: summary.internalNetPosition,
                          isPositive: internalPositive,
                          receivable: summary.internalReceivable,
                          payable: summary.internalPayable,
                          currency: currency,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: _buildBreakdownBox(
                          title: 'External',
                          icon: Icons.public,
                          amount: summary.externalNetPosition,
                          isPositive: externalPositive,
                          receivable: summary.externalReceivable,
                          payable: summary.externalPayable,
                          currency: currency,
                        ),
                      ),
                    ],
                  ),
                  
                  // Store aggregates (for company view)
                  if (summary.perspectiveType == 'company' && summary.storeAggregates.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space4),
                    Container(
                      height: 1,
                      color: TossColors.white.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                    Text(
                      'Debt by Store',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textInverse.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    SizedBox(
                      height: 70, // Increased height to prevent overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: summary.storeAggregates.length,
                        itemBuilder: (context, index) {
                          final store = summary.storeAggregates[index];
                          
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Increased padding
                            decoration: BoxDecoration(
                              color: TossColors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              border: Border.all(
                                color: TossColors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Use minimum space needed
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min, // Don't expand unnecessarily
                                  children: [
                                    if (store.isHeadquarters) ...[
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: TossColors.warning,
                                      ),
                                      const SizedBox(width: 2),
                                    ],
                                    Flexible(
                                      child: Text(
                                        store.storeName.length > 12
                                          ? '${store.storeName.substring(0, 12)}...'
                                          : store.storeName,
                                        style: TossTextStyles.small.copyWith(
                                          color: TossColors.textInverse,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11, // Slightly smaller to fit better
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2), // Reduced spacing
                                Text(
                                  NumberFormatter.formatCompact(store.netPosition.abs()),
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.textInverse.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '${store.counterpartyCount}p', // Shortened text
                                  style: TossTextStyles.small.copyWith(
                                    color: TossColors.textInverse.withValues(alpha: 0.7),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  
              // No bottom metrics needed for retail debt control
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownBox({
    required String title,
    required IconData icon,
    required double amount,
    required bool isPositive,
    required double receivable,
    required double payable,
    required String currency,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: TossColors.textInverse.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.textInverse.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            NumberFormatter.formatCurrency(amount.abs(), currency),
            style: TossTextStyles.body.copyWith(
              color: TossColors.textInverse,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TossTextStyles.small,
                    children: [
                      TextSpan(
                        text: 'R: ',
                        style: TossTextStyles.body.copyWith(color: TossColors.textInverse.withValues(alpha: 0.6)),
                      ),
                      TextSpan(
                        text: NumberFormatter.formatCompact(receivable),
                        style: TossTextStyles.body.copyWith(color: TossColors.textInverse.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TossTextStyles.small,
                  children: [
                    TextSpan(
                      text: 'P: ',
                      style: TossTextStyles.body.copyWith(color: TossColors.textInverse.withValues(alpha: 0.6)),
                    ),
                    TextSpan(
                      text: NumberFormatter.formatCompact(payable),
                      style: TossTextStyles.body.copyWith(color: TossColors.textInverse.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  IconData _getPerspectiveIcon() {
    switch (summary.perspectiveType) {
      case 'company':
        return Icons.business;
      case 'store':
        return Icons.store;
      case 'group':
        return Icons.corporate_fare;
      default:
        return Icons.account_balance;
    }
  }

  String _getPerspectiveLabel() {
    switch (summary.perspectiveType) {
      case 'company':
        return 'Company-wide view (all stores aggregated)';
      case 'store':
        return 'Store-specific view';
      case 'group':
        return 'Group consolidation view';
      default:
        return 'Debt overview';
    }
  }
}