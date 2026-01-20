import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';

/// 건강도 지표 카드 위젯
/// 품절/긴급/재주문/Dead Stock 등 지표 표시
class HealthMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final double percentage;
  final Color color;
  final VoidCallback? onTap;

  const HealthMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    this.onTap,
  });

  /// 품절 카드 팩토리
  factory HealthMetricCard.stockout({
    required int count,
    required double rate,
    VoidCallback? onTap,
  }) {
    return HealthMetricCard(
      icon: Icons.inventory_2_outlined,
      label: 'Stockout',
      count: count,
      percentage: rate,
      color: TossColors.error,
      onTap: onTap,
    );
  }

  /// 긴급 카드 팩토리
  factory HealthMetricCard.critical({
    required int count,
    required double rate,
    VoidCallback? onTap,
  }) {
    return HealthMetricCard(
      icon: Icons.local_fire_department_rounded,
      label: 'Critical',
      count: count,
      percentage: rate,
      color: TossColors.amber,
      onTap: onTap,
    );
  }

  /// 재주문 카드 팩토리
  factory HealthMetricCard.reorder({
    required int count,
    required double rate,
    VoidCallback? onTap,
  }) {
    return HealthMetricCard(
      icon: Icons.shopping_cart_outlined,
      label: 'Reorder',
      count: count,
      percentage: rate,
      color: TossColors.primary,
      onTap: onTap,
    );
  }

  /// Dead Stock 카드 팩토리
  factory HealthMetricCard.deadStock({
    required int count,
    required double rate,
    VoidCallback? onTap,
  }) {
    return HealthMetricCard(
      icon: Icons.hourglass_empty_rounded,
      label: 'Dead Stock',
      count: count,
      percentage: rate,
      color: TossColors.textSecondary,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.card),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.paddingSM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.card),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: TossSpacing.iconSM),
                const SizedBox(width: TossSpacing.gapXS),
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.gapSM),
            Text(
              '$count',
              style: TossTextStyles.h3.copyWith(
                color: color,
                fontWeight: TossFontWeight.bold,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 건강도 지표 그리드 위젯
/// 4개 카드를 2x2 그리드로 표시
class HealthMetricsGrid extends StatelessWidget {
  final int stockoutCount;
  final double stockoutRate;
  final int criticalCount;
  final double criticalRate;
  final int reorderCount;
  final double reorderRate;
  final int deadStockCount;
  final double deadStockRate;
  final void Function(String filter)? onTap;

  const HealthMetricsGrid({
    super.key,
    required this.stockoutCount,
    required this.stockoutRate,
    required this.criticalCount,
    required this.criticalRate,
    required this.reorderCount,
    required this.reorderRate,
    required this.deadStockCount,
    required this.deadStockRate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: HealthMetricCard.stockout(
                  count: stockoutCount,
                  rate: stockoutRate,
                  onTap: onTap != null ? () => onTap!('stockout') : null,
                ),
              ),
              const SizedBox(width: TossSpacing.gapMD),
              Expanded(
                child: HealthMetricCard.critical(
                  count: criticalCount,
                  rate: criticalRate,
                  onTap: onTap != null ? () => onTap!('critical') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.gapMD),
          Row(
            children: [
              Expanded(
                child: HealthMetricCard.reorder(
                  count: reorderCount,
                  rate: reorderRate,
                  onTap: onTap != null ? () => onTap!('reorder_needed') : null,
                ),
              ),
              const SizedBox(width: TossSpacing.gapMD),
              Expanded(
                child: HealthMetricCard.deadStock(
                  count: deadStockCount,
                  rate: deadStockRate,
                  onTap: onTap != null ? () => onTap!('dead_stock') : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
