import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/domain/entities/dashboard_summary.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Dashboard overview section with key metrics
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
        // Total Trade Volume Card
        _buildTotalVolumeCard(),

        const SizedBox(height: TossSpacing.space4),

        // Status overview grid
        _buildStatusGrid(),

        const SizedBox(height: TossSpacing.space4),

        // Payment schedule preview
        if (summary.overview.pendingPayments > 0)
          _buildPaymentSchedulePreview(),
      ],
    );
  }

  Widget _buildTotalVolumeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary,
            TossColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: TossColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: TossColors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: TossColors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Active',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Total Trade Volume',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'USD',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatAmount(summary.overview.totalTradeVolume),
                style: TossTextStyles.h1.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              _buildMiniStat(
                'Active L/C',
                summary.overview.activeLCCount.toString(),
                Icons.verified_outlined,
              ),
              const SizedBox(width: TossSpacing.space4),
              _buildMiniStat(
                'In Transit',
                summary.overview.inTransitCount.toString(),
                Icons.local_shipping_outlined,
              ),
              const SizedBox(width: TossSpacing.space4),
              _buildMiniStat(
                'Pending',
                summary.overview.pendingPayments.toString(),
                Icons.schedule_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: TossColors.white.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TossTextStyles.h4.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.white.withOpacity(0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TradeCompactSummaryCard(
                title: 'Proforma Invoices',
                value: summary.overview.totalPICount.toString(),
                icon: Icons.description_outlined,
                color: TossColors.info,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TradeCompactSummaryCard(
                title: 'Purchase Orders',
                value: summary.overview.totalPOCount.toString(),
                icon: Icons.receipt_long_outlined,
                color: TossColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TradeCompactSummaryCard(
                title: 'Letters of Credit',
                value: summary.overview.totalLCCount.toString(),
                icon: Icons.verified_outlined,
                color: TossColors.success,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TradeCompactSummaryCard(
                title: 'Shipments',
                value: summary.overview.totalShipmentCount.toString(),
                icon: Icons.local_shipping_outlined,
                color: TossColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSchedulePreview() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 20,
                color: TossColors.warning,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'Upcoming Payments',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Text(
                  '${summary.overview.pendingPayments} pending',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pending',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'USD ${_formatAmount(summary.overview.pendingPaymentAmount)}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to payment schedule
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View schedule',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: TossColors.primary,
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

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
