import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../trade_shared/domain/entities/dashboard_summary.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Dashboard overview section with key metrics - Simple clean design
/// Uses shared widgets from trade_shared
class DashboardOverviewSection extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardOverviewSection({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Trade Volume - Simple white card
        TradeSimpleAmountCard(
          title: 'Total Trade Volume',
          amount: _formatAmount(summary.overview.totalTradeVolume),
          currency: 'USD',
        ),

        const SizedBox(height: TossSpacing.space3),

        // Status overview - Horizontal scroll chips
        TradeStatChipsRow(
          chips: [
            TradeStatChipData(
              label: 'Active L/C',
              value: summary.overview.activeLCCount.toString(),
              color: TossColors.success,
            ),
            TradeStatChipData(
              label: 'In Transit',
              value: summary.overview.inTransitCount.toString(),
              color: TossColors.primary,
            ),
            TradeStatChipData(
              label: 'PI',
              value: summary.overview.totalPICount.toString(),
              color: TossColors.gray500,
            ),
            TradeStatChipData(
              label: 'PO',
              value: summary.overview.totalPOCount.toString(),
              color: TossColors.gray500,
            ),
            TradeStatChipData(
              label: 'Shipment',
              value: summary.overview.totalShipmentCount.toString(),
              color: TossColors.warning,
            ),
          ],
        ),

        // Payment schedule preview (only if pending)
        if (summary.overview.pendingPayments > 0) ...[
          const SizedBox(height: TossSpacing.space3),
          TradeSimpleInfoRow(
            label: 'Pending Payment',
            value: summary.overview.pendingPayments.toString(),
            amount: 'USD ${_formatAmount(summary.overview.pendingPaymentAmount)}',
            dotColor: TossColors.warning,
            showChevron: true,
          ),
        ],
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
