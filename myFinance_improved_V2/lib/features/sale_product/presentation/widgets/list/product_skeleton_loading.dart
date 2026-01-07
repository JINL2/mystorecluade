import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';

/// Skeleton loading widget for product list
/// Shows shimmer effect while products are loading
class ProductSkeletonLoading extends StatelessWidget {
  /// Number of skeleton items to show
  final int itemCount;

  const ProductSkeletonLoading({
    super.key,
    this.itemCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: TossColors.gray100,
      highlightColor: TossColors.gray50,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingMD,
          vertical: TossSpacing.space1,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const _SkeletonProductTile(),
      ),
    );
  }
}

/// Single skeleton product tile matching SelectableProductTile layout
class _SkeletonProductTile extends StatelessWidget {
  const _SkeletonProductTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray100, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Product image skeleton
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
          const SizedBox(width: 12),
          // Product info skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                // SKU
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                // Price
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Add button skeleton
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        ],
      ),
    );
  }
}
