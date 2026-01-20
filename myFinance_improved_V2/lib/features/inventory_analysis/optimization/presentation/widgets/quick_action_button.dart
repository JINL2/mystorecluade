import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_status.dart';

/// 빠른 액션 버튼 위젯
class QuickActionButton extends StatelessWidget {
  final InventoryStatus status;
  final int count;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.status,
    required this.count,
    this.onTap,
  });

  Color get _color {
    return switch (status) {
      InventoryStatus.abnormal => TossColors.error,
      InventoryStatus.stockout => TossColors.error,
      InventoryStatus.critical => TossColors.amber,
      InventoryStatus.warning => TossColors.amberDark,
      InventoryStatus.reorderNeeded => TossColors.primary,
      InventoryStatus.deadStock => TossColors.textSecondary,
      InventoryStatus.overstock => TossColors.purple,
      InventoryStatus.normal => TossColors.success,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.paddingMD,
          horizontal: TossSpacing.paddingSM,
        ),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.card),
          border: Border.all(color: _color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${status.emoji} ${status.labelEn}',
              style: TossTextStyles.body.copyWith(
                color: _color,
                fontWeight: TossFontWeight.semibold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.marginXS),
            Text(
              '$count',
              style: TossTextStyles.h4.copyWith(
                color: _color,
                fontWeight: TossFontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 빠른 액션 버튼 그리드 위젯
class QuickActionGrid extends StatelessWidget {
  final int abnormalCount;
  final int criticalCount;
  final int reorderCount;
  final int deadStockCount;
  final void Function(InventoryStatus status)? onTap;

  const QuickActionGrid({
    super.key,
    required this.abnormalCount,
    required this.criticalCount,
    required this.reorderCount,
    required this.deadStockCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TossTextStyles.subtitle.copyWith(
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.gapMD),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                status: InventoryStatus.abnormal,
                count: abnormalCount,
                onTap: onTap != null
                    ? () => onTap!(InventoryStatus.abnormal)
                    : null,
              ),
            ),
            const SizedBox(width: TossSpacing.gapSM),
            Expanded(
              child: QuickActionButton(
                status: InventoryStatus.critical,
                count: criticalCount,
                onTap: onTap != null
                    ? () => onTap!(InventoryStatus.critical)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.gapSM),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                status: InventoryStatus.reorderNeeded,
                count: reorderCount,
                onTap: onTap != null
                    ? () => onTap!(InventoryStatus.reorderNeeded)
                    : null,
              ),
            ),
            const SizedBox(width: TossSpacing.gapSM),
            Expanded(
              child: QuickActionButton(
                status: InventoryStatus.deadStock,
                count: deadStockCount,
                onTap: onTap != null
                    ? () => onTap!(InventoryStatus.deadStock)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
