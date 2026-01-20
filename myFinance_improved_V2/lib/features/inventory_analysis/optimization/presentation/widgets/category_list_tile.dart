import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/category_summary.dart';

/// 카테고리 리스트 타일 위젯
class CategoryListTile extends StatelessWidget {
  final CategorySummary category;
  final VoidCallback? onTap;

  const CategoryListTile({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Row(
        children: [
          // 카테고리 아이콘 (기본 아이콘 사용)
          Container(
            padding: const EdgeInsets.all(TossSpacing.paddingSM),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
            child: Icon(
              Icons.category_outlined,
              size: 24,
              color: TossColors.primary,
            ),
          ),
          const SizedBox(width: TossSpacing.gapLG),

          // 카테고리 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: TossTextStyles.subtitle.copyWith(
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(height: TossSpacing.marginXS),
                Text(
                  '${category.totalProducts} products',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // 상태 배지들
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (category.abnormalCount > 0)
                _StatusBadge(
                  emoji: '🚨',
                  count: category.abnormalCount,
                  color: TossColors.error,
                ),
              if (category.criticalCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: TossSpacing.marginXS),
                  child: _StatusBadge(
                    emoji: '🔥',
                    count: category.criticalCount,
                    color: TossColors.amber,
                  ),
                ),
              if (category.reorderNeededCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: TossSpacing.marginXS),
                  child: _StatusBadge(
                    emoji: '📦',
                    count: category.reorderNeededCount,
                    color: TossColors.primary,
                  ),
                ),
            ],
          ),

          const SizedBox(width: TossSpacing.gapSM),
          Icon(
            Icons.chevron_right,
            color: TossColors.textSecondary,
            size: TossSpacing.iconMD2,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String emoji;
  final int count;
  final Color color;

  const _StatusBadge({
    required this.emoji,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingXS,
        vertical: TossSpacing.marginXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.chip),
      ),
      child: Text(
        '$emoji $count',
        style: TossTextStyles.small.copyWith(
          color: color,
          fontWeight: TossFontWeight.semibold,
        ),
      ),
    );
  }
}
