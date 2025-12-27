import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../trade_shared/domain/entities/trade_alert.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Dashboard alerts section - Simple clean design
/// Uses shared widgets from trade_shared
class DashboardAlertsSection extends StatelessWidget {
  final List<TradeAlert> alerts;
  final int totalCount;
  final VoidCallback? onViewAll;

  const DashboardAlertsSection({
    super.key,
    required this.alerts,
    this.totalCount = 0,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    final urgentCount = alerts.where((a) => a.priority == AlertPriority.urgent).length;
    final dotColor = urgentCount > 0 ? TossColors.error : TossColors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        TradeSectionHeader(
          title: 'Alerts',
          badge: '${alerts.length}',
          badgeColor: dotColor,
          dotColor: dotColor,
          actionLabel: totalCount > alerts.length ? 'View all' : null,
          onAction: onViewAll,
        ),
        const SizedBox(height: TossSpacing.space2),

        // Alert list - simple cards
        TradeSimpleListCard(
          items: alerts.map((alert) {
            final isUrgent = alert.priority == AlertPriority.urgent;
            return TradeSimpleListItemData(
              title: alert.title,
              subtitle: alert.message,
              dotColor: isUrgent ? TossColors.error : TossColors.warning,
              onTap: () {
                // TODO: Navigate to related entity
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
