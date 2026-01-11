import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../themes/toss_colors.dart';
import '../../../themes/toss_spacing.dart';
import '../../../themes/toss_text_styles.dart';
import '../../molecules/skeleton/skeleton_presets.dart';

/// TossDetailSkeleton - 상세 페이지 스켈레톤 템플릿
///
/// 상세 페이지의 로딩 상태를 표시하는 스켈레톤입니다.
///
/// ## 사용법
/// ```dart
/// if (isLoading)
///   const TossDetailSkeleton(
///     showHeader: true,
///     showChart: true,
///     sectionCount: 3,
///   )
/// else
///   DetailContent(data: data)
/// ```
class TossDetailSkeleton extends StatelessWidget {
  /// 헤더 영역 표시 (아바타 + 제목)
  final bool showHeader;

  /// 차트 영역 표시
  final bool showChart;

  /// 섹션 개수
  final int sectionCount;

  /// 섹션당 아이템 개수
  final int itemsPerSection;

  /// shimmer 효과 활성화
  final bool enableShimmer;

  /// 페이지 패딩
  final EdgeInsets? padding;

  const TossDetailSkeleton({
    super.key,
    this.showHeader = true,
    this.showChart = true,
    this.sectionCount = 2,
    this.itemsPerSection = 3,
    this.enableShimmer = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: SingleChildScrollView(
        padding: padding ?? const EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              _buildHeader(),
              const SizedBox(height: TossSpacing.space6),
            ],
            if (showChart) ...[
              SkeletonPresets.chartPlaceholder(),
              const SizedBox(height: TossSpacing.space6),
            ],
            ...List.generate(
              sectionCount,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index < sectionCount - 1 ? TossSpacing.space6 : 0,
                ),
                child: _buildSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Bone.circle(size: 64),
        const SizedBox(width: TossSpacing.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(words: 3, style: TossTextStyles.h3),
              const SizedBox(height: TossSpacing.space2),
              const Bone.text(words: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Bone.text(words: 2),
        const SizedBox(height: TossSpacing.space3),
        ...List.generate(
          itemsPerSection,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Bone.text(words: 2),
                Bone.text(words: 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 프로필/계정 상세 스켈레톤
class TossProfileDetailSkeleton extends StatelessWidget {
  final bool enableShimmer;

  const TossProfileDetailSkeleton({
    super.key,
    this.enableShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          children: [
            // 프로필 헤더
            const SizedBox(height: TossSpacing.space6),
            const Bone.circle(size: 96),
            const SizedBox(height: TossSpacing.space4),
            Bone.text(words: 2, style: TossTextStyles.h3),
            const SizedBox(height: TossSpacing.space2),
            const Bone.text(words: 4),
            const SizedBox(height: TossSpacing.space8),

            // 정보 섹션
            _buildInfoSection(),
            const SizedBox(height: TossSpacing.space6),
            _buildInfoSection(),
            const SizedBox(height: TossSpacing.space6),

            // 액션 버튼
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < 2 ? TossSpacing.space3 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Bone.text(words: 2),
                Bone.text(words: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

/// 폼/입력 상세 스켈레톤
class TossFormDetailSkeleton extends StatelessWidget {
  final int fieldCount;
  final bool showHeader;
  final bool enableShimmer;

  const TossFormDetailSkeleton({
    super.key,
    this.fieldCount = 5,
    this.showHeader = true,
    this.enableShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enableShimmer,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              SkeletonPresets.pageTitle(),
              const SizedBox(height: TossSpacing.space6),
            ],
            ...List.generate(
              fieldCount,
              (index) => SkeletonPresets.inputField(),
            ),
            const SizedBox(height: TossSpacing.space6),
            // Submit 버튼
            Container(
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
