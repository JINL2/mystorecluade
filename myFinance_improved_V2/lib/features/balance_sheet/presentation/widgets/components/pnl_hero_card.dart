import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../domain/entities/pnl_summary.dart';

/// P&L Hero Card - Main metrics display
class PnlHeroCard extends StatelessWidget {
  final PnlSummary summary;
  final String currencySymbol;

  const PnlHeroCard({
    super.key,
    required this.summary,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = summary.netIncome >= 0;
    final formatter = NumberFormat('#,##0', 'en_US');

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net Income Label
          Text(
            'Net Income',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),

          const SizedBox(height: TossSpacing.space2),

          // Net Income Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '${isProfit ? '' : '-'}$currencySymbol${formatter.format(summary.netIncome.abs())}',
                  style: TossTextStyles.h1.copyWith(
                    color: isProfit ? TossColors.gray900 : TossColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Change indicator
              if (summary.netIncomeChangePct != null)
                _buildChangeIndicator(summary.netIncomeChangePct!),
            ],
          ),

          const SizedBox(height: TossSpacing.space5),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Summary Row - Revenue, Gross Profit, Operating Income
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  'Revenue',
                  summary.revenue,
                  100.0, // Base reference for margin calculation
                ),
              ),
              Expanded(
                child: _buildMetric(
                  'Gross',
                  summary.grossProfit,
                  summary.grossMargin,
                ),
              ),
              Expanded(
                child: _buildMetric(
                  'Operating',
                  summary.operatingIncome,
                  summary.operatingMargin,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Margin Bar
          _buildMarginBar(),
        ],
      ),
    );
  }

  Widget _buildChangeIndicator(double changePct) {
    final isPositive = changePct >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: isPositive
            ? TossColors.success.withValues(alpha: 0.1)
            : TossColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: isPositive ? TossColors.success : TossColors.error,
          ),
          const SizedBox(width: 2),
          Text(
            '${changePct.abs().toStringAsFixed(1)}%',
            style: TossTextStyles.caption.copyWith(
              color: isPositive ? TossColors.success : TossColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, double value, double? margin) {
    final formatter = NumberFormat.compact(locale: 'en_US');
    final isNegative = value < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          '${isNegative ? '-' : ''}$currencySymbol${formatter.format(value.abs())}',
          style: TossTextStyles.bodyMedium.copyWith(
            color: isNegative ? TossColors.error : TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (margin != null)
          Text(
            '${margin.toStringAsFixed(1)}%',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 11,
            ),
          ),
      ],
    );
  }

  Widget _buildMarginBar() {
    // Simple visual representation of margins
    final grossMarginWidth = (summary.grossMargin / 100).clamp(0.0, 1.0);
    final operatingMarginWidth = (summary.operatingMargin / 100).clamp(0.0, 1.0);
    final netMarginWidth = (summary.netMargin / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Margin Analysis',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            _buildMarginItem('Gross', summary.grossMargin, TossColors.gray300),
            const SizedBox(width: TossSpacing.space3),
            _buildMarginItem('Operating', summary.operatingMargin, TossColors.gray400),
            const SizedBox(width: TossSpacing.space3),
            _buildMarginItem('Net', summary.netMargin, TossColors.gray900),
          ],
        ),
      ],
    );
  }

  Widget _buildMarginItem(String label, double margin, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${margin.toStringAsFixed(1)}%',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
