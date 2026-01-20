import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_status.dart';

/// 재고 상태 배지 위젯
/// 8가지 상태에 맞는 색상과 스타일 적용
class InventoryStatusBadge extends StatelessWidget {
  final InventoryStatus status;
  final bool showEmoji;
  final bool compact;

  const InventoryStatusBadge({
    super.key,
    required this.status,
    this.showEmoji = true,
    this.compact = false,
  });

  /// 상태별 색상 매핑
  Color get _backgroundColor {
    return switch (status) {
      InventoryStatus.abnormal => TossColors.error.withOpacity(0.1),
      InventoryStatus.stockout => TossColors.error.withOpacity(0.1),
      InventoryStatus.critical => TossColors.amber.withOpacity(0.15),
      InventoryStatus.warning => TossColors.amberLight,
      InventoryStatus.reorderNeeded => TossColors.primarySurface,
      InventoryStatus.deadStock => TossColors.gray100,
      InventoryStatus.overstock => TossColors.purpleLight,
      InventoryStatus.normal => TossColors.successLight,
    };
  }

  Color get _textColor {
    return switch (status) {
      InventoryStatus.abnormal => TossColors.error,
      InventoryStatus.stockout => TossColors.error,
      InventoryStatus.critical => TossColors.amberDark,
      InventoryStatus.warning => TossColors.amberDark,
      InventoryStatus.reorderNeeded => TossColors.primary,
      InventoryStatus.deadStock => TossColors.textSecondary,
      InventoryStatus.overstock => TossColors.purple,
      InventoryStatus.normal => TossColors.success,
    };
  }

  Color get _borderColor {
    return switch (status) {
      InventoryStatus.abnormal => TossColors.error.withOpacity(0.3),
      InventoryStatus.stockout => TossColors.error.withOpacity(0.3),
      InventoryStatus.critical => TossColors.amber.withOpacity(0.5),
      InventoryStatus.warning => TossColors.amber.withOpacity(0.3),
      InventoryStatus.reorderNeeded => TossColors.primary.withOpacity(0.3),
      InventoryStatus.deadStock => TossColors.border,
      InventoryStatus.overstock => TossColors.purple.withOpacity(0.3),
      InventoryStatus.normal => TossColors.success.withOpacity(0.3),
    };
  }

  @override
  Widget build(BuildContext context) {
    final label = showEmoji ? '${status.emoji} ${status.labelEn}' : status.labelEn;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? TossSpacing.paddingXS : TossSpacing.paddingSM,
        vertical: compact ? TossSpacing.marginXS : TossSpacing.gapXS,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.chip),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        label,
        style: (compact ? TossTextStyles.small : TossTextStyles.caption).copyWith(
          color: _textColor,
          fontWeight: TossFontWeight.semibold,
        ),
      ),
    );
  }
}

/// 상태별 아이콘 위젯
class InventoryStatusIcon extends StatelessWidget {
  final InventoryStatus status;
  final double size;

  const InventoryStatusIcon({
    super.key,
    required this.status,
    this.size = 20,
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

  IconData get _icon {
    return switch (status) {
      InventoryStatus.abnormal => Icons.warning_rounded,
      InventoryStatus.stockout => Icons.inventory_2_outlined,
      InventoryStatus.critical => Icons.local_fire_department_rounded,
      InventoryStatus.warning => Icons.warning_amber_rounded,
      InventoryStatus.reorderNeeded => Icons.shopping_cart_outlined,
      InventoryStatus.deadStock => Icons.hourglass_empty_rounded,
      InventoryStatus.overstock => Icons.trending_up_rounded,
      InventoryStatus.normal => Icons.check_circle_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      color: _color,
      size: size,
    );
  }
}
