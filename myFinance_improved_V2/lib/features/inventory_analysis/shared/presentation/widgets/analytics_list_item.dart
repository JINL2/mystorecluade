import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'analytics_status_badge.dart';

/// 리스트 아이템 위젯
/// 상세 페이지에서 제품/카테고리 목록 표시
class AnalyticsListItem extends StatelessWidget {
  final String title;
  final String? sku;
  final String? subtitle;
  final String? value;
  final String? subValue;
  final String? status;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// 권장 주문 수량 (0보다 크면 표시)
  final int? orderQty;

  const AnalyticsListItem({
    super.key,
    required this.title,
    this.sku,
    this.subtitle,
    this.value,
    this.subValue,
    this.status,
    this.leading,
    this.trailing,
    this.onTap,
    this.orderQty,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Leading
            if (leading != null) ...[
              leading!,
              const SizedBox(width: TossSpacing.space3),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (status != null) ...[
                        const SizedBox(width: 8),
                        PriorityBadge(priority: status!),
                      ],
                    ],
                  ),
                  // SKU (제품명 바로 아래, caption style)
                  if (sku != null && sku!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      sku!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // Subtitle (category 등)
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Value or Trailing
            if (trailing != null)
              trailing!
            else if (value != null) ...[
              const SizedBox(width: TossSpacing.space3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value!,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subValue != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subValue!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                  // 권장 주문 수량 표시
                  if (orderQty != null && orderQty! > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Order: $orderQty',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Chevron
            if (onTap != null) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rank 아이콘 위젯 (1위, 2위, 3위 특별 표시)
class RankIcon extends StatelessWidget {
  final int rank;

  const RankIcon({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _getRankColor(rank),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$rank',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: TossColors.gray100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    return switch (rank) {
      1 => const Color(0xFFFFD700), // Gold
      2 => const Color(0xFFC0C0C0), // Silver
      3 => const Color(0xFFCD7F32), // Bronze
      _ => TossColors.gray400,
    };
  }
}
