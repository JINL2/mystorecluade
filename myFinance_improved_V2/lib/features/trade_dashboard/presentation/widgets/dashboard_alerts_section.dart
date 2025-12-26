import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/domain/entities/trade_alert.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Dashboard alerts section
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
    final highCount = alerts.where((a) => a.priority == AlertPriority.high).length;

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: urgentCount > 0
              ? TossColors.error.withOpacity(0.3)
              : TossColors.gray200,
          width: 1,
        ),
        boxShadow: urgentCount > 0
            ? [
                BoxShadow(
                  color: TossColors.error.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: urgentCount > 0
                  ? TossColors.error.withOpacity(0.05)
                  : TossColors.warning.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.lg - 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: urgentCount > 0
                        ? TossColors.error.withOpacity(0.15)
                        : TossColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    urgentCount > 0
                        ? Icons.warning_amber_rounded
                        : Icons.notifications_active_outlined,
                    color: urgentCount > 0 ? TossColors.error : TossColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attention Required',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      Text(
                        _getAlertSummary(urgentCount, highCount),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (totalCount > alerts.length)
                  TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View all',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            totalCount.toString(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Alert list
          ...alerts.asMap().entries.map((entry) {
            final index = entry.key;
            final alert = entry.value;
            final isLast = index == alerts.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: TradeAlertCard(
                    alert: alert,
                    onTap: () {
                      // TODO: Navigate to related entity
                    },
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: TossSpacing.space4,
                    endIndent: TossSpacing.space4,
                    color: TossColors.gray100,
                  ),
              ],
            );
          }),

          const SizedBox(height: TossSpacing.space2),
        ],
      ),
    );
  }

  String _getAlertSummary(int urgentCount, int highCount) {
    final parts = <String>[];
    if (urgentCount > 0) {
      parts.add('$urgentCount urgent');
    }
    if (highCount > 0) {
      parts.add('$highCount high priority');
    }
    if (parts.isEmpty) {
      return '${alerts.length} alerts need attention';
    }
    return parts.join(', ');
  }
}
