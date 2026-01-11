import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../../domain/entities/sales_dashboard.dart';

/// Monthly Comparison Section
/// Shows daily average comparison between this month and last month
class MonthlyComparisonSection extends StatelessWidget {
  final SalesDashboard data;

  const MonthlyComparisonSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate days for fair comparison
    final now = DateTime.now();
    final thisMonthDays = now.day; // Days elapsed this month
    final lastMonthDays =
        DateTime(now.year, now.month, 0).day; // Total days last month

    // Calculate daily averages
    final thisMonthDailyRevenue =
        thisMonthDays > 0 ? data.thisMonth.revenue / thisMonthDays : 0;
    final lastMonthDailyRevenue =
        lastMonthDays > 0 ? data.lastMonth.revenue / lastMonthDays : 0;
    final thisMonthDailyMargin =
        thisMonthDays > 0 ? data.thisMonth.margin / thisMonthDays : 0;
    final lastMonthDailyMargin =
        lastMonthDays > 0 ? data.lastMonth.margin / lastMonthDays : 0;
    final thisMonthDailyQuantity =
        thisMonthDays > 0 ? data.thisMonth.quantity / thisMonthDays : 0;
    final lastMonthDailyQuantity =
        lastMonthDays > 0 ? data.lastMonth.quantity / lastMonthDays : 0;

    // Calculate daily average growth percentages
    final dailyRevenueGrowth = lastMonthDailyRevenue > 0
        ? ((thisMonthDailyRevenue - lastMonthDailyRevenue) /
            lastMonthDailyRevenue *
            100)
        : 0.0;
    final dailyMarginGrowth = lastMonthDailyMargin > 0
        ? ((thisMonthDailyMargin - lastMonthDailyMargin) /
            lastMonthDailyMargin *
            100)
        : 0.0;
    final dailyQuantityGrowth = lastMonthDailyQuantity > 0
        ? ((thisMonthDailyQuantity - lastMonthDailyQuantity) /
            lastMonthDailyQuantity *
            100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Daily Average Comparison',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space1_5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    '$thisMonthDays vs $lastMonthDays days',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            _ComparisonRow(
              label: 'Revenue',
              thisMonth: thisMonthDailyRevenue,
              lastMonth: lastMonthDailyRevenue,
              growth: dailyRevenueGrowth,
              suffix: '/day',
            ),
            const SizedBox(height: TossSpacing.space3),
            _ComparisonRow(
              label: 'Margin',
              thisMonth: thisMonthDailyMargin,
              lastMonth: lastMonthDailyMargin,
              growth: dailyMarginGrowth,
              suffix: '/day',
            ),
            const SizedBox(height: TossSpacing.space3),
            _ComparisonRow(
              label: 'Quantity',
              thisMonth: thisMonthDailyQuantity,
              lastMonth: lastMonthDailyQuantity,
              growth: dailyQuantityGrowth,
              isQuantity: true,
              suffix: '/day',
            ),
          ],
        ),
      ),
    );
  }
}

/// Single comparison row showing this month vs last month
class _ComparisonRow extends StatelessWidget {
  final String label;
  final num thisMonth;
  final num lastMonth;
  final num growth;
  final bool isQuantity;
  final String suffix;

  const _ComparisonRow({
    required this.label,
    required this.thisMonth,
    required this.lastMonth,
    required this.growth,
    this.isQuantity = false,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final thisValue = isQuantity
        ? '${thisMonth.toStringAsFixed(1)}$suffix'
        : '\$${_formatCompact(thisMonth)}$suffix';
    final lastValue = isQuantity
        ? '${lastMonth.toStringAsFixed(1)}$suffix'
        : '\$${_formatCompact(lastMonth)}$suffix';

    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Month',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontSize: 10,
                ),
              ),
              Text(
                thisValue,
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Month',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontSize: 10,
                ),
              ),
              Text(
                lastValue,
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space1_5,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color:
                growth >= 0 ? TossColors.successLight : TossColors.errorLight,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
          child: Text(
            '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
            style: TossTextStyles.caption.copyWith(
              color: growth >= 0 ? TossColors.success : TossColors.error,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  /// Format large numbers compactly (e.g., 1.5B, 230M, 15K)
  String _formatCompact(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
