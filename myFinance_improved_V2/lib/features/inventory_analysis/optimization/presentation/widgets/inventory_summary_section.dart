import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';

/// 재고 현황 요약 섹션 (2026 트렌드 적용)
///
/// 한눈에 전체 재고 상태를 파악할 수 있는 간단한 요약 뷰
/// - 퍼센트 바로 시각화
/// - 숫자보다 비율 강조
class InventorySummarySection extends StatelessWidget {
  final int totalProducts;
  final int normalCount;
  final int reorderCount;
  final int overstockCount;
  final int deadStockCount;

  const InventorySummarySection({
    super.key,
    required this.totalProducts,
    required this.normalCount,
    required this.reorderCount,
    required this.overstockCount,
    required this.deadStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: TossSpacing.iconSM,
                color: TossColors.textSecondary,
              ),
              const SizedBox(width: TossSpacing.gapSM),
              Text(
                'Inventory Overview',
                style: TossTextStyles.subtitle.copyWith(
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
              const Spacer(),
              Text(
                '$totalProducts products',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.gapLG),

          // Progress bar
          _buildProgressBar(),
          const SizedBox(height: TossSpacing.gapMD),

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (totalProducts == 0) {
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            // Normal (녹색)
            if (normalCount > 0)
              Expanded(
                flex: normalCount,
                child: Container(color: TossColors.success),
              ),
            // Reorder (파란색)
            if (reorderCount > 0)
              Expanded(
                flex: reorderCount,
                child: Container(color: TossColors.primary),
              ),
            // Overstock (보라색)
            if (overstockCount > 0)
              Expanded(
                flex: overstockCount,
                child: Container(color: TossColors.purple),
              ),
            // Dead Stock (회색)
            if (deadStockCount > 0)
              Expanded(
                flex: deadStockCount,
                child: Container(color: TossColors.gray400),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final items = <_LegendItem>[
      _LegendItem(
        label: 'Normal',
        count: normalCount,
        color: TossColors.success,
        percentage: _calculatePercentage(normalCount),
      ),
      _LegendItem(
        label: 'Reorder',
        count: reorderCount,
        color: TossColors.primary,
        percentage: _calculatePercentage(reorderCount),
      ),
      _LegendItem(
        label: 'Overstock',
        count: overstockCount,
        color: TossColors.purple,
        percentage: _calculatePercentage(overstockCount),
      ),
      _LegendItem(
        label: 'Dead Stock',
        count: deadStockCount,
        color: TossColors.gray400,
        percentage: _calculatePercentage(deadStockCount),
      ),
    ];

    return Wrap(
      spacing: TossSpacing.gapLG,
      runSpacing: TossSpacing.gapSM,
      children: items.map((item) => _buildLegendItem(item)).toList(),
    );
  }

  Widget _buildLegendItem(_LegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: TossSpacing.gapXS),
        Text(
          item.label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(width: TossSpacing.gapXS),
        Text(
          '${item.percentage.toStringAsFixed(0)}%',
          style: TossTextStyles.caption.copyWith(
            color: item.color,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }

  double _calculatePercentage(int count) {
    if (totalProducts == 0) return 0;
    return (count / totalProducts) * 100;
  }
}

class _LegendItem {
  final String label;
  final int count;
  final Color color;
  final double percentage;

  const _LegendItem({
    required this.label,
    required this.count,
    required this.color,
    required this.percentage,
  });
}
