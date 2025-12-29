import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Summary cards widget showing total assets, liabilities, and equity
class BalanceSheetSummaryCards extends StatelessWidget {
  final Map<String, dynamic> totals;
  final String currencySymbol;

  const BalanceSheetSummaryCards({
    super.key,
    required this.totals,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withValues(alpha: 0.08),
            TossColors.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total Assets',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            _formatCurrency(totals['total_assets']),
            style: TossTextStyles.h1.copyWith(
              color: TossColors.gray900,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: _MiniCard(
                  label: 'Assets',
                  value: _formatCurrency(totals['total_assets']),
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _MiniCard(
                  label: 'Liabilities',
                  value: _formatCurrency(totals['total_liabilities']),
                  color: TossColors.warning,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _MiniCard(
                  label: 'Equity',
                  value: _formatCurrency(totals['total_equity']),
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '$currencySymbol 0';

    final num numAmount = (amount is num) ? amount : 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final absAmount = numAmount.abs();
    final formatted = formatter.format(absAmount);

    if (numAmount < 0) {
      return '-$currencySymbol$formatted';
    }
    return '$currencySymbol$formatted';
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
