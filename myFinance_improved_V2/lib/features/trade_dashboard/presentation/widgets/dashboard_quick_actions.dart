import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Quick action buttons for dashboard - Simple horizontal scroll
/// Uses shared widgets from trade_shared
class DashboardQuickActions extends StatelessWidget {
  final VoidCallback? onCreatePI;
  final VoidCallback? onViewLC;
  final VoidCallback? onViewShipments;
  final VoidCallback? onViewReports;

  const DashboardQuickActions({
    super.key,
    this.onCreatePI,
    this.onViewLC,
    this.onViewShipments,
    this.onViewReports,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Quick Actions'),
        const SizedBox(height: TossSpacing.space2),
        TradeActionChipsRow(
          chips: [
            TradeActionChipData(
              icon: Icons.add,
              label: 'New PI',
              color: TossColors.primary,
              onTap: onCreatePI,
            ),
            TradeActionChipData(
              icon: Icons.verified_outlined,
              label: 'L/C',
              color: TossColors.success,
              onTap: onViewLC,
            ),
            TradeActionChipData(
              icon: Icons.local_shipping_outlined,
              label: 'Shipments',
              color: TossColors.warning,
              onTap: onViewShipments,
            ),
            TradeActionChipData(
              icon: Icons.analytics_outlined,
              label: 'Reports',
              color: TossColors.info,
              onTap: onViewReports,
            ),
          ],
        ),
      ],
    );
  }
}
