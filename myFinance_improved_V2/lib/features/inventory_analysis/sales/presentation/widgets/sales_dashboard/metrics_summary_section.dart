import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../../domain/entities/sales_dashboard.dart';
import '../../../../shared/presentation/widgets/analytics_widgets.dart';

/// Key Metrics Summary Section
/// Shows total revenue, margin, margin rate, and quantity sold
class MetricsSummarySection extends StatelessWidget {
  final SalesDashboard data;

  const MetricsSummarySection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month Performance',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: AnalyticsMetricTile(
                    label: 'Total Revenue',
                    value: '\$${_formatCompact(data.thisMonth.revenue)}',
                    trend: data.growth.revenuePct != 0
                        ? '${data.growth.revenuePct > 0 ? '+' : ''}${data.growth.revenuePct.toStringAsFixed(1)}%'
                        : null,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: TossColors.gray200,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: TossSpacing.space4),
                    child: AnalyticsMetricTile(
                      label: 'Total Margin',
                      value: '\$${_formatCompact(data.thisMonth.margin)}',
                      trend: data.growth.marginPct != 0
                          ? '${data.growth.marginPct > 0 ? '+' : ''}${data.growth.marginPct.toStringAsFixed(1)}%'
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: AnalyticsMetricTile(
                    label: 'Margin Rate',
                    value: '${data.thisMonth.marginRate.toStringAsFixed(1)}%',
                    valueColor: data.thisMonth.marginRate >= 20
                        ? TossColors.success
                        : data.thisMonth.marginRate >= 10
                            ? TossColors.warning
                            : TossColors.error,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: TossColors.gray200,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: TossSpacing.space4),
                    child: AnalyticsMetricTile(
                      label: 'Quantity Sold',
                      value:
                          '${NumberFormat('#,###').format(data.thisMonth.quantity)} units',
                      trend: data.growth.quantityPct != 0
                          ? '${data.growth.quantityPct > 0 ? '+' : ''}${data.growth.quantityPct.toStringAsFixed(1)}%'
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
    return NumberFormat('#,###').format(value);
  }
}
