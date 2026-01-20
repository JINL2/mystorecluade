import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_status.dart';

/// 상태 필터 아이템
class StatusFilterItem {
  final InventoryStatus status;
  final int count;
  final String label;

  const StatusFilterItem({
    required this.status,
    required this.count,
    required this.label,
  });
}

/// 상태 필터 칩 그리드 (2026 트렌드 적용)
///
/// 클릭하면 해당 상태의 상품 목록으로 이동
/// - 색상으로 상태 구분
/// - 숫자와 라벨 표시
/// - Warning 상태 추가됨
class StatusFilterChips extends StatelessWidget {
  final List<StatusFilterItem> filters;
  final void Function(InventoryStatus status)? onTap;

  const StatusFilterChips({
    super.key,
    required this.filters,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: TossSpacing.gapSM,
      runSpacing: TossSpacing.gapSM,
      children: filters.map((filter) => _buildChip(filter)).toList(),
    );
  }

  Widget _buildChip(StatusFilterItem filter) {
    final color = _getStatusColor(filter.status);

    return InkWell(
      onTap: filter.count > 0 && onTap != null
          ? () => onTap!(filter.status)
          : null,
      borderRadius: BorderRadius.circular(TossBorderRadius.button),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingSM,
          vertical: TossSpacing.paddingXS,
        ),
        decoration: BoxDecoration(
          color: filter.count > 0 ? color.withOpacity(0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.button),
          border: Border.all(
            color:
                filter.count > 0 ? color.withOpacity(0.3) : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(filter.status),
              size: 16,
              color: filter.count > 0 ? color : TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.gapXS),
            Text(
              filter.label,
              style: TossTextStyles.caption.copyWith(
                color: filter.count > 0 ? color : TossColors.gray400,
                fontWeight: TossFontWeight.medium,
              ),
            ),
            const SizedBox(width: TossSpacing.gapXS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.paddingXS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: filter.count > 0 ? color : TossColors.gray300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${filter.count}',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.white,
                  fontWeight: TossFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(InventoryStatus status) {
    return switch (status) {
      InventoryStatus.abnormal => TossColors.error,
      InventoryStatus.stockout => TossColors.error,
      InventoryStatus.critical => TossColors.amber,
      InventoryStatus.warning => TossColors.amberDark,
      InventoryStatus.reorderNeeded => TossColors.primary,
      InventoryStatus.deadStock => TossColors.gray500,
      InventoryStatus.overstock => TossColors.purple,
      InventoryStatus.normal => TossColors.success,
    };
  }

  IconData _getStatusIcon(InventoryStatus status) {
    return switch (status) {
      InventoryStatus.abnormal => Icons.error_outline,
      InventoryStatus.stockout => Icons.remove_shopping_cart_outlined,
      InventoryStatus.critical => Icons.local_fire_department_rounded,
      InventoryStatus.warning => Icons.warning_amber_rounded,
      InventoryStatus.reorderNeeded => Icons.shopping_cart_outlined,
      InventoryStatus.deadStock => Icons.hourglass_empty_rounded,
      InventoryStatus.overstock => Icons.inventory_outlined,
      InventoryStatus.normal => Icons.check_circle_outline,
    };
  }
}
