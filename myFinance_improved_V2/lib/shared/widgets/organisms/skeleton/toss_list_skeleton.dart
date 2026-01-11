import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_spacing.dart';
import '../../molecules/skeleton/skeleton_presets.dart';

/// 리스트 스켈레톤 스타일
enum ListSkeletonStyle {
  /// 기본 리스트 아이템 (아바타 + 제목 + 부제목)
  standard,

  /// 제품 리스트 (이미지 + 제품명 + SKU + 가격)
  product,

  /// 거래 내역 (아이콘 + 거래처 + 날짜 / 금액 + 상태)
  transaction,

  /// 컴팩트 리스트 (작은 아바타)
  compact,
}

/// TossListSkeleton - 전체 리스트 스켈레톤 템플릿
///
/// 리스트 페이지의 로딩 상태를 표시하는 스켈레톤입니다.
///
/// ## 사용법
/// ```dart
/// if (isLoading && items.isEmpty)
///   const TossListSkeleton(
///     itemCount: 8,
///     style: ListSkeletonStyle.product,
///   )
/// else
///   ProductList(items: items)
/// ```
class TossListSkeleton extends StatelessWidget {
  /// 스켈레톤 아이템 개수
  final int itemCount;

  /// 리스트 스타일
  final ListSkeletonStyle style;

  /// shimmer 효과 활성화
  final bool enableShimmer;

  /// 리스트 패딩
  final EdgeInsets? padding;

  /// shrinkWrap 모드 (부모에 맞춤)
  final bool shrinkWrap;

  /// 스크롤 방향
  final Axis scrollDirection;

  const TossListSkeleton({
    super.key,
    this.itemCount = 5,
    this.style = ListSkeletonStyle.standard,
    this.enableShimmer = true,
    this.padding,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        scrollDirection: scrollDirection,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    switch (style) {
      case ListSkeletonStyle.standard:
        return SkeletonPresets.listItem();
      case ListSkeletonStyle.product:
        return SkeletonPresets.productCard();
      case ListSkeletonStyle.transaction:
        return SkeletonPresets.transactionItem();
      case ListSkeletonStyle.compact:
        return SkeletonPresets.listItemCompact();
    }
  }
}

/// 분리된 리스트 스켈레톤 (구분선 포함)
class TossSeparatedListSkeleton extends StatelessWidget {
  final int itemCount;
  final ListSkeletonStyle style;
  final bool enableShimmer;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const TossSeparatedListSkeleton({
    super.key,
    this.itemCount = 5,
    this.style = ListSkeletonStyle.standard,
    this.enableShimmer = true,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    switch (style) {
      case ListSkeletonStyle.standard:
        return SkeletonPresets.listItem();
      case ListSkeletonStyle.product:
        return SkeletonPresets.productCard();
      case ListSkeletonStyle.transaction:
        return SkeletonPresets.transactionItem();
      case ListSkeletonStyle.compact:
        return SkeletonPresets.listItemCompact();
    }
  }
}

/// 섹션 헤더가 포함된 리스트 스켈레톤
class TossSectionedListSkeleton extends StatelessWidget {
  final int sectionCount;
  final int itemsPerSection;
  final ListSkeletonStyle style;
  final bool enableShimmer;
  final EdgeInsets? padding;

  const TossSectionedListSkeleton({
    super.key,
    this.sectionCount = 2,
    this.itemsPerSection = 3,
    this.style = ListSkeletonStyle.standard,
    this.enableShimmer = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: ListView.builder(
        padding: padding,
        itemCount: sectionCount,
        itemBuilder: (context, sectionIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonPresets.sectionHeader(showAction: sectionIndex == 0),
              ...List.generate(
                itemsPerSection,
                (_) => _buildItem(),
              ),
              if (sectionIndex < sectionCount - 1)
                const SizedBox(height: TossSpacing.space4),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem() {
    switch (style) {
      case ListSkeletonStyle.standard:
        return SkeletonPresets.listItem();
      case ListSkeletonStyle.product:
        return SkeletonPresets.productCard();
      case ListSkeletonStyle.transaction:
        return SkeletonPresets.transactionItem();
      case ListSkeletonStyle.compact:
        return SkeletonPresets.listItemCompact();
    }
  }
}
