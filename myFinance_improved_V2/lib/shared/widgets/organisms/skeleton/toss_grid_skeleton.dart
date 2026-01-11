import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_spacing.dart';
import '../../molecules/skeleton/skeleton_presets.dart';

/// 그리드 스켈레톤 스타일
enum GridSkeletonStyle {
  /// 제품 그리드 (이미지 + 제품명 + 가격)
  product,

  /// 카드 그리드 (요약 카드)
  card,

  /// 통계 그리드 (숫자 + 라벨)
  stats,
}

/// TossGridSkeleton - 그리드 레이아웃 스켈레톤 템플릿
///
/// 그리드 페이지의 로딩 상태를 표시하는 스켈레톤입니다.
///
/// ## 사용법
/// ```dart
/// if (isLoading && items.isEmpty)
///   const TossGridSkeleton(
///     itemCount: 6,
///     crossAxisCount: 2,
///     style: GridSkeletonStyle.product,
///   )
/// else
///   ProductGrid(items: items)
/// ```
class TossGridSkeleton extends StatelessWidget {
  /// 스켈레톤 아이템 개수
  final int itemCount;

  /// 열 개수
  final int crossAxisCount;

  /// 그리드 스타일
  final GridSkeletonStyle style;

  /// shimmer 효과 활성화
  final bool enableShimmer;

  /// 그리드 패딩
  final EdgeInsets? padding;

  /// shrinkWrap 모드
  final bool shrinkWrap;

  /// 아이템 간 가로 간격
  final double crossAxisSpacing;

  /// 아이템 간 세로 간격
  final double mainAxisSpacing;

  /// 아이템 비율 (너비:높이)
  final double childAspectRatio;

  const TossGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.style = GridSkeletonStyle.product,
    this.enableShimmer = true,
    this.padding,
    this.shrinkWrap = false,
    this.crossAxisSpacing = TossSpacing.space3,
    this.mainAxisSpacing = TossSpacing.space3,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: GridView.builder(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        padding: padding ?? const EdgeInsets.all(TossSpacing.paddingMD),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    switch (style) {
      case GridSkeletonStyle.product:
        return SkeletonPresets.productGridItem();
      case GridSkeletonStyle.card:
        return SkeletonPresets.summaryCard();
      case GridSkeletonStyle.stats:
        return SkeletonPresets.statsCard();
    }
  }
}

/// 가로 스크롤 그리드 스켈레톤 (대시보드 카드 등)
class TossHorizontalGridSkeleton extends StatelessWidget {
  final int itemCount;
  final GridSkeletonStyle style;
  final bool enableShimmer;
  final EdgeInsets? padding;
  final double? itemWidth;
  final double? height;

  const TossHorizontalGridSkeleton({
    super.key,
    this.itemCount = 4,
    this.style = GridSkeletonStyle.card,
    this.enableShimmer = true,
    this.padding,
    this.itemWidth,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 120,
      child: Skeletonizer(
        enabled: enableShimmer,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: SizedBox(
                width: itemWidth ?? 140,
                child: _buildItem(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem() {
    switch (style) {
      case GridSkeletonStyle.product:
        return SkeletonPresets.productGridItem();
      case GridSkeletonStyle.card:
        return SkeletonPresets.summaryCard();
      case GridSkeletonStyle.stats:
        return SkeletonPresets.statsCard();
    }
  }
}
