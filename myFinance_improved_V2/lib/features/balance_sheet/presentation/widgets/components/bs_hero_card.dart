import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../domain/entities/bs_summary.dart';

/// B/S Hero Card - Main balance sheet metrics
class BsHeroCard extends StatelessWidget {
  final BsSummary summary;
  final String currencySymbol;

  const BsHeroCard({
    super.key,
    required this.summary,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final compactFormatter = NumberFormat.compact(locale: 'en_US');

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
          // Total Assets
          Text(
            'Total Assets',
            style: TossTextStyles.captionGray500,
          ),

          const SizedBox(height: TossSpacing.space2),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '$currencySymbol${formatter.format(summary.totalAssets)}',
                  style: TossTextStyles.h1Bold,
                ),
              ),

              // Change indicator
              if (summary.assetsChangePct != null)
                _buildChangeIndicator(summary.assetsChangePct!),
            ],
          ),

          const SizedBox(height: TossSpacing.space5),

          // Balance Equation Visualization
          _buildBalanceEquation(compactFormatter),

          const SizedBox(height: TossSpacing.space4),

          // Divider
          Container(height: 1, color: TossColors.gray100),

          const SizedBox(height: TossSpacing.space4),

          // Three columns: Assets, Liabilities, Equity
          Row(
            children: [
              Expanded(
                child: _buildMetricColumn(
                  'Assets',
                  summary.totalAssets,
                  [
                    ('Current', summary.currentAssets),
                    ('Non-Current', summary.nonCurrentAssets),
                  ],
                  compactFormatter,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: TossColors.gray100,
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Liabilities',
                  summary.totalLiabilities,
                  [
                    ('Current', summary.currentLiabilities),
                    ('Non-Current', summary.nonCurrentLiabilities),
                  ],
                  compactFormatter,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: TossColors.gray100,
              ),
              Expanded(
                child: _buildMetricColumn(
                  'Equity',
                  summary.totalEquity,
                  [
                    ('D/E Ratio', summary.totalLiabilities / (summary.totalEquity != 0 ? summary.totalEquity : 1)),
                    ('Equity %', summary.totalAssets != 0 ? (summary.totalEquity / summary.totalAssets * 100) : 0),
                  ],
                  compactFormatter,
                  isRatio: true,
                ),
              ),
            ],
          ),

          // Balance Check Warning
          if (!summary.isBalanced) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildBalanceWarning(formatter),
          ],
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
            style: TossTextStyles.captionBold.copyWith(
              color: isPositive ? TossColors.success : TossColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceEquation(NumberFormat formatter) {
    final total = summary.totalAssets;
    final liabilitiesRatio = total > 0 ? summary.totalLiabilities / total : 0.0;
    final equityRatio = total > 0 ? summary.totalEquity / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assets = Liabilities + Equity',
          style: TossTextStyles.captionGray500,
        ),
        const SizedBox(height: TossSpacing.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          child: Row(
            children: [
              // Liabilities portion
              Expanded(
                flex: (liabilitiesRatio * 100).round().clamp(1, 99),
                child: Container(
                  height: 8,
                  color: TossColors.gray400,
                ),
              ),
              // Equity portion
              Expanded(
                flex: (equityRatio * 100).round().clamp(1, 99),
                child: Container(
                  height: 8,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            _buildLegendItem('Liabilities', TossColors.gray400,
                '${(liabilitiesRatio * 100).toStringAsFixed(0)}%'),
            const SizedBox(width: TossSpacing.space4),
            _buildLegendItem('Equity', TossColors.gray700,
                '${(equityRatio * 100).toStringAsFixed(0)}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2),
          ),
        ),
        const SizedBox(width: TossSpacing.space1),
        Text(
          '$label $value',
          style: TossTextStyles.captionGray600,
        ),
      ],
    );
  }

  Widget _buildMetricColumn(
    String title,
    double total,
    List<(String, double)> breakdown,
    NumberFormat formatter, {
    bool isRatio = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TossTextStyles.captionGray500,
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            '$currencySymbol${formatter.format(total)}',
            style: TossTextStyles.bodyMediumBold,
          ),
          if (breakdown.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space1),
            ...breakdown.map((item) => Text(
                  isRatio
                      ? '${item.$1}: ${item.$2.toStringAsFixed(1)}${item.$1.contains('%') ? '%' : 'x'}'
                      : '${item.$1}: ${formatter.format(item.$2)}',
                  style: TossTextStyles.captionGray500,
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceWarning(NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: TossColors.warning,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unreconciled: $currencySymbol${formatter.format(summary.balanceCheck.abs())} (unclosed P&L)',
              style: TossTextStyles.captionGray700,
            ),
          ),
        ],
      ),
    );
  }
}
